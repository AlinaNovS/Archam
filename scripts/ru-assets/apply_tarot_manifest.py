#!/usr/bin/env python3
"""Merge Tarot card (major arcana) RU scans into ru-remote.json.

Source: raw scans already copied to frontend/public/img/arkham/ru-local-raw/
as tarot-0.png .. tarot-21.png (major arcana 0-21, matches TarotCard.ts's
tarot-<N>.jpg naming) plus tarot-back.png (card back).

Run this AFTER prepare_ru_local_fallback.py + prepare_ru_standalone.py,
every time (both of those overwrite/rebuild the manifest and do not know
about tarot at all) - this script only MERGES, never overwrites wholesale.
"""
import json, os

MANIFEST = '/opt/ArkhamHorror/frontend/src/digests/ru-remote.json'
RAW_DIR = '/opt/ArkhamHorror/frontend/public/img/arkham/ru-local-raw'

def main():
    with open(MANIFEST) as f:
        d = json.load(f)
    added = 0
    for n in range(22):
        fname = f'tarot-{n}.png'
        fpath = os.path.join(RAW_DIR, fname)
        if not os.path.exists(fpath):
            print(f'MISSING source file, skipped: {fname}')
            continue
        mtime = int(os.path.getmtime(fpath))
        d[f'tarot/tarot-{n}.jpg'] = f'/img/arkham/ru-local-raw/{fname}?v={mtime}'
        added += 1
    back_path = os.path.join(RAW_DIR, 'tarot-back.png')
    if os.path.exists(back_path):
        mtime = int(os.path.getmtime(back_path))
        d['tarot/back.jpg'] = f'/img/arkham/ru-local-raw/tarot-back.png?v={mtime}'
        added += 1
    with open(MANIFEST, 'w') as f:
        json.dump(d, f, ensure_ascii=False, sort_keys=True, indent=0)
    print('tarot entries merged:', added)
    print('total manifest size:', len(d))

if __name__ == '__main__':
    main()
