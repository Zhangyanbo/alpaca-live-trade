# Error Codes & Troubleshooting

## HTTP Status Codes

| HTTP Status | Meaning | Common Cause |
|-------------|---------|-------------|
| 200 | OK | Request succeeded |
| 207 | Multi-Status | Partial success (e.g., close_all_positions with mixed results) |
| 401 | Unauthorized | Invalid or missing API key/secret |
| 403 | Forbidden | Insufficient buying power, PDT protection, wash trade |
| 404 | Not Found | Resource doesn't exist (order, position, endpoint) |
| 422 | Unprocessable Entity | Invalid parameters, validation error |
| 429 | Too Many Requests | Rate limit exceeded (200 req/min) |

## Error Code Reference

Error responses return JSON with `code` and `message` fields:
```json
{"code": 40010001, "message": "qty must be > 0"}
```

### Code Format

Error codes follow the pattern `HHHCCCCC` where:
- `HHH` = HTTP status (e.g., 401, 403, 404, 422)
- `CCCCC` = Specific error ID

### 401 — Authentication Errors

| Code | Message | Cause | Fix |
|------|---------|-------|-----|
| *(no code)* | `unauthorized.` | Missing or invalid API key/secret | Check APCA-API-KEY-ID and APCA-API-SECRET-KEY headers |

### 403 — Forbidden Errors

| Code | Message | Cause | Fix |
|------|---------|-------|-----|
| `40310000` | `insufficient buying power` | Not enough cash/margin for order | Reduce order size or add funds |
| `40310000` | `cannot open a short sell while a long buy order is open` | Wash trade protection | Cancel the conflicting buy order first |
| `40310100` | `trade denied due to pattern day trading protection` | Would create 4th day trade with equity < $25k | Wait until next day, or increase equity above $25k |

### 404 — Not Found Errors

| Code | Message | Cause | Fix |
|------|---------|-------|-----|
| `40410000` | `order not found for {uuid}` | Order ID doesn't exist | Verify the order ID |
| `40410000` | `symbol not found: {symbol}` | No position for this symbol | Check symbol with get_positions |
| `40410000` | `position does not exist` | Position doesn't exist | Symbol may have been closed |
| `40410000` | `endpoint not found` | API endpoint doesn't exist | Check URL path |

### 422 — Validation Errors

| Code | Message | Cause | Fix |
|------|---------|-------|-----|
| `40010001` | `qty or notional is required` | Order missing qty/notional | Provide --qty or --notional |
| `40010001` | `only one of qty or notional is accepted` | Both qty and notional provided | Use only one |
| `40010001` | `qty must be > 0` | Zero or negative quantity | Use positive qty |
| `40010001` | `invalid order type` | Unrecognized order type | Use: market, limit, stop, stop_limit, trailing_stop |
| `40010001` | `invalid side` | Unrecognized side | Use: buy, sell |
| `40010001` | `invalid time_in_force` | Unrecognized TIF | Use: day, gtc, opg, cls, ioc, fok |
| `40010001` | `limit orders require a limit price` | Limit/stop_limit without limit_price | Add --limit-price |
| `40010001` | `stop orders require a stop price` | Stop/stop_limit without stop_price | Add --stop-price |
| `40010001` | `trailing stop orders must specify one of trail_price or trail_percent` | No trail value | Add --trail-price or --trail-percent |
| `40010001` | `client_order_id must be no more than 128 characters` | Client order ID too long | Shorten to <= 128 chars |
| `40010001` | `watchlist name must be unique` | Duplicate watchlist name | Choose a different name |
| `40010001` | `invalid param: both since & until required` | Corporate actions missing dates | Provide both --since and --until |
| `40010001` | `order_id is missing` | Invalid UUID format for order_id | Provide valid UUID |
| `40010001` | `pdt_check value is invalid` | Invalid PDT check value | Use: entry, exit, both |
| `40010001` | `invalid crypto time_in_force` | Wrong TIF for crypto | Use gtc or ioc for crypto |
| `42210000` | `asset "{symbol}" not found` | Symbol doesn't exist | Check symbol spelling |
| `42210000` | `invalid symbol` | Invalid option symbol format | Check OCC symbol format |
| `42210000` | `extended hours order must be DAY or GTC limit orders` | Extended hours with market order | Use limit order for extended hours |
| `42210000` | `order_time_in_force provided not supported for options trading` | GTC for options | Options only support TIF=day |
| `42210000` | `take_profit.limit_price must be > stop_loss.stop_price` | Invalid bracket prices | Take profit must be above stop loss |
| `42210000` | `mleg orders must have at least 2 legs and at most 4 legs` | Wrong number of mleg legs | Provide 2-4 legs |
| `42210000` | `position intent mismatch, inferred: {x}, specified: {y}` | Wrong position_intent | Match intent to actual position state |
| `42210000` | `invalid order type for crypto order` | Stop order for crypto | Use market, limit, or stop_limit for crypto |

## Protection Mechanisms

### Pattern Day Trader (PDT) Protection

- **Rule**: 4+ day trades in 5 business days with equity < $25,000 flags account as PDT
- **Error**: HTTP 403, code `40310100`
- **Active in paper trading**: Yes
- **Account config**: `pdt_check` = entry | exit | both
  - `entry`: Blocks order submission that would cause 4th day trade
  - `exit`: Blocks position exit that would cause day trade
  - `both`: Blocks on both entry and exit
- **Crypto exempt**: Crypto trades do NOT count as day trades

### Day Trade Margin Call (DTMC) Protection

- **Rule**: PDT accounts need $25k or 25% of position value
- **Account config**: `dtbp_check` = entry | exit | both
- **Only for PDT accounts** (multiplier = 4)

### Wash Trade Protection

- **Rule**: Prevents buy/sell orders on same security from interacting
- **Error**: HTTP 403, code `40310000`, message about "short sell while long buy order is open"
- **Exception**: Bracket, OCO, OTO orders and trailing stops are exempt
- **Active in paper trading**: Yes

### Limit Price Sanity Check

- Limit orders with prices far from market price may be rejected
- Protects against unintentional large limit orders

## Rate Limits

- **REST API**: 200 requests per minute per API key
- Exceeding returns HTTP 429
- Rate limit resets every minute

## Error Handling Pattern

```python
from alpaca.common.exceptions import APIError

try:
    order = client.submit_order(order_data=req)
except APIError as e:
    error_str = str(e)
    if "40310100" in error_str:
        print("PDT protection: cannot day trade")
    elif "40310000" in error_str:
        print("Insufficient buying power or wash trade")
    elif "40410000" in error_str:
        print("Resource not found")
    elif "40010001" in error_str:
        print(f"Invalid parameter: {e}")
    elif "42210000" in error_str:
        print(f"Validation error: {e}")
    else:
        print(f"API error: {e}")
```

## Common Pitfalls

1. **SDK path prefix**: `client.get("/orders")` auto-prepends `/v2`, so use `/orders` not `/v2/orders`
2. **Crypto symbol format**: Order with `BTC/USD`, but position lookup uses `BTCUSD` (no slash)
3. **Options TIF**: Only `day` is allowed for options orders
4. **Crypto TIF**: Only `gtc` and `ioc` for crypto orders
5. **Fractional shares**: Only work with market orders + day TIF
6. **Notional orders**: Only work with market orders + day TIF, cannot combine with qty
7. **Extended hours**: Only limit orders with TIF=day support extended hours
8. **AccountConfiguration**: SDK model requires all fields; use raw PATCH for partial updates
