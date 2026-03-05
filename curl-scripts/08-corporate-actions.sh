#!/usr/bin/env bash
# Corporate Actions — curl examples
#
# export APCA_API_KEY_ID="your-key"
# export APCA_API_SECRET_KEY="your-secret"
# export APCA_BASE_URL="https://paper-api.alpaca.markets"

BASE="${APCA_BASE_URL:-https://paper-api.alpaca.markets}"
AUTH=(-H "APCA-API-KEY-ID: ${APCA_API_KEY_ID}" -H "APCA-API-SECRET-KEY: ${APCA_API_SECRET_KEY}")

# ca_types (multi-valued, repeat param): dividend | merger | spinoff | split
# date_type: declaration | ex | record | payable

# ── GET /v2/corporate_actions/announcements — List announcements ──────────────
# since + until are required
# Multiple ca_types: repeat the param
curl -s "$BASE/v2/corporate_actions/announcements?ca_types=dividend&since=2026-01-01&until=2026-03-31" \
  "${AUTH[@]}" | python3 -c "
import sys, json
items = json.load(sys.stdin)
print(f'count={len(items)}')
for a in items[:10]:
    print(f\"{a.get('initiating_symbol','?'):8} {a.get('ca_type','?'):10} payable={a.get('payable_date','?')} cash={a.get('cash','?')}\")
"

# All types — dividends, splits, mergers:
curl -s "$BASE/v2/corporate_actions/announcements?ca_types=dividend&ca_types=merger&ca_types=split&since=2026-01-01&until=2026-03-31" \
  "${AUTH[@]}" | python3 -c "
import sys, json
items = json.load(sys.stdin)
print(f'total={len(items)}')
from collections import Counter
counts = Counter(a['ca_type'] for a in items)
for k, v in counts.items():
    print(f'  {k}: {v}')
"

# Filter by specific symbol:
curl -s "$BASE/v2/corporate_actions/announcements?ca_types=dividend&since=2026-01-01&until=2026-12-31&symbol=AAPL" \
  "${AUTH[@]}" | python3 -m json.tool

# Filter by date type (when to look for the event):
curl -s "$BASE/v2/corporate_actions/announcements?ca_types=dividend&since=2026-03-01&until=2026-03-31&date_type=payable" \
  "${AUTH[@]}" | python3 -m json.tool

# ── GET /v2/corporate_actions/announcements/{id} — Single announcement ────────
ANNOUNCEMENT_ID="replace-with-announcement-uuid"
curl -s "$BASE/v2/corporate_actions/announcements/${ANNOUNCEMENT_ID}" \
  "${AUTH[@]}" | python3 -m json.tool
