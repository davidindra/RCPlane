#!/usr/bin/env python3
"""Generates hierarchical index.html pages for the site/models/ directory."""

import os
import sys
from pathlib import Path
from datetime import datetime

MODELS_DIR = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("site/models")

ICON_DIR = "📁"
ICON_STL = "🧊"
ICON_PDF = "📄"
ICON_PNG = "🖼️"
ICON_SCAD = "📐"
ICON_SH = "⚙️"
ICON_PY = "🐍"
ICON_FILE = "📎"

IGNORED = {".gitkeep"}


def file_icon(name: str) -> str:
    ext = Path(name).suffix.lower()
    return {
        ".stl": ICON_STL,
        ".pdf": ICON_PDF,
        ".png": ICON_PNG,
        ".scad": ICON_SCAD,
        ".sh": ICON_SH,
        ".py": ICON_PY,
    }.get(ext, ICON_FILE)


def human_size(path: Path) -> str:
    try:
        b = path.stat().st_size
        for unit in ("B", "KB", "MB", "GB"):
            if b < 1024:
                return f"{b:.0f} {unit}" if unit == "B" else f"{b:.1f} {unit}"
            b /= 1024
        return f"{b:.1f} TB"
    except OSError:
        return ""


def breadcrumbs(rel: Path) -> str:
    parts = rel.parts
    crumbs = ['<a href="/models/">models</a>']
    for i, part in enumerate(parts):
        href = "/models/" + "/".join(parts[: i + 1]) + "/"
        if i == len(parts) - 1:
            crumbs.append(f"<span>{part}</span>")
        else:
            crumbs.append(f'<a href="{href}">{part}</a>')
    return " / ".join(crumbs)


def generate_index(directory: Path) -> None:
    rel = directory.relative_to(MODELS_DIR)
    is_root = rel == Path(".")

    entries = sorted(directory.iterdir(), key=lambda p: (not p.is_dir(), p.name.lower()))
    dirs = [e for e in entries if e.is_dir()]
    files = [e for e in entries if e.is_file() and e.name not in IGNORED and e.name != "index.html"]

    title = "models" if is_root else rel.as_posix()
    parent_link = "" if is_root else '<a href="../" class="parent">&#8593; Nadřazená složka</a>'
    breadcrumb_html = (
        '<span class="bc-root">models</span>'
        if is_root
        else breadcrumbs(rel)
    )

    rows = []
    for d in dirs:
        rows.append(
            f'<tr><td>{ICON_DIR} <a href="{d.name}/">{d.name}/</a></td>'
            f"<td>—</td><td>složka</td></tr>"
        )
    for f in files:
        rows.append(
            f'<tr><td>{file_icon(f.name)} <a href="{f.name}">{f.name}</a></td>'
            f"<td>{human_size(f)}</td><td>{f.suffix.lstrip('.').upper() or '—'}</td></tr>"
        )

    table = (
        "<table><thead><tr><th>Název</th><th>Velikost</th><th>Typ</th></tr></thead>"
        "<tbody>" + "\n".join(rows) + "</tbody></table>"
        if rows
        else "<p>Prázdná složka.</p>"
    )

    html = f"""<!doctype html>
<html lang="cs">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{title} – RCPlane</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after {{ box-sizing: border-box; }}
    body {{
      margin: 0;
      font-family: Roboto, sans-serif;
      font-size: 14px;
      background: #fafafa;
      color: #212121;
    }}
    header {{
      background: #546e7a;
      color: #fff;
      padding: 0 24px;
      height: 56px;
      display: flex;
      align-items: center;
      gap: 16px;
    }}
    header a {{ color: #fff; text-decoration: none; font-weight: 500; font-size: 18px; }}
    header a:hover {{ text-decoration: underline; }}
    .breadcrumb {{
      padding: 12px 24px 0;
      font-size: 13px;
      color: #607d8b;
    }}
    .breadcrumb a {{ color: #546e7a; text-decoration: none; }}
    .breadcrumb a:hover {{ text-decoration: underline; }}
    .breadcrumb .bc-root {{ color: #607d8b; }}
    main {{ padding: 16px 24px 40px; max-width: 960px; }}
    h1 {{ font-size: 20px; font-weight: 500; margin: 12px 0 16px; color: #37474f; }}
    .parent {{ display: inline-block; margin-bottom: 12px; color: #546e7a;
               font-size: 13px; text-decoration: none; }}
    .parent:hover {{ text-decoration: underline; }}
    table {{ border-collapse: collapse; width: 100%; background: #fff;
             border-radius: 4px; box-shadow: 0 1px 3px rgba(0,0,0,.12); }}
    thead {{ background: #eceff1; }}
    th {{ text-align: left; padding: 10px 14px; font-weight: 500;
          color: #546e7a; font-size: 13px; border-bottom: 1px solid #cfd8dc; }}
    td {{ padding: 8px 14px; border-bottom: 1px solid #eceff1; }}
    tr:last-child td {{ border-bottom: none; }}
    tr:hover td {{ background: #f5f5f5; }}
    td:nth-child(2) {{ color: #78909c; font-size: 12px; white-space: nowrap; }}
    td:nth-child(3) {{ color: #90a4ae; font-size: 12px; white-space: nowrap; }}
    a {{ color: #37474f; text-decoration: none; }}
    a:hover {{ color: #546e7a; text-decoration: underline; }}
    footer {{ padding: 16px 24px; font-size: 12px; color: #90a4ae; }}
  </style>
</head>
<body>
  <header>
    <a href="/">RCPlane</a>
  </header>
  <div class="breadcrumb">{breadcrumb_html}</div>
  <main>
    <h1>{title}/</h1>
    {parent_link}
    {table}
  </main>
  <footer>Vygenerováno {datetime.utcnow().strftime("%Y-%m-%d %H:%M UTC")}</footer>
</body>
</html>
"""

    (directory / "index.html").write_text(html, encoding="utf-8")
    print(f"  {directory}")


def main() -> None:
    if not MODELS_DIR.is_dir():
        print(f"ERROR: {MODELS_DIR} does not exist", file=sys.stderr)
        sys.exit(1)

    print(f"Generating model indexes in {MODELS_DIR} ...")
    for root, dirs, _ in os.walk(MODELS_DIR):
        dirs.sort()
        generate_index(Path(root))
    print("Done.")


if __name__ == "__main__":
    main()
