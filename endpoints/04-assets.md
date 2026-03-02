# Assets & Option Contracts

## GET /v2/assets — List Assets

SDK: `client.get_all_assets(filter=GetAssetsRequest) -> List[Asset]`

### Parameters (GetAssetsRequest)
| Field | Type | Description |
|-------|------|-------------|
| `status` | AssetStatus | ACTIVE or INACTIVE |
| `asset_class` | AssetClass | US_EQUITY, US_OPTION, CRYPTO |
| `exchange` | AssetExchange | Filter by exchange |

### Asset Fields
| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Asset ID |
| `asset_class` | AssetClass | us_equity, crypto |
| `exchange` | AssetExchange | AMEX, ARCA, BATS, NYSE, NASDAQ, OTC |
| `symbol` | str | Ticker symbol |
| `name` | str | Company name |
| `status` | AssetStatus | active or inactive |
| `tradable` | bool | Tradable on Alpaca |
| `marginable` | bool | Can use margin |
| `shortable` | bool | Can short |
| `fractionable` | bool | Supports fractional shares |
| `maintenance_margin_requirement` | float | Margin requirement |
| `easy_to_borrow` | bool | Easy to borrow for shorting |

### Example
```python
from alpaca.trading.requests import GetAssetsRequest
from alpaca.trading.enums import AssetStatus, AssetClass

# All active US equities
assets = client.get_all_assets(filter=GetAssetsRequest(
    status=AssetStatus.ACTIVE, asset_class=AssetClass.US_EQUITY))

# Crypto assets
crypto = client.get_all_assets(filter=GetAssetsRequest(
    asset_class=AssetClass.CRYPTO))
```

## GET /v2/assets/{symbol_or_asset_id} — Get Single Asset

SDK: `client.get_asset(symbol_or_asset_id) -> Asset`

```python
asset = client.get_asset("AAPL")
btc = client.get_asset("BTC/USD")
```

## GET /v2/options/contracts — List Option Contracts

SDK: `client.get_option_contracts(request=GetOptionContractsRequest) -> OptionContractsResponse`

### Parameters (GetOptionContractsRequest)
| Field | Type | Description |
|-------|------|-------------|
| `underlying_symbols` | List[str] | Filter by underlying |
| `status` | AssetStatus | ACTIVE |
| `expiration_date` | date | Exact expiration date |
| `expiration_date_gte` | date | Expiration >= date |
| `expiration_date_lte` | date | Expiration <= date |
| `root_symbol` | str | Root symbol |
| `type` | ContractType | CALL or PUT |
| `style` | ExerciseStyle | AMERICAN or EUROPEAN |
| `strike_price_gte` | float | Strike >= value |
| `strike_price_lte` | float | Strike <= value |
| `page_token` | str | Pagination token |
| `limit` | int | Max results |

### OptionContract Fields
| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Contract ID |
| `symbol` | str | OCC symbol (e.g. AAPL260320C00200000) |
| `name` | str | Description |
| `status` | str | active/inactive |
| `tradable` | bool | Tradable |
| `type` | ContractType | call or put |
| `strike_price` | float | Strike price |
| `expiration_date` | date | Expiration |
| `style` | ExerciseStyle | american/european |
| `underlying_symbol` | str | Underlying ticker |
| `underlying_asset_id` | UUID | Underlying asset ID |
| `open_interest` | str | Open interest |
| `close_price` | str | Previous close |

### Example
```python
from alpaca.trading.requests import GetOptionContractsRequest
from alpaca.trading.enums import AssetStatus, ContractType
from datetime import date

opts = client.get_option_contracts(request=GetOptionContractsRequest(
    underlying_symbols=["AAPL"],
    status=AssetStatus.ACTIVE,
    type=ContractType.CALL,
    expiration_date_gte=date.today(),
    strike_price_gte=200.0,
    strike_price_lte=300.0,
))
for c in opts.option_contracts[:5]:
    print(f"{c.symbol} strike={c.strike_price} exp={c.expiration_date}")
```

## GET /v2/options/contracts/{symbol_or_id} — Single Contract

SDK: `client.get_option_contract(symbol_or_id) -> OptionContract`

## OCC Symbol Format

Option symbols follow the OCC format:
`{underlying}{YYMMDD}{C/P}{strike*1000 padded to 8 digits}`

Example: `AAPL260320C00200000` = AAPL Call, expires 2026-03-20, strike $200
