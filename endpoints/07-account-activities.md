# Account Activities

**Note:** No high-level SDK method. Use `client.get()` with path `/account/activities`.

## GET /v2/account/activities — All Activities

```python
activities = client.get("/account/activities")
```

### Query Parameters (pass as `data` dict)
| Field | Type | Description |
|-------|------|-------------|
| `activity_type` | str | Filter by type (FILL, TRANS, etc.) |
| `date` | date | Exact date |
| `until` | datetime | Activities before this time |
| `after` | datetime | Activities after this time |
| `direction` | str | asc or desc |
| `page_size` | int | Max results |
| `page_token` | str | Pagination token |

## GET /v2/account/activities/{type} — By Type

```python
fills = client.get("/account/activities/FILL")
```

### Activity Types
| Type | Description |
|------|-------------|
| `FILL` | Order fills |
| `TRANS` | Cash transactions |
| `MISC` | Miscellaneous |
| `ACATC` | ACAT transfer completed |
| `ACATS` | ACAT transfer sent |
| `CSD` | Cash deposit |
| `CSW` | Cash withdrawal |
| `DIV` | Dividend |
| `JNLC` | Journal entry (cash) |
| `JNLS` | Journal entry (stock) |
| `MA` | Merger/acquisition |
| `NC` | Name change |
| `PTC` | Pass-through charge |
| `REORG` | Reorganization |
| `SSO` | Stock spinoff |
| `SSP` | Stock split |

### TradeActivity Fields (FILL)
| Field | Type | Description |
|-------|------|-------------|
| `id` | str | Activity ID |
| `activity_type` | str | FILL |
| `transaction_time` | datetime | Transaction time |
| `type` | str | fill or partial_fill |
| `price` | str | Execution price |
| `qty` | str | Quantity |
| `side` | str | buy or sell |
| `symbol` | str | Symbol |
| `leaves_qty` | str | Remaining quantity |
| `order_id` | UUID | Related order |
| `cum_qty` | str | Cumulative filled qty |
| `order_status` | str | Order status |

### NonTradeActivity Fields (TRANS, etc.)
| Field | Type | Description |
|-------|------|-------------|
| `id` | str | Activity ID |
| `activity_type` | str | Activity type |
| `date` | date | Activity date |
| `net_amount` | str | Net dollar amount |
| `symbol` | str | Symbol (if applicable) |
| `qty` | str | Quantity (if applicable) |
| `per_share_amount` | str | Per share amount |
| `description` | str | Description |
