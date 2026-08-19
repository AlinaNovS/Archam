import json
import re
import shutil
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
]

cards = json.load(CARDS_EN.open(encoding='utf-8'))
OFFICIAL = {str(c['code']) for c in cards if c.get('code')}


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


def map_stem(prefix: str, stem: str):
    stem = stem.lower()
    if stem.endswith('-mini'):
        return []
    m = re.fullmatch(r'(\d{1,3})([ab])-(\d{1,3})([ab])', stem)
    if m:
        a, s1, b, s2 = m.groups()
        a = int(a)
        b = int(b)
        if s1 == s2 and a <= b:
            return [best_code(prefix, i, s1) for i in range(a, b + 1)]
        return []
    m = re.fullmatch(r'(\d{1,3})([ab]?)-(\d+)', stem)
    if m:
        n, side, _copy = m.groups()
        return [best_code(prefix, int(n), side)]
    m = re.fullmatch(r'(\d{1,3})([ab]?)', stem)
    if m:
        n, side = m.groups()
        return [best_code(prefix, int(n), side)]
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
            codes = map_stem(prefix, p.stem)
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
        copied += 1
    result[f'cards/{code}.avif'] = f'/img/arkham/ru-local-raw/{dst.name}'

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
