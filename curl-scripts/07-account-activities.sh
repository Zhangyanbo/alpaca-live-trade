#!/usr/bin/env bash
# Account Activities — curl examples
#
# export APCA_API_KEY_ID="your-key"
# export APCA_API_SECRET_KEY="your-secret"
# export APCA_BASE_URL="https://paper-api.alpaca.markets"

BASE="${APCA_BASE_URL:-https://paper-api.alpaca.markets}"
AUTH=(-H "APCA-API-KEY-ID: ${APCA_API_KEY_ID}" -H "APCA-API-SECRET-KEY: ${APCA_API_SECRET_KEY}")

# Activity types:
#  FILL   - order fill (TradeActivity)
#  TRANS  - cash transaction
#  JNLC   - journal entry (cash)
#  JNLS   - journal entry (stock)
#  CSD    - cash deposit
#  CSW    - cash withdrawal
#  DIV    - dividend
#  MA     - merger/acquisition
#  SSP    - stock split
#  SSO    - stock spinoff
#  REORG  - reorganization
#  NC     - name change
#  PTC    - pass-through charge
#  ACATC  - ACAT transfer completed
#  ACATS  - ACAT transfer sent

# ── GET /v2/account/activities — All activities ───────────────────────────────
curl -s "$BASE/v2/account/activities" "${AUTH[@]}" | python3 -m json.tool

# ── GET /v2/account/activities?activity_type={type} — Filter by type ─────────
curl -s "$BASE/v2/account/activities?activity_type=FILL&page_size=20" \
  "${AUTH[@]}" | python3 -m json.tool

# Cash transactions only:
curl -s "$BASE/v2/account/activities?activity_type=TRANS&page_size=20" \
  "${AUTH[@]}" | python3 -m json.tool

# Dividends:
curl -s "$BASE/v2/account/activities?activity_type=DIV" \
  "${AUTH[@]}" | python3 -m json.tool

# ── GET /v2/account/activities/{type} — Dedicated type endpoint ───────────────
curl -s "$BASE/v2/account/activities/FILL" "${AUTH[@]}" | python3 -m json.tool

# ── Date range filtering ──────────────────────────────────────────────────────
# after/until: RFC3339 timestamps
curl -s "$BASE/v2/account/activities?after=2026-01-01T00:00:00Z&until=2026-03-01T00:00:00Z&direction=desc&page_size=50" \
  "${AUTH[@]}" | python3 -m json.tool

# Specific date:
curl -s "$BASE/v2/account/activities?date=2026-03-01" \
  "${AUTH[@]}" | python3 -m json.tool

# ── Pagination ────────────────────────────────────────────────────────────────
# Use page_token from previous response to get next page
PAGE_TOKEN="replace-with-page-token"
curl -s "$BASE/v2/account/activities?page_token=${PAGE_TOKEN}&page_size=100" \
  "${AUTH[@]}" | python3 -m json.tool
