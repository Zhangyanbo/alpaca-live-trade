# Alpaca Trading API — Endpoint Index

Master index of all available Trading API endpoints organized by category.

## Account
| Endpoint | Method | SDK Method | Reference |
|----------|--------|------------|-----------|
| `/v2/account` | GET | `client.get_account()` | [01-account.md](01-account.md) |
| `/v2/account/configurations` | GET | `client.get_account_configurations()` | [01-account.md](01-account.md) |
| `/v2/account/configurations` | PATCH | `client.set_account_configurations()` | [01-account.md](01-account.md) |

## Orders
| Endpoint | Method | SDK Method | Reference |
|----------|--------|------------|-----------|
| `/v2/orders` | POST | `client.submit_order()` | [02-orders.md](02-orders.md) |
| `/v2/orders` | GET | `client.get_orders()` | [02-orders.md](02-orders.md) |
| `/v2/orders` | DELETE | `client.cancel_orders()` | [02-orders.md](02-orders.md) |
| `/v2/orders/{order_id}` | GET | `client.get_order_by_id()` | [02-orders.md](02-orders.md) |
| `/v2/orders/{order_id}` | PATCH | `client.replace_order_by_id()` | [02-orders.md](02-orders.md) |
| `/v2/orders/{order_id}` | DELETE | `client.cancel_order_by_id()` | [02-orders.md](02-orders.md) |
| `/v2/orders:by_client_order_id` | GET | `client.get_order_by_client_id()` | [02-orders.md](02-orders.md) |

## Positions
| Endpoint | Method | SDK Method | Reference |
|----------|--------|------------|-----------|
| `/v2/positions` | GET | `client.get_all_positions()` | [03-positions.md](03-positions.md) |
| `/v2/positions` | DELETE | `client.close_all_positions()` | [03-positions.md](03-positions.md) |
| `/v2/positions/{symbol_or_asset_id}` | GET | `client.get_open_position()` | [03-positions.md](03-positions.md) |
| `/v2/positions/{symbol_or_asset_id}` | DELETE | `client.close_position()` | [03-positions.md](03-positions.md) |
| `/v2/positions/{id}/exercise` | POST | `client.exercise_options_position()` | [03-positions.md](03-positions.md) |
| `/v2/positions/{id}/do-not-exercise` | POST | raw `client.post()` | [03-positions.md](03-positions.md) |

## Assets
| Endpoint | Method | SDK Method | Reference |
|----------|--------|------------|-----------|
| `/v2/assets` | GET | `client.get_all_assets()` | [04-assets.md](04-assets.md) |
| `/v2/assets/{symbol_or_asset_id}` | GET | `client.get_asset()` | [04-assets.md](04-assets.md) |
| `/v2/options/contracts` | GET | `client.get_option_contracts()` | [04-assets.md](04-assets.md) |
| `/v2/options/contracts/{symbol_or_id}` | GET | `client.get_option_contract()` | [04-assets.md](04-assets.md) |

## Watchlists
| Endpoint | Method | SDK Method | Reference |
|----------|--------|------------|-----------|
| `/v2/watchlists` | GET | `client.get_watchlists()` | [05-watchlists.md](05-watchlists.md) |
| `/v2/watchlists` | POST | `client.create_watchlist()` | [05-watchlists.md](05-watchlists.md) |
| `/v2/watchlists/{id}` | GET | `client.get_watchlist_by_id()` | [05-watchlists.md](05-watchlists.md) |
| `/v2/watchlists/{id}` | PUT | `client.update_watchlist_by_id()` | [05-watchlists.md](05-watchlists.md) |
| `/v2/watchlists/{id}` | DELETE | `client.delete_watchlist_by_id()` | [05-watchlists.md](05-watchlists.md) |
| `/v2/watchlists/{id}/{symbol}` | DELETE | `client.remove_asset_from_watchlist_by_id()` | [05-watchlists.md](05-watchlists.md) |
| `/v2/watchlists/{id}` | POST | `client.add_asset_to_watchlist_by_id()` | [05-watchlists.md](05-watchlists.md) |

## Market Info
| Endpoint | Method | SDK Method | Reference |
|----------|--------|------------|-----------|
| `/v2/clock` | GET | `client.get_clock()` | [06-market-info.md](06-market-info.md) |
| `/v2/calendar` | GET | `client.get_calendar()` | [06-market-info.md](06-market-info.md) |
| `/v3/clock` | GET | raw `requests.get()` | [06-market-info.md](06-market-info.md) |
| `/v3/calendar/{market}` | GET | raw `requests.get()` | [06-market-info.md](06-market-info.md) |
| `/v2/account/portfolio/history` | GET | `client.get_portfolio_history()` | [06-market-info.md](06-market-info.md) |

## Account Activities
| Endpoint | Method | SDK Method | Reference |
|----------|--------|------------|-----------|
| `/v2/account/activities` | GET | raw `client.get()` | [07-account-activities.md](07-account-activities.md) |
| `/v2/account/activities/{type}` | GET | raw `client.get()` | [07-account-activities.md](07-account-activities.md) |

## Corporate Actions
| Endpoint | Method | SDK Method | Reference |
|----------|--------|------------|-----------|
| `/v2/corporate_actions/announcements` | GET | `client.get_corporate_announcements()` | [08-corporate-actions.md](08-corporate-actions.md) |
| `/v2/corporate_actions/announcements/{id}` | GET | `client.get_corporate_announcement_by_id()` | [08-corporate-actions.md](08-corporate-actions.md) |

## Crypto & Perpetual Wallets
| Endpoint | Method | SDK Method | Reference |
|----------|--------|------------|-----------|
| `/v2/wallets` | GET | raw `client.get()` | [09-crypto-wallets.md](09-crypto-wallets.md) |
| `/v2/wallets/transfers` | GET/POST | raw `client.get()/post()` | [09-crypto-wallets.md](09-crypto-wallets.md) |
| `/v2/wallets/whitelists` | GET/POST/DELETE | raw | [09-crypto-wallets.md](09-crypto-wallets.md) |
| `/v2/wallets/fees/estimate` | GET | raw `client.get()` | [09-crypto-wallets.md](09-crypto-wallets.md) |
| `/v2/perpetuals/wallets` | GET | raw `client.get()` | [09-crypto-wallets.md](09-crypto-wallets.md) |
| `/v2/perpetuals/wallets/transfers` | GET/POST | raw | [09-crypto-wallets.md](09-crypto-wallets.md) |
| `/v2/perpetuals/leverage` | GET/POST | raw | [09-crypto-wallets.md](09-crypto-wallets.md) |
| `/v2/perpetuals/account_vitals` | GET | raw `client.get()` | [09-crypto-wallets.md](09-crypto-wallets.md) |

## Error Codes & Troubleshooting

See [10-error-codes.md](10-error-codes.md) for:
- HTTP status codes and their meanings
- All API error codes (40010001, 40310000, 40310100, 40410000, 42210000)
- Protection mechanisms (PDT, DTMC, wash trade)
- Rate limits and common pitfalls
