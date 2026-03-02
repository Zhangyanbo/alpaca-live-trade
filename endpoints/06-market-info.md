# Market Info: Clock, Calendar, Portfolio History

## GET /v2/clock — Market Clock

SDK: `client.get_clock() -> Clock`

### Clock Fields
| Field | Type | Description |
|-------|------|-------------|
| `timestamp` | datetime | Current market time |
| `is_open` | bool | Market currently open |
| `next_open` | datetime | Next market open |
| `next_close` | datetime | Next market close |

## GET /v2/calendar — Market Calendar

SDK: `client.get_calendar(filters=GetCalendarRequest) -> List[Calendar]`

### Parameters (GetCalendarRequest)
| Field | Type | Description |
|-------|------|-------------|
| `start` | date | Start date |
| `end` | date | End date |

### Calendar Fields
| Field | Type | Description |
|-------|------|-------------|
| `date` | date | Trading date |
| `open` | time | Market open time |
| `close` | time | Market close time |

## GET /v3/clock — Multi-Market Clock (v3)

No SDK method. Use raw requests:
```python
import requests
resp = requests.get("https://paper-api.alpaca.markets/v3/clock", headers=headers)
clocks = resp.json()["clocks"]  # List of clock objects per market
```

Returns clocks for: BMO, BNYM, BOATS, HKEX, IEX, LSE, NASDAQ, NYSE, OPRA, OTC, SIFMA, TADAWUL, XETRA.

## GET /v3/calendar/{market} — Multi-Market Calendar (v3)

No SDK method. Market values from v3 clock response (e.g., NYSE, NASDAQ, OPRA).

```python
resp = requests.get(
    "https://paper-api.alpaca.markets/v3/calendar/NYSE",
    headers=headers,
    params={"start": "2026-03-01", "end": "2026-03-31"})
calendar = resp.json()["calendar"]
```

## GET /v2/account/portfolio/history — Portfolio History

SDK: `client.get_portfolio_history(history_filter=GetPortfolioHistoryRequest) -> PortfolioHistory`

### Parameters (GetPortfolioHistoryRequest)
| Field | Type | Description |
|-------|------|-------------|
| `period` | str | 1D, 1W, 1M, 3M, 1A, all |
| `timeframe` | str | 1Min, 5Min, 15Min, 1H, 1D |
| `intraday_reporting` | str | market_hours, extended_hours, continuous |
| `start` | datetime | Start time |
| `end` | datetime | End time |
| `date_end` | date | End date |
| `extended_hours` | bool | Include extended hours |
| `pnl_reset` | str | per_day, no_reset |

### PortfolioHistory Fields
| Field | Type | Description |
|-------|------|-------------|
| `timestamp` | List[int] | Unix timestamps |
| `equity` | List[float] | Equity values |
| `profit_loss` | List[float] | P/L values |
| `profit_loss_pct` | List[float] | P/L percentages |
| `base_value` | float | Starting portfolio value |
| `timeframe` | str | Data timeframe |

### Example
```python
from alpaca.trading.requests import GetPortfolioHistoryRequest
history = client.get_portfolio_history(
    history_filter=GetPortfolioHistoryRequest(period="1M", timeframe="1D"))
```
