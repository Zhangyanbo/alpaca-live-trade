#!/usr/bin/env bash
# Account & Configuration — curl examples
# Usage: set env vars, then copy/run individual commands
#
# export APCA_API_KEY_ID="your-key"
# export APCA_API_SECRET_KEY="your-secret"
# export APCA_BASE_URL="https://paper-api.alpaca.markets"   # paper
# export APCA_BASE_URL="https://api.alpaca.markets"         # live

BASE="${APCA_BASE_URL:-https://paper-api.alpaca.markets}"
AUTH=(-H "APCA-API-KEY-ID: ${APCA_API_KEY_ID}" -H "APCA-API-SECRET-KEY: ${APCA_API_SECRET_KEY}")

# ── GET /v2/account ──────────────────────────────────────────────────────────
# Returns: equity, cash, buying_power, PDT status, options level, etc.
curl -s -X GET "$BASE/v2/account" \
  "${AUTH[@]}" | python3 -m json.tool

# ── GET /v2/account/configurations ───────────────────────────────────────────
# Returns: dtbp_check, fractional_trading, max_margin_multiplier, pdt_check, etc.
curl -s -X GET "$BASE/v2/account/configurations" \
  "${AUTH[@]}" | python3 -m json.tool

# ── PATCH /v2/account/configurations ─────────────────────────────────────────
# Update one or more config fields. Only send the fields you want to change.
curl -s -X PATCH "$BASE/v2/account/configurations" \
  "${AUTH[@]}" \
  -H "Content-Type: application/json" \
  -d '{
    "dtbp_check": "entry",
    "fractional_trading": true,
    "no_shorting": false,
    "max_margin_multiplier": "2",
    "pdt_check": "entry",
    "suspend_trade": false,
    "trade_confirm_email": "all"
  }' | python3 -m json.tool
