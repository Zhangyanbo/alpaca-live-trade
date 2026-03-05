#!/usr/bin/env bash
# Crypto & Perpetual Wallets — curl examples
# Note: These endpoints may not be available on all account types or paper trading.
# Crypto trading (BTC/USD orders) is handled via 02-orders.sh — this file covers
# wallet management, transfers, and perpetual futures.
#
# export APCA_API_KEY_ID="your-key"
# export APCA_API_SECRET_KEY="your-secret"
# export APCA_BASE_URL="https://paper-api.alpaca.markets"

BASE="${APCA_BASE_URL:-https://paper-api.alpaca.markets}"
AUTH=(-H "APCA-API-KEY-ID: ${APCA_API_KEY_ID}" -H "APCA-API-SECRET-KEY: ${APCA_API_SECRET_KEY}")
CT=(-H "Content-Type: application/json")

# ── CRYPTO WALLETS ────────────────────────────────────────────────────────────

# GET /v2/wallets — List all crypto wallets
curl -s "$BASE/v2/wallets" "${AUTH[@]}" | python3 -m json.tool

# GET /v2/wallets/transfers — List wallet transfers
curl -s "$BASE/v2/wallets/transfers" "${AUTH[@]}" | python3 -m json.tool

# POST /v2/wallets/transfers — Create external transfer (withdraw crypto)
# asset: ETH | BTC | USDC | etc.
curl -s -X POST "$BASE/v2/wallets/transfers" "${AUTH[@]}" "${CT[@]}" -d '{
  "amount": "0.01",
  "address": "0xYourExternalWalletAddress",
  "asset": "ETH"
}' | python3 -m json.tool

# GET /v2/wallets/transfers/{transfer_id} — Get specific transfer
TRANSFER_ID="replace-with-transfer-uuid"
curl -s "$BASE/v2/wallets/transfers/${TRANSFER_ID}" "${AUTH[@]}" | python3 -m json.tool

# GET /v2/wallets/whitelists — List whitelisted withdrawal addresses
curl -s "$BASE/v2/wallets/whitelists" "${AUTH[@]}" | python3 -m json.tool

# POST /v2/wallets/whitelists — Add whitelisted address
curl -s -X POST "$BASE/v2/wallets/whitelists" "${AUTH[@]}" "${CT[@]}" -d '{
  "address": "0xYourExternalWalletAddress",
  "asset": "ETH"
}' | python3 -m json.tool

# DELETE /v2/wallets/whitelists/{whitelist_id} — Remove whitelisted address
WHITELIST_ID="replace-with-whitelist-uuid"
curl -s -X DELETE "$BASE/v2/wallets/whitelists/${WHITELIST_ID}" \
  "${AUTH[@]}" -w "HTTP %{http_code}\n" -o /dev/null

# GET /v2/wallets/fees/estimate — Estimate withdrawal fee
curl -s "$BASE/v2/wallets/fees/estimate?asset=ETH&from_address=0xYourAddress&to_address=0xDestAddress&amount=0.01" \
  "${AUTH[@]}" | python3 -m json.tool

# ── PERPETUAL FUTURES WALLETS ─────────────────────────────────────────────────

# GET /v2/perpetuals/wallets — List perpetual wallets
curl -s "$BASE/v2/perpetuals/wallets" "${AUTH[@]}" | python3 -m json.tool

# GET /v2/perpetuals/wallets/transfers — List perpetual transfers
curl -s "$BASE/v2/perpetuals/wallets/transfers" "${AUTH[@]}" | python3 -m json.tool

# POST /v2/perpetuals/wallets/transfers — Move funds to/from perpetual account
curl -s -X POST "$BASE/v2/perpetuals/wallets/transfers" "${AUTH[@]}" "${CT[@]}" -d '{
  "amount": "1000",
  "direction": "to_perpetual"
}' | python3 -m json.tool

# GET /v2/perpetuals/wallets/transfers/{id} — Get specific transfer
PERP_TRANSFER_ID="replace-with-transfer-uuid"
curl -s "$BASE/v2/perpetuals/wallets/transfers/${PERP_TRANSFER_ID}" \
  "${AUTH[@]}" | python3 -m json.tool

# GET /v2/perpetuals/leverage — Get current leverage settings
curl -s "$BASE/v2/perpetuals/leverage" "${AUTH[@]}" | python3 -m json.tool

# POST /v2/perpetuals/leverage — Set leverage
curl -s -X POST "$BASE/v2/perpetuals/leverage" "${AUTH[@]}" "${CT[@]}" -d '{
  "leverage": "5"
}' | python3 -m json.tool

# GET /v2/perpetuals/account_vitals — Perp account health (margin, pnl, etc.)
curl -s "$BASE/v2/perpetuals/account_vitals" "${AUTH[@]}" | python3 -m json.tool
