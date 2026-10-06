import json
import re
import subprocess
from pathlib import Path

FRONTEND = Path('/opt/ArkhamHorror/frontend')
CARDS_EN = FRONTEND / 'public/cards_en.json'
TARGET = FRONTEND / 'public/img/arkham/ru/cards'
DIGEST = FRONTEND / 'src/digests/ru.json'
TARGET.mkdir(parents=True, exist_ok=True)

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
conflicts = {}
unmapped = []
source_counts = {}

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
        source_counts.setdefault(prefix, 0)
        for p in raw_folder.rglob('*'):
            if not p.is_file():
                continue
            if p.suffix.lower() not in {'.png', '.jpg', '.jpeg', '.webp', '.avif'}:
                continue
            source_counts[prefix] += 1
            codes = map_stem(prefix, p.stem)
            if not codes:
                unmapped.append(str(p.relative_to(raw_folder)))
                continue
            for code in codes:
                if code not in OFFICIAL and not code.endswith('b'):
                    continue
                cur = mapping.get(code)
                if cur is None or rank_source(source_name, p) < rank_source(cur[0], cur[1]):
                    mapping[code] = (source_name, p)
                conflicts.setdefault(code, set()).add(f'{source_name}:{p}')

selected = {k: v for k, v in mapping.items() if k in OFFICIAL or k.endswith('b')}
print('selected_codes', len(selected))
print('unmapped_files', len(unmapped))
print('source_image_counts', json.dumps(source_counts, ensure_ascii=False, sort_keys=True))
print('unmapped_sample', unmapped[:20])

converted = 0
failed = []
for code, (source_name, src) in sorted(selected.items()):
    dst = TARGET / f'{code}.avif'
    cmd = [
        'ffmpeg', '-y', '-loglevel', 'error', '-i', str(src),
        '-frames:v', '1', '-pix_fmt', 'yuv420p', '-still-picture', '1',
        '-c:v', 'libaom-av1', '-crf', '38', '-b:v', '0', str(dst)
    ]
    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode != 0:
        failed.append((code, source_name, str(src), res.stderr.strip()[:500]))
        if dst.exists():
            dst.unlink()
        continue
    converted += 1

for p in TARGET.glob('test_*'):
    p.unlink()

paths = []
for p in sorted(TARGET.glob('*.avif')):
    paths.append(f'cards/{p.name}')

DIGEST.write_text(json.dumps(paths, ensure_ascii=False, indent=2), encoding='utf-8')

multi = {k: sorted(v) for k, v in conflicts.items() if len(v) > 1}
print('converted', converted)
print('failed', len(failed))
for item in failed[:20]:
    print('FAIL', item[0], item[1], item[2], item[3])
print('target_files', len(paths))
print('multi_source_codes', len(multi))
for code in sorted(list(multi)[:20]):
    print('MULTI', code, multi[code][:5])
