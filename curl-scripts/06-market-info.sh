#!/usr/bin/env bash
# Market Info — Clock, Calendar, Portfolio History — curl examples
#
# export APCA_API_KEY_ID="your-key"
# export APCA_API_SECRET_KEY="your-secret"
# export APCA_BASE_URL="https://paper-api.alpaca.markets"

BASE="${APCA_BASE_URL:-https://paper-api.alpaca.markets}"
AUTH=(-H "APCA-API-KEY-ID: ${APCA_API_KEY_ID}" -H "APCA-API-SECRET-KEY: ${APCA_API_SECRET_KEY}")

# ── GET /v2/clock — Market clock ─────────────────────────────────────────────
# Returns: is_open, next_open, next_close, timestamp (NYSE / US equity market)
curl -s "$BASE/v2/clock" "${AUTH[@]}" | python3 -m json.tool

# ── GET /v3/clock — Multi-market clock ───────────────────────────────────────
# Returns phase info for: BMO, BNYM, BOATS, HKEX, IEX, LSE, NASDAQ, NYSE,
#                         OPRA, OTC, SIFMA, TADAWUL, XETRA
# Response structure: {"clocks": [{"market": {"acronym": "NYSE", "name": ...},
#                                   "phase": "pre", "is_market_day": true, ...}]}
curl -s "$BASE/v3/clock" "${AUTH[@]}" | python3 -c "
import sys, json
clocks = json.load(sys.stdin).get('clocks', [])
for c in clocks:
    m = c.get('market', {})
    print(f\"{m.get('acronym','?'):8} phase={c.get('phase','?'):8} open={c.get('is_market_day','?')}\")
"

# ── GET /v2/calendar — Market calendar (NYSE/NASDAQ) ─────────────────────────
# start/end: YYYY-MM-DD format
curl -s "$BASE/v2/calendar?start=2026-03-01&end=2026-03-31" \
  "${AUTH[@]}" | python3 -m json.tool

# ── GET /v3/calendar/{market} — Per-market calendar ──────────────────────────
# Markets: NYSE, NASDAQ, OPRA, IEX, LSE, HKEX, XETRA, etc.
# Response: {"calendar": [{date, core_start, core_end, pre_start, pre_end, post_start, post_end}]}
curl -s "$BASE/v3/calendar/NYSE?start=2026-03-01&end=2026-03-07" \
  "${AUTH[@]}" | python3 -m json.tool

curl -s "$BASE/v3/calendar/OPRA?start=2026-03-01&end=2026-03-07" \
  "${AUTH[@]}" | python3 -m json.tool

# ── GET /v2/account/portfolio/history — Portfolio history ────────────────────
# period: 1D | 1W | 1M | 3M | 1A | all
# timeframe: 1Min | 5Min | 15Min | 1H | 1D
# intraday_reporting: market_hours | extended_hours | continuous
# pnl_reset: per_day | no_reset
curl -s "$BASE/v2/account/portfolio/history?period=1W&timeframe=1D" \
  "${AUTH[@]}" | python3 -m json.tool

# Monthly history with daily bars:
curl -s "$BASE/v2/account/portfolio/history?period=1M&timeframe=1D&pnl_reset=per_day" \
  "${AUTH[@]}" | python3 -m json.tool

# Intraday — today's minute-level data:
curl -s "$BASE/v2/account/portfolio/history?period=1D&timeframe=5Min&intraday_reporting=market_hours" \
  "${AUTH[@]}" | python3 -m json.tool

# Custom date range:
curl -s "$BASE/v2/account/portfolio/history?start=2026-01-01T00:00:00Z&end=2026-03-01T00:00:00Z&timeframe=1D" \
  "${AUTH[@]}" | python3 -m json.tool
