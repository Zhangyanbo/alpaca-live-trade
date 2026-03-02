# Orders

## Order Types
| Type | Enum | Description | Supported Assets |
|------|------|-------------|-----------------|
| Market | `market` | Execute at current price | Equity, Options, Crypto |
| Limit | `limit` | Execute at limit price or better | Equity, Options, Crypto |
| Stop | `stop` | Trigger market order at stop price | Equity |
| Stop Limit | `stop_limit` | Trigger limit order at stop price | Equity, Crypto |
| Trailing Stop | `trailing_stop` | Trail by price or percent | Equity |

## Order Classes
| Class | Description | Supported |
|-------|-------------|-----------|
| `simple` / `""` | Single order | All |
| `bracket` | Entry + take profit + stop loss | Equity |
| `oco` | One-cancels-other | Equity |
| `oto` | One-triggers-other | Equity |
| `mleg` | Multi-leg options | Options |

## Time In Force
| TIF | Description | Equity | Options | Crypto |
|-----|-------------|--------|---------|--------|
| `day` | Valid until close | Yes | Yes | No |
| `gtc` | Good until cancelled | Yes | No | Yes |
| `opg` | Market/limit on open | Yes | No | No |
| `cls` | Market/limit on close | Yes | No | No |
| `ioc` | Immediate or cancel | Yes | No | Yes |
| `fok` | Fill or kill | Yes | No | No |

## POST /v2/orders — Create Order

SDK: `client.submit_order(OrderRequest) -> Order`

### Request Models
| Model | Use Case |
|-------|----------|
| `MarketOrderRequest` | Market orders |
| `LimitOrderRequest` | Limit orders (also bracket/oto/oco) |
| `StopOrderRequest` | Stop orders |
| `StopLimitOrderRequest` | Stop limit orders |
| `TrailingStopOrderRequest` | Trailing stop orders |

### Common Parameters
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `symbol` | str | Yes* | Symbol or asset ID (*not for mleg) |
| `qty` | int/float | Yes** | Share count (**or use notional) |
| `notional` | float | No | Dollar amount (market+day only) |
| `side` | OrderSide | Yes* | BUY or SELL |
| `time_in_force` | TimeInForce | Yes | DAY, GTC, etc. |
| `limit_price` | float | Conditional | Required for limit, stop_limit |
| `stop_price` | float | Conditional | Required for stop, stop_limit |
| `trail_price` | float | Conditional | For trailing_stop |
| `trail_percent` | float | Conditional | For trailing_stop |
| `extended_hours` | bool | No | Pre/after market (limit+day only) |
| `client_order_id` | str | No | Custom ID (max 128 chars) |
| `order_class` | OrderClass | No | simple, bracket, oco, oto, mleg |
| `take_profit` | dict | No | `{"limit_price": "170"}` for bracket/oto |
| `stop_loss` | dict | No | `{"stop_price": "140", "limit_price": "139"}` |
| `position_intent` | PositionIntent | No | buy_to_open, buy_to_close, sell_to_open, sell_to_close |

### Examples

```python
from alpaca.trading.requests import (
    MarketOrderRequest, LimitOrderRequest,
    StopOrderRequest, StopLimitOrderRequest,
    TrailingStopOrderRequest,
)
from alpaca.trading.enums import OrderSide, TimeInForce, OrderClass

# Market buy
client.submit_order(MarketOrderRequest(
    symbol="AAPL", qty=10, side=OrderSide.BUY, time_in_force=TimeInForce.DAY))

# Limit buy
client.submit_order(LimitOrderRequest(
    symbol="AAPL", qty=10, side=OrderSide.BUY,
    time_in_force=TimeInForce.GTC, limit_price=150.0))

# Stop sell
client.submit_order(StopOrderRequest(
    symbol="AAPL", qty=10, side=OrderSide.SELL,
    time_in_force=TimeInForce.DAY, stop_price=140.0))

# Stop limit
client.submit_order(StopLimitOrderRequest(
    symbol="AAPL", qty=10, side=OrderSide.SELL,
    time_in_force=TimeInForce.DAY, stop_price=140.0, limit_price=139.0))

# Trailing stop (percent)
client.submit_order(TrailingStopOrderRequest(
    symbol="AAPL", qty=10, side=OrderSide.SELL,
    time_in_force=TimeInForce.GTC, trail_percent=5.0))

# Bracket order
client.submit_order(LimitOrderRequest(
    symbol="AAPL", qty=10, side=OrderSide.BUY,
    time_in_force=TimeInForce.DAY, limit_price=150.0,
    order_class=OrderClass.BRACKET,
    take_profit={"limit_price": 170.0},
    stop_loss={"stop_price": 140.0, "limit_price": 139.0}))

# Notional (dollar amount)
client.submit_order(MarketOrderRequest(
    symbol="AAPL", notional=500.0, side=OrderSide.BUY,
    time_in_force=TimeInForce.DAY))

# Option order
client.submit_order(LimitOrderRequest(
    symbol="AAPL260320C00200000", qty=1, side=OrderSide.BUY,
    time_in_force=TimeInForce.DAY, limit_price=5.0))

# Multi-leg option (raw POST — SDK doesn't have a dedicated model)
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
```

## GET /v2/orders — List Orders

SDK: `client.get_orders(filter=GetOrdersRequest) -> List[Order]`

### Parameters (GetOrdersRequest)
| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `status` | QueryOrderStatus | open | OPEN, CLOSED, ALL |
| `limit` | int | 50 | Max results (max 500) |
| `after` | datetime | None | After this timestamp |
| `until` | datetime | None | Until this timestamp |
| `direction` | Sort | desc | ASC or DESC |
| `nested` | bool | None | Include leg orders |
| `side` | OrderSide | None | Filter by side |
| `symbols` | List[str] | None | Filter by symbols |

### Example
```python
from alpaca.trading.requests import GetOrdersRequest
from alpaca.trading.enums import QueryOrderStatus

orders = client.get_orders(filter=GetOrdersRequest(
    status=QueryOrderStatus.OPEN, limit=10))
```

## GET /v2/orders/{order_id} — Get Order

SDK: `client.get_order_by_id(order_id, filter=GetOrderByIdRequest) -> Order`

## GET /v2/orders:by_client_order_id — Get by Client ID

SDK: `client.get_order_by_client_id(client_id) -> Order`

## PATCH /v2/orders/{order_id} — Replace Order

SDK: `client.replace_order_by_id(order_id, order_data=ReplaceOrderRequest) -> Order`

### Parameters (ReplaceOrderRequest)
| Field | Type | Description |
|-------|------|-------------|
| `qty` | int | New quantity |
| `time_in_force` | TimeInForce | New TIF |
| `limit_price` | float | New limit price |
| `stop_price` | float | New stop price |
| `trail` | float | New trail value |
| `client_order_id` | str | New client order ID |

## DELETE /v2/orders/{order_id} — Cancel Order

SDK: `client.cancel_order_by_id(order_id) -> None`

## DELETE /v2/orders — Cancel All Orders

SDK: `client.cancel_orders() -> List[CancelOrderResponse]`

## Order Response Fields
| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Order ID |
| `client_order_id` | str | Client-provided ID |
| `created_at` | datetime | Creation time |
| `status` | OrderStatus | new, filled, canceled, etc. |
| `symbol` | str | Asset symbol |
| `qty` | str | Ordered quantity |
| `filled_qty` | str | Filled quantity |
| `filled_avg_price` | str | Average fill price |
| `type` | OrderType | market, limit, etc. |
| `side` | OrderSide | buy or sell |
| `time_in_force` | TimeInForce | day, gtc, etc. |
| `limit_price` | str | Limit price |
| `stop_price` | str | Stop price |
| `order_class` | OrderClass | simple, bracket, mleg, etc. |
| `legs` | List[Order] | Child orders for complex orders |
| `trail_percent` | str | Trailing stop percent |
| `trail_price` | str | Trailing stop dollar amount |
| `hwm` | str | High water mark for trailing stop |
| `extended_hours` | bool | Extended hours eligible |
