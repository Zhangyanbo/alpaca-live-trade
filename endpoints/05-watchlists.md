# Watchlists

## GET /v2/watchlists — List All

SDK: `client.get_watchlists() -> List[Watchlist]`

### Watchlist Fields
| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Watchlist ID |
| `account_id` | UUID | Account ID |
| `name` | str | Watchlist name |
| `created_at` | datetime | Creation time |
| `updated_at` | datetime | Last update time |
| `assets` | List[Asset] | Assets in watchlist |

## POST /v2/watchlists — Create

SDK: `client.create_watchlist(watchlist_data=CreateWatchlistRequest) -> Watchlist`

```python
from alpaca.trading.requests import CreateWatchlistRequest
wl = client.create_watchlist(CreateWatchlistRequest(
    name="tech-stocks", symbols=["AAPL", "GOOGL", "MSFT", "AMZN"]))
```

## GET /v2/watchlists/{id} — Get by ID

SDK: `client.get_watchlist_by_id(watchlist_id) -> Watchlist`

## PUT /v2/watchlists/{id} — Update

SDK: `client.update_watchlist_by_id(watchlist_id, watchlist_data=UpdateWatchlistRequest) -> Watchlist`

```python
from alpaca.trading.requests import UpdateWatchlistRequest
wl = client.update_watchlist_by_id(wl_id,
    UpdateWatchlistRequest(name="new-name", symbols=["AAPL", "TSLA"]))
```

## POST /v2/watchlists/{id} — Add Asset

SDK: `client.add_asset_to_watchlist_by_id(watchlist_id, symbol) -> Watchlist`

## DELETE /v2/watchlists/{id}/{symbol} — Remove Asset

SDK: `client.remove_asset_from_watchlist_by_id(watchlist_id, symbol) -> Watchlist`

## DELETE /v2/watchlists/{id} — Delete Watchlist

SDK: `client.delete_watchlist_by_id(watchlist_id) -> None`
