#!/usr/bin/env bash
# Orders — curl examples for all order types and CRUD operations
#
# export APCA_API_KEY_ID="your-key"
# export APCA_API_SECRET_KEY="your-secret"
# export APCA_BASE_URL="https://paper-api.alpaca.markets"

BASE="${APCA_BASE_URL:-https://paper-api.alpaca.markets}"
AUTH=(-H "APCA-API-KEY-ID: ${APCA_API_KEY_ID}" -H "APCA-API-SECRET-KEY: ${APCA_API_SECRET_KEY}")
CT=(-H "Content-Type: application/json")

# ── POST /v2/orders — Market order ───────────────────────────────────────────
curl -s -X POST "$BASE/v2/orders" "${AUTH[@]}" "${CT[@]}" -d '{
  "symbol": "AAPL",
  "qty": "1",
  "side": "buy",
  "type": "market",
  "time_in_force": "day"
}' | python3 -m json.tool

# ── POST /v2/orders — Market order by notional (dollar amount) ───────────────
# notional: buy $500 worth; only works with market + day TIF; cannot use qty simultaneously
curl -s -X POST "$BASE/v2/orders" "${AUTH[@]}" "${CT[@]}" -d '{
  "symbol": "AAPL",
  "notional": "500",
  "side": "buy",
  "type": "market",
  "time_in_force": "day"
}' | python3 -m json.tool

# ── POST /v2/orders — Limit order ────────────────────────────────────────────
curl -s -X POST "$BASE/v2/orders" "${AUTH[@]}" "${CT[@]}" -d '{
  "symbol": "AAPL",
  "qty": "10",
  "side": "buy",
  "type": "limit",
  "time_in_force": "gtc",
  "limit_price": "150.00"
}' | python3 -m json.tool

# ── POST /v2/orders — Stop order ─────────────────────────────────────────────
# Triggers a market order when price hits stop_price
curl -s -X POST "$BASE/v2/orders" "${AUTH[@]}" "${CT[@]}" -d '{
  "symbol": "AAPL",
  "qty": "10",
  "side": "sell",
  "type": "stop",
  "time_in_force": "day",
  "stop_price": "140.00"
}' | python3 -m json.tool

# ── POST /v2/orders — Stop-limit order ───────────────────────────────────────
# Triggers a limit order when price hits stop_price
curl -s -X POST "$BASE/v2/orders" "${AUTH[@]}" "${CT[@]}" -d '{
  "symbol": "AAPL",
  "qty": "10",
  "side": "sell",
  "type": "stop_limit",
  "time_in_force": "day",
  "stop_price": "140.00",
  "limit_price": "139.00"
}' | python3 -m json.tool

# ── POST /v2/orders — Trailing stop (percent) ────────────────────────────────
# Trails by 5% below the high-water-mark price
curl -s -X POST "$BASE/v2/orders" "${AUTH[@]}" "${CT[@]}" -d '{
  "symbol": "AAPL",
  "qty": "10",
  "side": "sell",
  "type": "trailing_stop",
  "time_in_force": "gtc",
  "trail_percent": "5.0"
}' | python3 -m json.tool

# ── POST /v2/orders — Trailing stop (price) ──────────────────────────────────
# Trails by $5 below the high-water-mark price
curl -s -X POST "$BASE/v2/orders" "${AUTH[@]}" "${CT[@]}" -d '{
  "symbol": "AAPL",
  "qty": "10",
  "side": "sell",
  "type": "trailing_stop",
  "time_in_force": "gtc",
  "trail_price": "5.00"
}' | python3 -m json.tool

# ── POST /v2/orders — Bracket order ──────────────────────────────────────────
# Entry + take_profit + stop_loss in one order
curl -s -X POST "$BASE/v2/orders" "${AUTH[@]}" "${CT[@]}" -d '{
  "symbol": "AAPL",
  "qty": "10",
  "side": "buy",
  "type": "limit",
  "time_in_force": "day",
  "limit_price": "150.00",
  "order_class": "bracket",
  "take_profit": {"limit_price": "170.00"},
  "stop_loss": {"stop_price": "140.00", "limit_price": "139.00"}
}' | python3 -m json.tool

# ── POST /v2/orders — OCO (one-cancels-other) ────────────────────────────────
# Both legs exist; whichever fills cancels the other
curl -s -X POST "$BASE/v2/orders" "${AUTH[@]}" "${CT[@]}" -d '{
  "symbol": "AAPL",
  "qty": "10",
  "side": "sell",
  "type": "limit",
  "time_in_force": "day",
  "limit_price": "170.00",
  "order_class": "oco",
  "stop_loss": {"stop_price": "140.00", "limit_price": "139.00"}
}' | python3 -m json.tool

# ── POST /v2/orders — OTO (one-triggers-other) ───────────────────────────────
# Primary order; when filled, secondary order is placed
curl -s -X POST "$BASE/v2/orders" "${AUTH[@]}" "${CT[@]}" -d '{
  "symbol": "AAPL",
  "qty": "10",
  "side": "buy",
  "type": "limit",
  "time_in_force": "day",
  "limit_price": "150.00",
  "order_class": "oto",
  "take_profit": {"limit_price": "170.00"}
}' | python3 -m json.tool

# ── POST /v2/orders — Extended hours limit order ─────────────────────────────
# Pre/post-market; must be limit + day TIF
curl -s -X POST "$BASE/v2/orders" "${AUTH[@]}" "${CT[@]}" -d '{
  "symbol": "AAPL",
  "qty": "1",
  "side": "buy",
  "type": "limit",
  "time_in_force": "day",
  "limit_price": "150.00",
  "extended_hours": true
}' | python3 -m json.tool

# ── POST /v2/orders — Option order ───────────────────────────────────────────
# OCC symbol format: {underlying}{YYMMDD}{C/P}{strike*1000 padded 8 digits}
# Example: AAPL260316C00200000 = AAPL Call, 2026-03-16, $200 strike
curl -s -X POST "$BASE/v2/orders" "${AUTH[@]}" "${CT[@]}" -d '{
  "symbol": "AAPL260316C00200000",
  "qty": "1",
  "side": "buy",
  "type": "limit",
  "time_in_force": "day",
  "limit_price": "5.00",
  "position_intent": "buy_to_open"
}' | python3 -m json.tool

# ── POST /v2/orders — Multi-leg option order (vertical spread) ───────────────
# order_class=mleg; no top-level symbol; each leg has symbol, side, ratio_qty, position_intent
curl -s -X POST "$BASE/v2/orders" "${AUTH[@]}" "${CT[@]}" -d '{
  "order_class": "mleg",
  "qty": "1",
  "type": "limit",
  "limit_price": "2.00",
  "time_in_force": "day",
  "legs": [
    {"symbol": "AAPL260316C00200000", "side": "buy",  "ratio_qty": "1", "position_intent": "buy_to_open"},
    {"symbol": "AAPL260316C00210000", "side": "sell", "ratio_qty": "1", "position_intent": "sell_to_open"}
  ]
}' | python3 -m json.tool

# ── POST /v2/orders — Crypto market order ────────────────────────────────────
# Crypto symbols use slash notation: BTC/USD, ETH/USD, SOL/USD, etc.
# TIF must be gtc or ioc for crypto; fractional qty supported
curl -s -X POST "$BASE/v2/orders" "${AUTH[@]}" "${CT[@]}" -d '{
  "symbol": "BTC/USD",
  "qty": "0.001",
  "side": "buy",
  "type": "market",
  "time_in_force": "ioc"
}' | python3 -m json.tool

# ── POST /v2/orders — Crypto limit order ─────────────────────────────────────
curl -s -X POST "$BASE/v2/orders" "${AUTH[@]}" "${CT[@]}" -d '{
  "symbol": "ETH/USD",
  "qty": "0.01",
  "side": "buy",
  "type": "limit",
  "time_in_force": "gtc",
  "limit_price": "2000.00"
}' | python3 -m json.tool

# ── GET /v2/orders — List orders ─────────────────────────────────────────────
# status: open | closed | all   direction: asc | desc   limit: max 500
curl -s "$BASE/v2/orders?status=open&limit=50&direction=desc" \
  "${AUTH[@]}" | python3 -m json.tool

# Filter by symbol:
curl -s "$BASE/v2/orders?status=all&symbols=AAPL,TSLA&limit=20" \
  "${AUTH[@]}" | python3 -m json.tool

# ── GET /v2/orders/{order_id} — Get single order ─────────────────────────────
ORDER_ID="replace-with-order-uuid"
curl -s "$BASE/v2/orders/${ORDER_ID}" \
  "${AUTH[@]}" | python3 -m json.tool

# ── GET /v2/orders:by_client_order_id — Get by custom ID ─────────────────────
curl -s "$BASE/v2/orders:by_client_order_id?client_order_id=my-custom-id-123" \
  "${AUTH[@]}" | python3 -m json.tool

# ── PATCH /v2/orders/{order_id} — Replace/modify open order ──────────────────
# Can change: qty, time_in_force, limit_price, stop_price, trail, client_order_id
# Returns: new replacement order (original is cancelled)
curl -s -X PATCH "$BASE/v2/orders/${ORDER_ID}" \
  "${AUTH[@]}" "${CT[@]}" \
  -d '{
    "limit_price": "148.00",
    "qty": "5"
  }' | python3 -m json.tool

# ── DELETE /v2/orders/{order_id} — Cancel single order ───────────────────────
curl -s -X DELETE "$BASE/v2/orders/${ORDER_ID}" \
  "${AUTH[@]}" -w "HTTP %{http_code}\n" -o /dev/null

# ── DELETE /v2/orders — Cancel ALL open orders ───────────────────────────────
# Returns array of {id, status} for each cancellation
curl -s -X DELETE "$BASE/v2/orders" \
  "${AUTH[@]}" | python3 -m json.tool
