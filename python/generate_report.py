#!/usr/bin/env python3
"""Generate a bespoke glassmorphism HTML dashboard from Robot Framework output.xml.

Usage:
    python Python/generate_report.py results/output.xml --output results/custom_report.html
"""
from __future__ import annotations

import argparse
import html
import sys
import xml.etree.ElementTree as ET
from datetime import datetime
from pathlib import Path
from typing import Optional

ACCENT = "#F48031"


def parse_robot_datetime(value: Optional[str]) -> Optional[datetime]:
    if not value:
        return None
    for fmt in ("%Y%m%d %H:%M:%S.%f", "%Y%m%d %H:%M:%S"):
        try:
            return datetime.strptime(value, fmt)
        except ValueError:
            pass
    return None


def duration_seconds(start: Optional[str], end: Optional[str]) -> Optional[float]:
    start_dt = parse_robot_datetime(start)
    end_dt = parse_robot_datetime(end)
    if not start_dt or not end_dt:
        return None
    return max(0.0, (end_dt - start_dt).total_seconds())


def format_duration(seconds: Optional[float]) -> str:
    if seconds is None:
        return "—"
    if seconds < 60:
        return f"{seconds:.2f}s"
    minutes, secs = divmod(seconds, 60)
    if minutes < 60:
        return f"{int(minutes)}m {secs:.0f}s"
    hours, minutes = divmod(int(minutes), 60)
    return f"{hours}h {minutes}m"


def status_for(test: ET.Element) -> tuple[str, str]:
    status = test.find("status")
    if status is None:
        return "UNKNOWN", ""
    return status.get("status", "UNKNOWN").upper(), (status.text or "").strip()


def collect_tests(root: ET.Element) -> list[dict]:
    rows = []
    for test in root.findall(".//test"):
        status, message = status_for(test)
        parent_suite = ""
        # Robot output.xml does not always make parent lookup convenient; derive suite names
        # from the test's id, while preserving the full test name in the table.
        test_id = test.get("id", "")
        suite_path = ".".join(test_id.split(".")[:-1]) if test_id else ""
        start = test.find("status").get("starttime") if test.find("status") is not None else None
        end = test.find("status").get("endtime") if test.find("status") is not None else None
        rows.append({
            "name": test.get("name", "Unnamed test"),
            "id": test_id,
            "suite": suite_path or parent_suite or "Test suite",
            "status": status,
            "message": message,
            "duration": duration_seconds(start, end),
        })
    return rows


def collect_suite_info(root: ET.Element) -> tuple[str, str, str]:
    suite = root.find("suite")
    name = suite.get("name", "Robot Framework Test Suite") if suite is not None else "Robot Framework Test Suite"
    status = root.find(".//suite/status")
    start = status.get("starttime", "") if status is not None else ""
    end = status.get("endtime", "") if status is not None else ""
    return name, start, end


def make_html(rows: list[dict], suite_name: str, generated: str, total_duration: str) -> str:
    total = len(rows)
    passed = sum(row["status"] == "PASS" for row in rows)
    failed = sum(row["status"] == "FAIL" for row in rows)
    skipped = sum(row["status"] in ("SKIP", "SKIPPED") for row in rows)
    other = total - passed - failed - skipped
    pass_rate = (passed / total * 100) if total else 0.0

    def esc(value: object) -> str:
        return html.escape(str(value if value is not None else ""), quote=True)

    table_rows = []
    for row in rows:
        status = row["status"]
        message = row["message"] or ("Test passed" if status == "PASS" else "No status message")
        table_rows.append(
            '<tr data-status="{status}">'
            '<td><span class="test-name">{name}</span><small>{suite}</small></td>'
            '<td><span class="pill {status_class}">{status}</span></td>'
            '<td class="duration">{duration}</td>'
            '<td class="message">{message}</td>'
            '</tr>'.format(
                status=esc(status),
                name=esc(row["name"]),
                suite=esc(row["suite"]),
                status_class=esc(status.lower()),
                duration=esc(format_duration(row["duration"])),
                message=esc(message),
            )
        )

    if not table_rows:
        table_rows.append('<tr><td colspan="4" class="empty">No test cases were found in output.xml.</td></tr>')

    return """<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>QA Test Dashboard · {suite_title}</title>
<style>
:root {{
  --accent: #F48031;
  --accent-rgb: 244, 128, 49;
  --ink: #f8fafc;
  --muted: #b9c4d5;
  --glass: rgba(255, 255, 255, .085);
  --glass-border: rgba(255, 255, 255, .19);
  --shadow: 0 22px 60px rgba(0, 0, 0, .24);
}}
* {{ box-sizing: border-box; }}
body {{
  margin: 0; min-height: 100vh; color: var(--ink);
  font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  background:
    radial-gradient(ellipse at 12% 8%, rgba(244,128,49,.28), transparent 33%),
    radial-gradient(ellipse at 90% 18%, rgba(83,111,255,.25), transparent 34%),
    linear-gradient(135deg, #111827 0%, #172033 48%, #0b1220 100%);
  background-attachment: fixed;
}}
.wrap {{ max-width: 1240px; margin: 0 auto; padding: 42px 24px 56px; }}
header {{ display:flex; justify-content:space-between; gap:24px; align-items:flex-start; margin-bottom:30px; }}
.eyebrow {{ color:var(--accent); text-transform:uppercase; letter-spacing:.18em; font-size:.75rem; font-weight:800; }}
h1 {{ margin:10px 0 8px; font-size:clamp(2rem, 4vw, 3.15rem); letter-spacing:-.045em; }}
.subtitle {{ color:var(--muted); margin:0; line-height:1.6; }}
.run-meta {{ text-align:right; color:var(--muted); font-size:.88rem; line-height:1.8; }}
.run-meta strong {{ color:var(--ink); }}
.glass {{
  background:var(--glass); border:1px solid var(--glass-border);
  box-shadow:var(--shadow); backdrop-filter:blur(18px); -webkit-backdrop-filter:blur(18px);
  border-radius:22px;
}}
.summary {{ display:grid; grid-template-columns:repeat(4, minmax(0,1fr)); gap:16px; margin:26px 0 18px; }}
.card {{ padding:22px; position:relative; overflow:hidden; }}
.card:after {{ content:""; position:absolute; width:100px; height:100px; border-radius:50%; right:-35px; top:-42px; background:rgba(255,255,255,.06); }}
.card-label {{ color:var(--muted); font-size:.86rem; }}
.card-value {{ font-size:2.2rem; font-weight:800; letter-spacing:-.04em; margin:9px 0 5px; }}
.card-note {{ color:var(--muted); font-size:.8rem; }}
.accent {{ color:var(--accent); }}
.pass-text {{ color:var(--accent); }}
.fail-text {{ color:#ff8585; }}
.skip-text {{ color:#c5b8ff; }}
.progress-shell {{ height:9px; background:rgba(255,255,255,.1); border-radius:99px; overflow:hidden; margin-top:17px; }}
.progress {{ height:100%; width:{pass_rate:.2f}%; background:var(--accent); border-radius:99px; }}
.panel {{ padding:22px; margin-top:18px; }}
.panel-head {{ display:flex; justify-content:space-between; align-items:center; gap:18px; flex-wrap:wrap; margin-bottom:18px; }}
h2 {{ margin:0; font-size:1.15rem; }}
.controls {{ display:flex; gap:10px; flex-wrap:wrap; }}
input, select {{
  color:var(--ink); background:rgba(8,15,28,.5); border:1px solid var(--glass-border);
  border-radius:11px; padding:11px 13px; outline:none; min-height:42px;
}}
input {{ min-width:230px; }}
input:focus, select:focus {{ border-color:var(--accent); box-shadow:0 0 0 3px rgba(var(--accent-rgb),.16); }}
.tabs {{ display:flex; gap:8px; flex-wrap:wrap; margin-bottom:16px; }}
.tab {{ cursor:pointer; border:1px solid var(--glass-border); color:var(--muted); background:rgba(255,255,255,.04); padding:9px 13px; border-radius:999px; font-size:.82rem; }}
.tab.active {{ background:var(--accent); border-color:var(--accent); color:#1c120b; font-weight:800; }}
.table-wrap {{ overflow:auto; border:1px solid rgba(255,255,255,.1); border-radius:15px; }}
table {{ width:100%; border-collapse:collapse; min-width:740px; }}
th {{ color:var(--muted); font-size:.75rem; text-align:left; text-transform:uppercase; letter-spacing:.1em; background:rgba(255,255,255,.045); }}
th, td {{ padding:15px 16px; border-bottom:1px solid rgba(255,255,255,.08); vertical-align:top; }}
tbody tr:hover {{ background:rgba(255,255,255,.035); }}
tbody tr:last-child td {{ border-bottom:0; }}
.test-name {{ display:block; font-weight:700; }}
td small {{ display:block; color:var(--muted); margin-top:5px; }}
.pill {{ display:inline-block; padding:5px 9px; border-radius:999px; font-size:.72rem; font-weight:800; letter-spacing:.04em; }}
.pill.pass {{ color:#1b120b; background:var(--accent); }}
.pill.fail {{ color:#ffe4e4; background:rgba(239,68,68,.18); border:1px solid rgba(248,113,113,.35); }}
.pill.skip, .pill.skipped {{ color:#e6ddff; background:rgba(167,139,250,.16); border:1px solid rgba(167,139,250,.3); }}
.pill.unknown {{ color:var(--muted); background:rgba(255,255,255,.08); }}
.duration {{ white-space:nowrap; color:var(--muted); }}
.message {{ color:#d8deea; max-width:460px; overflow-wrap:anywhere; }}
.empty {{ color:var(--muted); text-align:center; padding:32px; }}
footer {{ color:var(--muted); text-align:center; font-size:.8rem; margin-top:24px; }}
@media (max-width:760px) {{
  .wrap {{ padding:28px 14px 40px; }}
  header {{ flex-direction:column; }}
  .run-meta {{ text-align:left; }}
  .summary {{ grid-template-columns:repeat(2,minmax(0,1fr)); gap:10px; }}
  .card {{ padding:17px; }}
  .card-value {{ font-size:1.8rem; }}
  input {{ min-width:160px; width:100%; }}
}}
@media (max-width:420px) {{ .summary {{ grid-template-columns:1fr 1fr; }} }}
</style>
</head>
<body>
<div class="wrap">
  <header>
    <div>
      <div class="eyebrow">Quality Engineering · Test Intelligence</div>
      <h1>Test Run Dashboard</h1>
      <p class="subtitle">{suite_title}<br>Custom Robot Framework report · Glass UI</p>
    </div>
    <div class="run-meta">
      <div><strong>Generated</strong><br>{generated}</div>
      <div><strong>Total duration</strong><br>{total_duration}</div>
    </div>
  </header>

  <section class="summary" aria-label="Test summary">
    <article class="glass card">
      <div class="card-label">Total tests</div><div class="card-value">{total}</div>
      <div class="card-note">Tests discovered in output.xml</div>
      <div class="progress-shell"><div class="progress"></div></div>
    </article>
    <article class="glass card">
      <div class="card-label">Passed</div><div class="card-value pass-text">{passed}</div>
      <div class="card-note">{pass_rate:.1f}% pass rate</div>
    </article>
    <article class="glass card">
      <div class="card-label">Failed</div><div class="card-value fail-text">{failed}</div>
      <div class="card-note">Tests requiring investigation</div>
    </article>
    <article class="glass card">
      <div class="card-label">Skipped / other</div><div class="card-value skip-text">{skipped_plus_other}</div>
      <div class="card-note">{skipped} skipped · {other} other</div>
    </article>
  </section>

  <section class="glass panel">
    <div class="panel-head">
      <h2>Test case results</h2>
      <div class="controls">
        <input id="search" type="search" placeholder="Search test or suite…" aria-label="Search tests">
        <select id="sort" aria-label="Sort tests">
          <option value="default">Original order</option>
          <option value="name">Name A–Z</option>
          <option value="duration">Duration: longest first</option>
        </select>
      </div>
    </div>
    <div class="tabs" role="group" aria-label="Filter test status">
      <button class="tab active" data-filter="ALL">All ({total})</button>
      <button class="tab" data-filter="PASS">Passed ({passed})</button>
      <button class="tab" data-filter="FAIL">Failed ({failed})</button>
      <button class="tab" data-filter="SKIP">Skipped ({skipped})</button>
    </div>
    <div class="table-wrap">
      <table>
        <thead><tr><th>Test case</th><th>Status</th><th>Duration</th><th>Status message</th></tr></thead>
        <tbody id="testRows">{table_rows}</tbody>
      </table>
    </div>
  </section>
  <footer>Custom HTML reporter for Robot Framework · Accent color: #F48031</footer>
</div>
<script>
(() => {{
  const tbody = document.getElementById('testRows');
  const originalRows = Array.from(tbody.querySelectorAll('tr'));
  let activeFilter = 'ALL';
  const search = document.getElementById('search');
  const sort = document.getElementById('sort');

  function applyFilters() {{
    const term = search.value.trim().toLowerCase();
    let rows = originalRows.slice();
    if (sort.value === 'name') rows.sort((a,b) => a.cells[0].innerText.localeCompare(b.cells[0].innerText));
    if (sort.value === 'duration') rows.sort((a,b) => durationValue(b.cells[2].innerText) - durationValue(a.cells[2].innerText));
    rows.forEach(row => {{
      const status = row.dataset.status || '';
      const matchesStatus = activeFilter === 'ALL' ||
        status === activeFilter || (activeFilter === 'SKIP' && status === 'SKIPPED');
      const matchesTerm = row.innerText.toLowerCase().includes(term);
      row.hidden = !(matchesStatus && matchesTerm);
      tbody.appendChild(row);
    }});
  }}
  function durationValue(text) {{
    const s = text.trim();
    if (s.endsWith('s')) return parseFloat(s) || 0;
    const m = s.match(/(?:(\\d+)h\\s*)?(?:(\\d+)m\\s*)?(\\d+(?:\\.\\d+)?)s?/);
    return m ? (Number(m[1]||0)*3600 + Number(m[2]||0)*60 + Number(m[3]||0)) : 0;
  }}
  document.querySelectorAll('.tab').forEach(button => button.addEventListener('click', () => {{
    document.querySelectorAll('.tab').forEach(tab => tab.classList.remove('active'));
    button.classList.add('active');
    activeFilter = button.dataset.filter;
    applyFilters();
  }}));
  search.addEventListener('input', applyFilters);
  sort.addEventListener('change', applyFilters);
}})();
</script>
</body>
</html>
""".format(
        suite_title=html.escape(suite_name),
        generated=html.escape(generated),
        total_duration=html.escape(total_duration),
        total=total,
        passed=passed,
        failed=failed,
        skipped=skipped,
        other=other,
        pass_rate=pass_rate,
        table_rows="\n".join(table_rows),
        skipped_plus_other=skipped + other,
    )


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate a custom glassmorphism HTML report from Robot Framework output.xml")
    parser.add_argument("input_xml", help="Path to Robot Framework output.xml")
    parser.add_argument("--output", default="results/custom_report.html", help="Output HTML path (default: results/custom_report.html)")
    args = parser.parse_args()

    input_path = Path(args.input_xml)
    output_path = Path(args.output)
    if not input_path.is_file():
        print(f"ERROR: Input XML not found: {input_path}", file=sys.stderr)
        return 2

    try:
        root = ET.parse(input_path).getroot()
    except ET.ParseError as exc:
        print(f"ERROR: Could not parse Robot Framework XML: {exc}", file=sys.stderr)
        return 2

    rows = collect_tests(root)
    suite_name, start, end = collect_suite_info(root)
    total_duration = format_duration(duration_seconds(start, end))
    generated = datetime.now().astimezone().strftime("%Y-%m-%d %H:%M:%S %Z")
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(make_html(rows, suite_name, generated, total_duration), encoding="utf-8")

    passed = sum(row["status"] == "PASS" for row in rows)
    failed = sum(row["status"] == "FAIL" for row in rows)
    print(f"Custom report created: {output_path.resolve()}")
    print(f"Tests: {len(rows)} | Passed: {passed} | Failed: {failed}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
