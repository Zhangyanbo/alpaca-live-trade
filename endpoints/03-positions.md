# Positions

## GET /v2/positions — All Open Positions

SDK: `client.get_all_positions() -> List[Position]`

No parameters required.

### Position Fields
| Field | Type | Description |
|-------|------|-------------|
| `asset_id` | UUID | Asset ID (option contract ID for options) |
| `symbol` | str | Symbol |
| `exchange` | str | AMEX, ARCA, BATS, NYSE, NASDAQ, etc. |
| `asset_class` | AssetClass | us_equity, us_option, crypto |
| `avg_entry_price` | str | Average entry price |
| `qty` | str | Number of shares |
| `qty_available` | str | Available qty (minus open orders) |
| `side` | str | "long" or "short" |
| `market_value` | str | Current market value |
| `cost_basis` | str | Total cost basis |
| `unrealized_pl` | str | Unrealized P/L |
| `unrealized_plpc` | str | Unrealized P/L percent |
| `unrealized_intraday_pl` | str | Intraday P/L |
| `unrealized_intraday_plpc` | str | Intraday P/L percent |
| `current_price` | str | Current price |
| `lastday_price` | str | Previous close price |
| `change_today` | str | Today's change percent |
| `asset_marginable` | bool | Marginable asset |

### Example
```python
positions = client.get_all_positions()
for p in positions:
    print(f"{p.symbol}: qty={p.qty} P/L={p.unrealized_pl}")
```

## GET /v2/positions/{symbol_or_asset_id} — Single Position

SDK: `client.get_open_position(symbol_or_asset_id) -> Position`

## DELETE /v2/positions/{symbol_or_asset_id} — Close Position

SDK: `client.close_position(symbol_or_asset_id, close_options=ClosePositionRequest) -> Order`

### ClosePositionRequest Parameters
| Field | Type | Description |
|-------|------|-------------|
| `qty` | str | Number of shares to close (partial close) |
| `percentage` | str | Percentage to close (0-100) |

### Example
```python
from alpaca.trading.requests import ClosePositionRequest

# Close all shares
order = client.close_position("AAPL")

# Close 50%
order = client.close_position("AAPL",
    close_options=ClosePositionRequest(percentage="50"))

# Close specific qty
order = client.close_position("AAPL",
    close_options=ClosePositionRequest(qty="5"))
```

## DELETE /v2/positions — Close All Positions

SDK: `client.close_all_positions(cancel_orders=True) -> List[ClosePositionResponse]`

### Parameters
| Field | Type | Description |
|-------|------|-------------|
| `cancel_orders` | bool | Cancel open orders first |

## POST /v2/positions/{id}/exercise — Exercise Option

SDK: `client.exercise_options_position(symbol_or_contract_id) -> None`

Exercises all held contracts of the specified option position.

## POST /v2/positions/{id}/do-not-exercise — Do Not Exercise

No SDK method. Use raw POST:
```python
client.post(f"/positions/{contract_id}/do-not-exercise")
```
