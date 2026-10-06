import json
import re
import shutil
import subprocess
from pathlib import Path
from collections import defaultdict

FRONTEND = Path('/opt/ArkhamHorror/frontend')
CARDS_EN = FRONTEND / 'public/cards_en.json'
TARGET_RAW = FRONTEND / 'public/img/arkham/ru-local-raw'
TARGET_RAW.mkdir(parents=True, exist_ok=True)
REMOTE_MANIFEST = FRONTEND / 'src/digests/ru-remote.json'

# PI_ side-story packs share ONE continuous "900xx" code range across all of
# them, and their raw-scan filenames use the absolute 2-digit tail of that
# shared code (e.g. "17.png" -> "90017"), not a per-pack position starting at 1.
FIXED_PREFIX_PACKS = {
    'Read or Die': ('900', 2),
    'All or Nothing': ('900', 2),
    'Bad Blood': ('900', 2),
    'By the Book': ('900', 2),
    'Red Tide Rising': ('900', 2),
    'On the Road Again': ('900', 2),
    'Laid to Rest': ('900', 2),
    'Path of the Righteous': ('900', 2),
    'Relics of the Past': ('900', 2),
    'Hunting for Answers': ('900', 2),
    'Aura of Faith': ('900', 2),
    'Pistols and Pearls': ('900', 2),
    'Enthralling Encore': ('900', 2),
}

# (pack_name in cards_en.json, path to the raw-scan folder)
TARGETS = [
    ('Nathaniel Cho', '/var/lib/arkham-content/gdrive_cards_full/SI_01 Натаниэль Чо (Hobby World)/Покарточная Сборка'),
    ('Harvey Walters', '/var/lib/arkham-content/gdrive_cards_full/SI_02 Харви Уолтерс (Hobby World)/Покарточная Сборка'),
    ('Winifred Habbamock', '/var/lib/arkham-content/gdrive_cards_full/SI_03 Уинифред Хаббамок (Hobby World)/Покарточная Сборка'),
    ('Jacqueline Fine', '/var/lib/arkham-content/gdrive_cards_full/SI_04 Жаклин Файн (Hobby World)/Покарточная Сборка'),
    ('Stella Clark', '/var/lib/arkham-content/gdrive_cards_full/SI_05 Стелла Кларк (Hobby World)/Покарточная Сборка'),

    ('Read or Die', '/var/lib/arkham-content/mac_import/si_pi/PI Альтернативные Сыщики и Сценарии/PI_01 Прочти или Умри (Hobby World)/Покарточная Сборка'),
    ('All or Nothing', '/var/lib/arkham-content/gdrive_cards_full/PI Альтернативные Сыщики и Сценарии/PI_02 Всё или Ничего (Hobby World)/Покарточная Сборка'),
    ('Bad Blood', '/var/lib/arkham-content/gdrive_cards_full/PI Альтернативные Сыщики и Сценарии/PI_03 Кровная Вражда (Hobby World)/Покарточная Сборка'),
    ('By the Book', '/var/lib/arkham-content/gdrive_cards_full/PI Альтернативные Сыщики и Сценарии/PI_04 По Букве Закона (Hobby World)/Покарточная Сборка'),
    ('Red Tide Rising', '/var/lib/arkham-content/gdrive_cards_full/PI Альтернативные Сыщики и Сценарии/PI_05 Алый Прилив (Любительский Перевод)/Покарточная Сборка'),
    ('On the Road Again', '/var/lib/arkham-content/gdrive_cards_full/PI Альтернативные Сыщики и Сценарии/PI_06 Снова в Пути (Любительский Перевод)/Покарточная Сборка'),
    ('Laid to Rest', '/var/lib/arkham-content/gdrive_cards_full/PI Альтернативные Сыщики и Сценарии/PI_07 Упокоение (Любительский Перевод)/Покарточная Сборка'),
    ('Path of the Righteous', '/var/lib/arkham-content/gdrive_cards_full/PI Альтернативные Сыщики и Сценарии/PI_08 Путь Праведных (Любительский Перевод)/Покарточная Сборка'),
    ('Relics of the Past', '/var/lib/arkham-content/gdrive_cards_full/PI Альтернативные Сыщики и Сценарии/PI_09 Реликвии Прошлого (Любительский Перевод)/Покарточная Сборка'),
    ('Hunting for Answers', '/var/lib/arkham-content/gdrive_cards_full/PI Альтернативные Сыщики и Сценарии/PI_10 Поиск Ответов (Любительский перевод)/Покарточная Сборка'),
    ('Aura of Faith', '/var/lib/arkham-content/gdrive_cards_full/PI Альтернативные Сыщики и Сценарии/PI_11 Аура Веры (Любительский перевод)/Покарточная Сборка'),
    ('Pistols and Pearls', '/var/lib/arkham-content/gdrive_cards_full/PI Альтернативные Сыщики и Сценарии/PI_12 Пистолеты и Жемчуг (Любительский перевод)/Покарточная Сборка'),
    ('Enthralling Encore', '/var/lib/arkham-content/gdrive_cards_full/PI Альтернативные Сыщики и Сценарии/PI_13 Увлекательный Бис (Любительский перевод)/Покарточная Сборка'),

    ('Curse of the Rougarou', '/var/lib/arkham-content/mac_import/sa/SA_01 Проклятие Ругару (Hobby World)/Покарточная Сборка'),
    ('Carnevale of Horrors', '/var/lib/arkham-content/mac_import/sa/SA_02 Карнавал Ужасов (Hobby World)/Покарточная Сборка'),
    ('The Labyrinths of Lunacy', '/var/lib/arkham-content/mac_import/sa/SA_03 Лабиринты Безумия (Hobby World)/Покарточная Сборка'),
    ('Guardians of the Abyss', '/var/lib/arkham-content/mac_import/sa/SA_04 Стражи Бездны (Hobby World)/Покарточная Сборка'),
    ('Murder at the Excelsior Hotel', '/var/lib/arkham-content/mac_import/sa/SA_05 Убийство в Отеле Эксельсиор (Hobby World)/Покарточная Сборка'),
    ('The Blob That Ate Everything', '/var/lib/arkham-content/mac_import/sa/SA_06_01 Капля, Поглотившая Всё (Hobby World)/Покарточная Сборка'),
    ('The Blob That Ate Everything ELSE!', '/var/lib/arkham-content/mac_import/sa/SA_06_02 Капля, Поглотившая Всё Остальное! (Любительский Перевод)/Покарточная Сборка'),
    ('War of the Outer Gods', '/var/lib/arkham-content/mac_import/sa/SA_07 Война Внешних Богов (Hobby World)/Покарточная Сборка'),
    ('Machinations Through Time', '/var/lib/arkham-content/mac_import/sa/SA_08 Махинации Сквозь Время (Hobby World)/Покарточная Сборка'),
    ('Fortune and Folly', '/var/lib/arkham-content/mac_import/sa/SA_09 Фортуна и Безрассудство (Hobby World)/Покарточная Сборка'),

    ('Return to the Night of the Zealot', '/var/lib/arkham-content/mac_import/returns/01R Возвращение в Ночь Фанатички (Hobby World)/Покарточная Сборка'),
    ('Return to the Dunwich Legacy', '/var/lib/arkham-content/mac_import/returns_02R/Покарточная Сборка'),
    ('Return to the Path to Carcosa', '/var/lib/arkham-content/mac_import/returns/03R Возвращение в Путь в Каркозу (Hobby World)/Покарточная Сборка'),
    ('Return to the Forgotten Age', '/var/lib/arkham-content/mac_import/returns/04R Возвращение в Забытую Эпоху (Hobby World)/Покарточная Сборка'),
    ('Return to the Circle Undone', '/var/lib/arkham-content/mac_import/returns/05R Возвращение в Нарушенный Круг (Hobby World)/Покарточная Сборка'),
]

cards = json.load(CARDS_EN.open(encoding='utf-8'))
OFFICIAL = {str(c['code']) for c in cards if c.get('code')}
TYPE_BY_CODE = {str(c['code']): c.get('type_code') for c in cards if c.get('code')}


def _get_wh(path):
    try:
        r = subprocess.run(
            ['ffprobe', '-v', 'error', '-select_streams', 'v:0',
             '-show_entries', 'stream=width,height', '-of', 'csv=p=0', str(path)],
            capture_output=True, text=True,
        )
        w, h = r.stdout.strip().split(',')
        return int(w), int(h)
    except Exception:
        return None


def _landscape_transpose(code):
    """Backs (act/agenda/investigator) need transpose=2 (90° CCW); fronts of
    the same types need transpose=1 (90° CW) — the two physical scan passes
    were rotated in opposite directions. Confirmed by visual check on both an
    investigator and an act card: transpose=2 on a front produces an
    upside-down card, transpose=1 reads correctly."""
    base = re.sub(r'[ab]$', '', code)
    is_back = code.endswith('b')
    t = TYPE_BY_CODE.get(code) or TYPE_BY_CODE.get(base)
    if t in ('act', 'agenda', 'investigator'):
        return 2 if is_back else 1
    return None


def _rotate_if_needed(path, code):
    transpose = _landscape_transpose(code)
    if transpose is None:
        return
    wh = _get_wh(path)
    if wh is None or wh[1] <= wh[0]:
        return
    tmp = path.with_suffix('.rot' + path.suffix)
    r = subprocess.run(
        ['ffmpeg', '-y', '-i', str(path), '-vf', f'transpose={transpose}', '-q:v', '2', str(tmp)],
        capture_output=True,
    )
    if r.returncode == 0:
        tmp.replace(path)
        path.chmod(0o644)
    elif tmp.exists():
        tmp.unlink()

by_pack = defaultdict(list)
for c in cards:
    if c.get('pack_name'):
        by_pack[c['pack_name']].append(c['code'])


def base_num(code):
    m = re.match(r'^(\d+)', code)
    return int(m.group(1)) if m else -1


def build_slots(pack_name):
    codes = by_pack.get(pack_name, [])
    groups = defaultdict(list)
    for code in codes:
        groups[base_num(code)].append(code)
    slots = []
    for base in sorted(groups.keys()):
        entry = groups[base]
        plain = [c for c in entry if not re.search(r'[ab]$', c)]
        a_side = [c for c in entry if c.endswith('a')]
        b_side = [c for c in entry if c.endswith('b')]
        slots.append({
            'plain': plain[0] if plain else None,
            'a': a_side[0] if a_side else None,
            'b': b_side[0] if b_side else None,
        })
    return slots


def map_stem(stem):
    """Returns a list of (n, side) tuples this single scan file should map to.
    Usually one entry; a "11b-12b" range (one scan covering multiple physical
    card backs on a shared print sheet) maps to several."""
    stem = stem.lower()
    if stem.endswith('-mini'):
        return []
    m = re.fullmatch(r'(\d{1,3})([ab])-(\d{1,3})([ab])', stem)
    if m:
        a, s1, b, s2 = m.groups()
        a, b = int(a), int(b)
        if s1 == s2 and a <= b:
            return [(i, s1) for i in range(a, b + 1)]
        return []
    m = re.fullmatch(r'(\d{1,3})([ab]?)-(\d+)', stem)
    if m:
        n, side, _copy = m.groups()
        return [(int(n), (side or None))]
    m = re.fullmatch(r'(\d{1,3})([ab]?)', stem)
    if m:
        n, side = m.groups()
        return [(int(n), (side or None))]
    return []


def fixed_code(prefix, width, n, side):
    base = f'{prefix}{n:0{width}d}'
    if side == 'a':
        return f'{base}a' if f'{base}a' in OFFICIAL else base
    if side == 'b':
        return f'{base}b'
    return base


def rank_source(path):
    stem = path.stem.lower()
    copy_match = re.fullmatch(r'.*-(\d+)$', stem)
    copy_num = int(copy_match.group(1)) if copy_match else 0
    ext_score = {'.png': 0, '.jpg': 1, '.jpeg': 1, '.webp': 2, '.avif': 3}.get(path.suffix.lower(), 9)
    rel = str(path).lower()
    old_penalty = 5 if '/old/' in rel else 0
    hidden_penalty = 2 if 'сокрытые карты' in rel else 0
    return (old_penalty, hidden_penalty, copy_num, ext_score, len(path.name))


existing = {}
if REMOTE_MANIFEST.exists():
    existing = json.loads(REMOTE_MANIFEST.read_text(encoding='utf-8'))

mapping = {}  # code -> path
report = []
for pack_name, folder in TARGETS:
    root = Path(folder)
    if not root.exists():
        report.append((pack_name, 'MISSING_FOLDER', 0, 0, 0))
        continue
    fixed = FIXED_PREFIX_PACKS.get(pack_name)
    slots = None if fixed else build_slots(pack_name)
    if not fixed and not slots:
        report.append((pack_name, 'NO_CARDS_IN_JSON', 0, 0, 0))
        continue

    candidates = defaultdict(list)  # code -> [paths]
    file_count = 0
    unmatched = 0
    for p in root.rglob('*'):
        if not p.is_file() or p.suffix.lower() not in {'.png', '.jpg', '.jpeg', '.webp', '.avif'}:
            continue
        file_count += 1
        targets = map_stem(p.stem)
        if not targets:
            unmatched += 1
            continue
        any_mapped = False
        for n, side in targets:
            if fixed:
                prefix, width = fixed
                code = fixed_code(prefix, width, n, side)
            else:
                if n < 1 or n > len(slots):
                    continue
                slot = slots[n - 1]
                if side == 'a':
                    code = slot['a'] or slot['plain']
                elif side == 'b':
                    code = slot['b']
                else:
                    code = slot['plain'] or slot['a']
            if not code:
                continue
            candidates[code].append(p)
            any_mapped = True
        if not any_mapped:
            unmatched += 1

    mapped_here = 0
    for code, paths in candidates.items():
        if code not in OFFICIAL and not code.endswith('b'):
            continue
        best = sorted(paths, key=rank_source)[0]
        mapping[code] = best
        mapped_here += 1
    report.append((pack_name, 'OK', file_count, mapped_here, unmatched))

copied = 0
for code, src in mapping.items():
    ext = src.suffix.lower()
    dst = TARGET_RAW / f'{code}{ext}'
    if not dst.exists() or src.stat().st_size != dst.stat().st_size:
        shutil.copy2(src, dst)
        dst.chmod(0o644)
        _rotate_if_needed(dst, code)
        copied += 1
    existing[f'cards/{code}.avif'] = f'/img/arkham/ru-local-raw/{dst.name}?v={int(dst.stat().st_mtime)}'

REMOTE_MANIFEST.write_text(json.dumps(existing, ensure_ascii=False, indent=2), encoding='utf-8')

print('=== report per pack ===')
for pack_name, status, file_count, mapped, unmatched in report:
    print(f'{pack_name:45s} {status:16s} files={file_count:4d} mapped={mapped:4d} unmatched={unmatched:4d}')
print()
print('total mapped codes (this run):', len(mapping))
print('copied files:', copied)
print('total manifest size:', len(existing))
