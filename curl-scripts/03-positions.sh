#!/usr/bin/env bash
# Positions — curl examples
#
# export APCA_API_KEY_ID="your-key"
# export APCA_API_SECRET_KEY="your-secret"
# export APCA_BASE_URL="https://paper-api.alpaca.markets"

BASE="${APCA_BASE_URL:-https://paper-api.alpaca.markets}"
AUTH=(-H "APCA-API-KEY-ID: ${APCA_API_KEY_ID}" -H "APCA-API-SECRET-KEY: ${APCA_API_SECRET_KEY}")

# ── GET /v2/positions — All open positions ────────────────────────────────────
curl -s "$BASE/v2/positions" "${AUTH[@]}" | python3 -m json.tool

# ── GET /v2/positions/{symbol_or_asset_id} — Single position ─────────────────
# Works with symbol string or asset UUID
curl -s "$BASE/v2/positions/AAPL" "${AUTH[@]}" | python3 -m json.tool
# For crypto:
curl -s "$BASE/v2/positions/BTC%2FUSD" "${AUTH[@]}" | python3 -m json.tool

# ── DELETE /v2/positions/{symbol_or_asset_id} — Close position ───────────────
# Close all shares of AAPL:
curl -s -X DELETE "$BASE/v2/positions/AAPL" "${AUTH[@]}" | python3 -m json.tool

# Close partial — 50% of position:
curl -s -X DELETE "$BASE/v2/positions/AAPL?percentage=50" "${AUTH[@]}" | python3 -m json.tool

# Close specific qty — 5 shares:
curl -s -X DELETE "$BASE/v2/positions/AAPL?qty=5" "${AUTH[@]}" | python3 -m json.tool

# ── DELETE /v2/positions — Close ALL positions ────────────────────────────────
# cancel_orders=true: cancel any open orders for these symbols first
curl -s -X DELETE "$BASE/v2/positions?cancel_orders=true" \
  "${AUTH[@]}" | python3 -m json.tool

# ── POST /v2/positions/{contract_id}/exercise — Exercise option ───────────────
# Exercises all held contracts of the option position; use contract UUID
OPTION_CONTRACT_ID="replace-with-option-contract-uuid"
curl -s -X POST "$BASE/v2/positions/${OPTION_CONTRACT_ID}/exercise" \
  "${AUTH[@]}" -w "HTTP %{http_code}\n" -o /dev/null

# ── POST /v2/positions/{contract_id}/do-not-exercise ─────────────────────────
# Mark option to NOT auto-exercise at expiration
curl -s -X POST "$BASE/v2/positions/${OPTION_CONTRACT_ID}/do-not-exercise" \
  "${AUTH[@]}" -w "HTTP %{http_code}\n" -o /dev/null
