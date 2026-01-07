#!/usr/bin/env python3

from sys import argv
from pathlib import Path
from shutil import move

if len(argv) != 2: raise SystemExit("usage: script.py <vault>")

cleaned = 0

vault = Path(argv[1])

assets = list((vault / "assets").rglob("*"))
assets = [p for p in assets if p.is_file()]

nodes = [
    p for p in vault.rglob("*")
    if p.is_file() and "assets" not in p.parts
]


def has_link_to_asset(node: Path, asset: Path) -> bool:
    asset_name = asset.name
    try:
        with open(node, encoding="utf-8", errors="ignore") as f:
            for line in f:
                if f"[[{asset_name}]]" in line: return True
    except OSError: pass
    return False


def is_asset_referenced(asset) -> bool:
    for node in nodes:
        if has_link_to_asset(node, asset): return True

    return False

if __name__ == '__main__':
    denode_trash = vault / ".DenodeTrash";
    if not denode_trash.exists():
        print(f" * '{vault}/.DenodeTrash' wasn't found, making it.\n")
        denode_trash.mkdir(exist_ok = True)

    for asset in assets:
        if not is_asset_referenced(asset):
            print(f" * moving '{asset}' to trash")
            cleaned += 1
            move(asset, denode_trash)

    if cleaned > 0: print(f"cleaned {cleaned} assets.")
    else: print("vault is clean.")
