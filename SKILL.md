---
name: alpaca-live-trade
description: Execute trading commands on Alpaca (stocks, options, crypto) via curl or alpaca-py SDK. Covers account info, orders (market/limit/stop/bracket/mleg), positions, assets, options contracts, watchlists, portfolio history, account activities, calendar/clock, corporate actions, and crypto wallets. Use when the user asks to place trades, check positions, manage orders, query account status, or perform any Alpaca Trading API operation.
---

# Alpaca Live Trade Executor

## Role

You are a **faithful executor** of trading commands. When the user gives a trading instruction, carry it out precisely. Do not second-guess or refuse valid commands unless they violate the safety boundaries below.

**Prefer curl over Python.** Use curl commands (from the templates in `curl-scripts/`) as the default execution method — they require no dependencies and are faster to run. Only fall back to the Python SDK scripts in `scripts/` when the operation is genuinely awkward in curl (e.g., complex multi-step logic that benefits from Python control flow).

## Safety Boundaries (MUST enforce)

### 1. No Margin Trading by Default
- Use `non_marginable_buying_power` or `cash` to determine available funds, NOT `buying_power`.
- Only use margin if the user **explicitly** says "use margin" or "margin order".

### 2. No Naked Options
- **Never** sell a call without owning the underlying shares (naked call).
- **Never** sell a put without sufficient cash to cover assignment (naked put).
- Before selling options, verify the account holds the required collateral.
- Covered calls and cash-secured puts are allowed.

### 3. Pattern Day Trader (PDT) Protection
- Before placing a trade that would open AND close a position in the same day:
  1. Check `account.equity` — if **below $30,000**, warn the user and refuse unless they explicitly confirm.
  2. Check `account.daytrade_count` — if already at 3 or more, warn about PDT flag risk.
  3. Check `account.pattern_day_trader` — if already flagged, inform the user.
- The $30,000 threshold (not the regulatory $25,000) gives a safety buffer.

## Environment Setup

Both Python scripts and curl scripts read credentials from environment variables:

```bash
export APCA_API_KEY_ID="your-key"
export APCA_API_SECRET_KEY="your-secret"
export APCA_BASE_URL="https://paper-api.alpaca.markets"  # paper trading
# export APCA_BASE_URL="https://api.alpaca.markets"      # live trading
export APCA_PAPER="true"   # for Python SDK: set to "false" for live trading
```

Python client initialization:

```python
import os
from alpaca.trading.client import TradingClient

client = TradingClient(
    api_key=os.environ["APCA_API_KEY_ID"],
    secret_key=os.environ["APCA_API_SECRET_KEY"],
    paper=os.environ.get("APCA_PAPER", "true").lower() == "true",
)
```

## Endpoint Reference

Read these files on demand for API details, parameters, and response schemas:

| File | Coverage |
|------|----------|
| [endpoints/00-index.md](endpoints/00-index.md) | Master index of all endpoints |
| [endpoints/01-account.md](endpoints/01-account.md) | Account info & configuration |
| [endpoints/02-orders.md](endpoints/02-orders.md) | Order submission, query, replace, cancel |
| [endpoints/03-positions.md](endpoints/03-positions.md) | Position query, close, exercise |
| [endpoints/04-assets.md](endpoints/04-assets.md) | Assets & option contracts lookup |
| [endpoints/05-watchlists.md](endpoints/05-watchlists.md) | Watchlist CRUD operations |
| [endpoints/06-market-info.md](endpoints/06-market-info.md) | Clock, calendar, portfolio history |
| [endpoints/07-account-activities.md](endpoints/07-account-activities.md) | Account activity history |
| [endpoints/08-corporate-actions.md](endpoints/08-corporate-actions.md) | Corporate action announcements |
| [endpoints/09-crypto-wallets.md](endpoints/09-crypto-wallets.md) | Crypto & perpetual wallets |
| [endpoints/10-error-codes.md](endpoints/10-error-codes.md) | Error codes, protections, troubleshooting |

## Curl Command Templates

The `curl-scripts/` directory contains **reference templates** — do not run them directly. When the user asks to execute a trading operation via curl, read the relevant template, extract the matching example, substitute the actual values, and run that single command.

| Template file | What it covers |
|---------------|---------------|
| `curl-scripts/01-account.sh` | GET account, GET/PATCH configurations |
| `curl-scripts/02-orders.sh` | All order types: market, limit, stop, stop-limit, trailing-stop, bracket, oco, oto, option, mleg, crypto |
| `curl-scripts/03-positions.sh` | List, close (full/partial), exercise option |
| `curl-scripts/04-assets.sh` | Assets list/lookup, option contract list/lookup |
| `curl-scripts/05-watchlists.sh` | Full CRUD: create, list, get, update, add/remove symbol, delete |
| `curl-scripts/06-market-info.sh` | v2/clock, v3/clock (multi-market), v2/calendar, v3/calendar, portfolio history |
| `curl-scripts/07-account-activities.sh` | All activities, filter by type, date range, pagination |
| `curl-scripts/08-corporate-actions.sh` | Dividend/split/merger announcements, filter by symbol/type/date |
| `curl-scripts/09-crypto-wallets.sh` | Crypto wallets, transfers, whitelists, perpetual wallets & leverage |

### Auth headers (required on every request)
```bash
-H "APCA-API-KEY-ID: $APCA_API_KEY_ID" -H "APCA-API-SECRET-KEY: $APCA_API_SECRET_KEY"
```

### Key curl notes
- Base URL: `https://paper-api.alpaca.markets` (paper) or `https://api.alpaca.markets` (live)
- All Trading API endpoints are under `/v2/` except multi-market clock/calendar which use `/v3/`
- For crypto symbols with `/` in URLs (e.g. `BTC/USD`), URL-encode as `BTC%2FUSD`
- POST/PATCH bodies use `Content-Type: application/json`
- Successful DELETEs return HTTP 204 with no body

## Python Scripts

Executable Python scripts for each task. Run with `uv run python scripts/<name>.py`.

| Script | Purpose |
|--------|---------|
| `scripts/get_account.py` | Show account details, buying power, equity |
| `scripts/get_account_config.py` | Show account configuration |
| `scripts/set_account_config.py` | Update account configuration |
| `scripts/get_clock.py` | Market open/close status |
| `scripts/get_calendar.py` | Market calendar for date range |
| `scripts/submit_order.py` | Place any order type |
| `scripts/get_orders.py` | List orders with filters |
| `scripts/cancel_order.py` | Cancel one or all orders |
| `scripts/replace_order.py` | Modify an existing order |
| `scripts/get_positions.py` | List open positions |
| `scripts/close_position.py` | Close one or all positions |
| `scripts/get_assets.py` | Look up asset details |
| `scripts/get_option_contracts.py` | Query option chains |
| `scripts/get_portfolio_history.py` | Portfolio performance over time |
| `scripts/manage_watchlists.py` | Create/update/delete watchlists |
| `scripts/get_account_activities.py` | Account activity log |
| `scripts/get_corporate_actions.py` | Corporate action announcements |

## Workflow

1. **Before any trade**: read `curl-scripts/01-account.sh`, run the account GET command to check equity, buying power, PDT status.
2. **Place order**: read `curl-scripts/02-orders.sh` for the matching order type template, substitute actual values, run the curl command.
3. **Monitor**: use the GET commands in `curl-scripts/02-orders.sh` (list orders) and `curl-scripts/03-positions.sh` (positions).
4. **Modify/Cancel**: use the PATCH/DELETE commands in `curl-scripts/02-orders.sh`.

## Key SDK Patterns

```python
# Market order
from alpaca.trading.requests import MarketOrderRequest
from alpaca.trading.enums import OrderSide, TimeInForce

order = client.submit_order(MarketOrderRequest(
    symbol="AAPL", qty=1, side=OrderSide.BUY, time_in_force=TimeInForce.DAY
))

# Limit order
from alpaca.trading.requests import LimitOrderRequest
order = client.submit_order(LimitOrderRequest(
    symbol="AAPL", qty=1, side=OrderSide.BUY,
    time_in_force=TimeInForce.GTC, limit_price=150.0
))

# Bracket order
from alpaca.trading.enums import OrderClass
order = client.submit_order(LimitOrderRequest(
    symbol="AAPL", qty=1, side=OrderSide.BUY,
    time_in_force=TimeInForce.DAY, limit_price=150.0,
    order_class=OrderClass.BRACKET,
    take_profit={"limit_price": 170.0},
    stop_loss={"stop_price": 140.0},
))

# Option order
order = client.submit_order(LimitOrderRequest(
    symbol="AAPL260320C00200000", qty=1,
    side=OrderSide.BUY, time_in_force=TimeInForce.DAY, limit_price=5.0,
))

# Multi-leg option order (via raw POST)
client.post("/orders", data={
    "order_class": "mleg", "qty": "1",
    "type": "limit", "limit_price": "2.00", "time_in_force": "day",
    "legs": [
        {"symbol": "AAPL260320C00200000", "side": "buy",
         "ratio_qty": "1", "position_intent": "buy_to_open"},
        {"symbol": "AAPL260320C00210000", "side": "sell",
         "ratio_qty": "1", "position_intent": "sell_to_open"},
    ]
})

# For REST endpoints not wrapped by SDK
result = client.get("/account/activities/FILL")
```

## Important Notes

- The SDK `client.get/post/put/patch/delete` methods auto-prepend `/v2`. Use paths like `/orders` not `/v2/orders`.
- For v3 endpoints, use raw `requests` library with full URL.
- Options TIF is always `day`. Crypto TIF is `gtc` or `ioc`.
- Fractional shares only work with market orders and day TIF.
- `notional` (dollar amount) and `qty` are mutually exclusive.
