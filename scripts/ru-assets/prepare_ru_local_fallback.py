import json
import re
import shutil
import struct
import subprocess
from pathlib import Path

FRONTEND = Path('/opt/ArkhamHorror/frontend')
CARDS_EN = FRONTEND / 'public/cards_en.json'
TARGET_RAW = FRONTEND / 'public/img/arkham/ru-local-raw'
TARGET_RAW.mkdir(parents=True, exist_ok=True)
REMOTE_MANIFEST = FRONTEND / 'src/digests/ru-remote.json'
RU_DIGEST = FRONTEND / 'src/digests/ru.json'
RU_AVIF_DIR = FRONTEND / 'public/img/arkham/ru/cards'

SOURCE_ROOTS = [
    ('root_full', Path('/var/lib/arkham-content/gdrive_root_full/1. Циклы')),
    ('cards_full', Path('/var/lib/arkham-content/gdrive_cards_full')),
    ('ru_cache', Path('/var/lib/arkham-content/gdrive_ru_cache/Arkham_Horror_LCG/1. Циклы')),
    ('mac_cycles', Path('/var/lib/arkham-content/mac_import/cycles')),
]


def _png_wh(path):
    try:
        with open(path, "rb") as fh:
            sig = fh.read(8)
            if sig != b"\x89PNG\r\n\x1a\n":
                return None
            fh.read(4)
            if fh.read(4) != b"IHDR":
                return None
            return struct.unpack(">II", fh.read(8))
    except Exception:
        return None


def _get_wh(path):
    try:
        r = subprocess.run(
            ["ffprobe", "-v", "error", "-select_streams", "v:0",
             "-show_entries", "stream=width,height", "-of", "csv=p=0", str(path)],
            capture_output=True, text=True,
        )
        w, h = r.stdout.strip().split(",")
        return int(w), int(h)
    except Exception:
        return None


def _landscape_transpose(code, type_by_code):
    """Return the ffmpeg transpose value needed to fix this scan's orientation,
    or None if it should stay as-is. Card-type-driven, not tied to any one
    source resolution — Hobby World scans across products vary in size.

    Raw scans were digitized in two different physical passes with opposite
    rotation, and this split is by front/back across ALL landscape-needing
    types (act, agenda, investigator): BACKS need transpose=2 (90° CCW),
    FRONTS need transpose=1 (90° CW) — confirmed by visual inspection on both
    an investigator (11001) and an act card (05044): applying transpose=2 to
    a front produces an upside-down card, transpose=1 reads correctly."""
    import re as _re
    base = _re.sub(r"[ab]$", "", code)
    is_back = code.endswith("b")
    t = type_by_code.get(code) or type_by_code.get(base)
    if t in ("act", "agenda", "investigator"):
        return 2 if is_back else 1
    return None


def _rotate_inv_back(path, code, type_by_code):
    transpose = _landscape_transpose(code, type_by_code)
    if transpose is None:
        return
    wh = _get_wh(path)
    if wh is None or wh[1] <= wh[0]:
        return
    tmp = path.with_suffix(".rot" + path.suffix)
    r = subprocess.run(
        ["ffmpeg", "-y", "-i", str(path), "-vf", f"transpose={transpose}", "-q:v", "2", str(tmp)],
        capture_output=True,
    )
    if r.returncode == 0:
        tmp.replace(path)
        path.chmod(0o644)
    elif tmp.exists():
        tmp.unlink()


cards = json.load(CARDS_EN.open(encoding='utf-8'))
OFFICIAL = {str(c['code']) for c in cards if c.get('code')}
TYPE_BY_CODE = {str(c['code']): c.get('type_code') for c in cards if c.get('code')}


def best_code(prefix: str, n: int, side: str):
    base = f'{prefix}{n:03d}'
    if side == 'a':
        if f'{base}a' in OFFICIAL:
            return f'{base}a'
        if base in OFFICIAL:
            return base
        return f'{base}a'
    if side == 'b':
        if f'{base}b' in OFFICIAL:
            return f'{base}b'
        return f'{base}b'
    if base in OFFICIAL:
        return base
    if f'{base}a' in OFFICIAL:
        return f'{base}a'
    return base


# Some cycles ship as two separate physical sub-boxes (e.g. Hemlock Vale's
# investigator expansion + campaign box) whose scan filenames both restart
# position numbering from 1, even though only one of the two sub-boxes'
# digital card codes actually start near 1 -- the other's codes continue at
# an offset. Confirmed for Hemlock Vale by comparing scan position ranges
# (investigators 1-138, campaign 1-243) against cards_en.json's actual code
# ranges (fhvp 10001-10138 = no offset needed, fhvc 10501-10743 = +500).
SUBFOLDER_OFFSETS = {
    'Хемлок-Вейл Кампания': 500,
    'Краю Земли Кампания': 500,
    'Алые Ключи Кампания': 500,
}


def _offset_for(path: Path) -> int:
    s = str(path)
    for key, off in SUBFOLDER_OFFSETS.items():
        if key in s:
            return off
    return 0


def map_stem(prefix: str, stem: str, offset: int = 0):
    stem = stem.lower()
    if stem.endswith('-mini'):
        return []
    m = re.fullmatch(r'(\d{1,3})([ab])-(\d{1,3})([ab])', stem)
    if m:
        a, s1, b, s2 = m.groups()
        a = int(a) + offset
        b = int(b) + offset
        if s1 == s2 and a <= b:
            return [best_code(prefix, i, s1) for i in range(a, b + 1)]
        return []
    m = re.fullmatch(r'(\d{1,3})([ab]?)-(\d+)', stem)
    if m:
        n, side, _copy = m.groups()
        return [best_code(prefix, int(n) + offset, side)]
    m = re.fullmatch(r'(\d{1,3})([ab]?)', stem)
    if m:
        n, side = m.groups()
        return [best_code(prefix, int(n) + offset, side)]
    return []


def rank_source(source_name: str, path: Path):
    source_priority = {'root_full': 0, 'cards_full': 1, 'ru_cache': 2}.get(source_name, 9)
    stem = path.stem.lower()
    copy_match = re.fullmatch(r'.*-(\d+)$', stem)
    copy_num = int(copy_match.group(1)) if copy_match else 0
    ext_score = {'.png': 0, '.jpg': 1, '.jpeg': 1, '.webp': 2, '.avif': 3}.get(path.suffix.lower(), 9)
    rel = str(path).lower()
    old_penalty = 5 if '/old/' in rel else 0
    hidden_penalty = 2 if 'сокрытые карты' in rel else 0
    return (source_priority, old_penalty, hidden_penalty, copy_num, ext_score, len(path.name))


mapping = {}
for source_name, root in SOURCE_ROOTS:
    if not root.exists():
        continue
    for cycle_dir in sorted([p for p in root.iterdir() if p.is_dir()]):
        m = re.match(r'^(\d{2})\b', cycle_dir.name)
        if not m:
            continue
        prefix = m.group(1)
        raw_folder = cycle_dir / 'Покарточная Сборка'
        if not raw_folder.exists():
            continue
        for p in raw_folder.rglob('*'):
            if not p.is_file():
                continue
            if p.suffix.lower() not in {'.png', '.jpg', '.jpeg', '.webp', '.avif'}:
                continue
            codes = map_stem(prefix, p.stem, _offset_for(p))
            if not codes:
                continue
            for code in codes:
                if code not in OFFICIAL and not code.endswith('b'):
                    continue
                cur = mapping.get(code)
                if cur is None or rank_source(source_name, p) < rank_source(cur[0], cur[1]):
                    mapping[code] = (source_name, p)

result = {}
copied = 0
for code, (_source_name, src) in sorted(mapping.items()):
    ext = src.suffix.lower()
    dst = TARGET_RAW / f'{code}{ext}'
    if not dst.exists() or src.stat().st_size != dst.stat().st_size:
        shutil.copy2(src, dst)
        dst.chmod(0o644)
        _rotate_inv_back(dst, code, TYPE_BY_CODE)
        copied += 1
    result[f'cards/{code}.avif'] = f'/img/arkham/ru-local-raw/{dst.name}?v={int(dst.stat().st_mtime)}'

ru_paths = []
for p in sorted(RU_AVIF_DIR.glob('*.avif')):
    ru_paths.append(f'cards/{p.name}')
RU_DIGEST.write_text(json.dumps(ru_paths, ensure_ascii=False, indent=2), encoding='utf-8')
REMOTE_MANIFEST.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')

print('mapped_codes', len(result))
print('copied_files', copied)
print('ru_avif_files', len(ru_paths))
for sample in ['01079', '03321a', '05111', '06026', '08053', '09100']:
    key = f'cards/{sample}.avif'
    print(sample, key in result, result.get(key))
