#!/usr/bin/env bash
# Watchlists — curl examples for full CRUD
#
# export APCA_API_KEY_ID="your-key"
# export APCA_API_SECRET_KEY="your-secret"
# export APCA_BASE_URL="https://paper-api.alpaca.markets"

BASE="${APCA_BASE_URL:-https://paper-api.alpaca.markets}"
AUTH=(-H "APCA-API-KEY-ID: ${APCA_API_KEY_ID}" -H "APCA-API-SECRET-KEY: ${APCA_API_SECRET_KEY}")
CT=(-H "Content-Type: application/json")

# ── GET /v2/watchlists — List all watchlists ──────────────────────────────────
curl -s "$BASE/v2/watchlists" "${AUTH[@]}" | python3 -m json.tool

# ── POST /v2/watchlists — Create watchlist ────────────────────────────────────
# symbols: initial list of symbols to add (optional)
curl -s -X POST "$BASE/v2/watchlists" "${AUTH[@]}" "${CT[@]}" -d '{
  "name": "tech-stocks",
  "symbols": ["AAPL", "GOOGL", "MSFT", "AMZN", "TSLA"]
}' | python3 -m json.tool

# ── GET /v2/watchlists/{watchlist_id} — Get watchlist by ID ──────────────────
WL_ID="replace-with-watchlist-uuid"
curl -s "$BASE/v2/watchlists/${WL_ID}" "${AUTH[@]}" | python3 -m json.tool

# ── PUT /v2/watchlists/{watchlist_id} — Replace all symbols ──────────────────
# PUT replaces the entire symbol list (and optionally renames)
curl -s -X PUT "$BASE/v2/watchlists/${WL_ID}" "${AUTH[@]}" "${CT[@]}" -d '{
  "name": "tech-stocks-v2",
  "symbols": ["AAPL", "NVDA", "META"]
}' | python3 -m json.tool

# ── POST /v2/watchlists/{watchlist_id} — Add a symbol ────────────────────────
curl -s -X POST "$BASE/v2/watchlists/${WL_ID}" "${AUTH[@]}" "${CT[@]}" -d '{
  "symbol": "AMD"
}' | python3 -m json.tool

# ── DELETE /v2/watchlists/{watchlist_id}/{symbol} — Remove a symbol ──────────
curl -s -X DELETE "$BASE/v2/watchlists/${WL_ID}/AMD" \
  "${AUTH[@]}" | python3 -m json.tool

# ── DELETE /v2/watchlists/{watchlist_id} — Delete watchlist ──────────────────
curl -s -X DELETE "$BASE/v2/watchlists/${WL_ID}" \
  "${AUTH[@]}" -w "HTTP %{http_code}\n" -o /dev/null
