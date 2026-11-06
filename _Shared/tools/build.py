"""Uniform entry point; independent queues for script and sheets."""
from pathlib import Path
import argparse
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("command", nargs="?", default="update",
                   choices=["update","full","status","resume","ack"])
    p.add_argument("--product", choices=["script","sheets","all"], default="all")
    args, extra = p.parse_known_args()
    if args.command == 'full' and '--wait' not in extra:
        extra.append('--wait')
    products = ["script","sheets"] if args.product == "all" else [args.product]
    for product in products:
        folder = "Skript" if product == "script" else "Exercise Sheets"
        command = [sys.executable, "-B", str(ROOT/folder/"tools/build_coordinator.py"), args.command, *extra]
        result = subprocess.run(command, cwd=ROOT/folder)
        if result.returncode:
            return result.returncode
    return 0

if __name__ == "__main__":
    sys.exit(main())

