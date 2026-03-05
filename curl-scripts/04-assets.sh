#!/usr/bin/env bash
# Assets & Option Contracts — curl examples
#
# export APCA_API_KEY_ID="your-key"
# export APCA_API_SECRET_KEY="your-secret"
# export APCA_BASE_URL="https://paper-api.alpaca.markets"

BASE="${APCA_BASE_URL:-https://paper-api.alpaca.markets}"
AUTH=(-H "APCA-API-KEY-ID: ${APCA_API_KEY_ID}" -H "APCA-API-SECRET-KEY: ${APCA_API_SECRET_KEY}")

# ── GET /v2/assets — List assets ─────────────────────────────────────────────
# asset_class: us_equity | crypto   status: active | inactive
# Returns all active US equities (large response — pipe to head or filter)
curl -s "$BASE/v2/assets?asset_class=us_equity&status=active" \
  "${AUTH[@]}" | python3 -c "import sys,json; assets=json.load(sys.stdin); print(f'total={len(assets)}'); [print(f\"{a['symbol']}: tradable={a['tradable']} fractionable={a['fractionable']}\") for a in assets[:10]]"

# All active crypto assets:
curl -s "$BASE/v2/assets?asset_class=crypto&status=active" \
  "${AUTH[@]}" | python3 -c "import sys,json; assets=json.load(sys.stdin); [print(f\"{a['symbol']}: min_order={a.get('min_order_size','?')}\") for a in assets]"

# ── GET /v2/assets/{symbol_or_asset_id} — Single asset ───────────────────────
# By symbol:
curl -s "$BASE/v2/assets/AAPL" "${AUTH[@]}" | python3 -m json.tool

# Crypto (URL-encode the slash):
curl -s "$BASE/v2/assets/BTC%2FUSD" "${AUTH[@]}" | python3 -m json.tool

# By asset UUID:
curl -s "$BASE/v2/assets/b0b6dd9d-8b9b-48a9-ba46-b9d54906e415" \
  "${AUTH[@]}" | python3 -m json.tool

# ── GET /v2/options/contracts — List option contracts ────────────────────────
# Required filtering recommended to avoid huge responses
# type: call | put   style: american | european
# OCC symbol format: {underlying}{YYMMDD}{C/P}{strike*1000 zero-padded 8 digits}
curl -s "$BASE/v2/options/contracts?underlying_symbols=AAPL&type=call&expiration_date_gte=2026-03-15&expiration_date_lte=2026-04-30&strike_price_gte=180&strike_price_lte=250&limit=20" \
  "${AUTH[@]}" | python3 -c "import sys,json; d=json.load(sys.stdin); [print(f\"{c['symbol']} strike={c['strike_price']} exp={c['expiration_date']} oi={c.get('open_interest','?')}\") for c in d.get('option_contracts',[])]"

# Puts for SPY:
curl -s "$BASE/v2/options/contracts?underlying_symbols=SPY&type=put&expiration_date_gte=2026-03-15&limit=10" \
  "${AUTH[@]}" | python3 -c "import sys,json; d=json.load(sys.stdin); [print(f\"{c['symbol']} strike={c['strike_price']} exp={c['expiration_date']}\") for c in d.get('option_contracts',[])]"

# Pagination: use next_page_token from response
curl -s "$BASE/v2/options/contracts?underlying_symbols=AAPL&limit=10" \
  "${AUTH[@]}" | python3 -c "import sys,json; d=json.load(sys.stdin); print(f\"count={len(d.get('option_contracts',[]))}\"); print(f\"next_page_token={d.get('next_page_token')}\")"

# ── GET /v2/options/contracts/{symbol_or_id} — Single contract ───────────────
# By OCC symbol:
curl -s "$BASE/v2/options/contracts/AAPL260316C00200000" \
  "${AUTH[@]}" | python3 -m json.tool

# By contract UUID:
# curl -s "$BASE/v2/options/contracts/some-uuid" "${AUTH[@]}" | python3 -m json.tool
