import json
import re
import subprocess
from pathlib import Path

FRONTEND = Path('/opt/ArkhamHorror/frontend')
CARDS_EN = FRONTEND / 'public/cards_en.json'
TARGET_RAW = FRONTEND / 'public/img/arkham/ru-local-raw'
REMOTE_MANIFEST = FRONTEND / 'src/digests/ru-remote.json'

cards = json.load(CARDS_EN.open(encoding='utf-8'))
type_by_code = {c['code']: c.get('type_code') for c in cards if c.get('code')}


def landscape_transpose(code: str):
    """ffmpeg transpose value to fix this scan, or None if not applicable.
    Backs (act/agenda/investigator) were scanned needing 90° CCW (transpose=2);
    fronts of the same types need 90° CW (transpose=1) — confirmed by visual
    check on both an investigator and an act card, transpose=2 on a front
    produces an upside-down card."""
    base = re.sub(r'[ab]$', '', code)
    is_back = code.endswith('b')
    t = type_by_code.get(code) or type_by_code.get(base)
    if t in ('act', 'agenda', 'investigator'):
        return 2 if is_back else 1
    return None


def get_wh(path: Path):
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


def rotate_to_landscape(path: Path, transpose: int):
    tmp = path.with_suffix('.rot' + path.suffix)
    r = subprocess.run(
        ['ffmpeg', '-y', '-i', str(path), '-vf', f'transpose={transpose}', '-q:v', '2', str(tmp)],
        capture_output=True,
    )
    if r.returncode == 0:
        tmp.replace(path)
        path.chmod(0o644)
        return True
    if tmp.exists():
        tmp.unlink()
    return False


manifest = json.loads(REMOTE_MANIFEST.read_text(encoding='utf-8'))

checked = 0
rotated = 0
skipped_missing = 0
for key, rel_path in manifest.items():
    code = key.removeprefix('cards/').removesuffix('.avif')
    transpose = landscape_transpose(code)
    if transpose is None:
        continue
    checked += 1
    fname = Path(rel_path.split('?')[0]).name
    fpath = TARGET_RAW / fname
    if not fpath.exists():
        skipped_missing += 1
        continue
    wh = get_wh(fpath)
    if wh is None:
        continue
    w, h = wh
    if h > w:  # portrait but should be landscape
        if rotate_to_landscape(fpath, transpose):
            rotated += 1
            print(f'rotated {code}: {fpath.name} ({w}x{h} -> landscape, transpose={transpose})')

print()
print(f'checked (should-be-landscape) codes: {checked}')
print(f'rotated: {rotated}')
print(f'missing files: {skipped_missing}')
