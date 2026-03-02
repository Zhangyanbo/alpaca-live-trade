# Account & Configuration

## GET /v2/account — Get Account

SDK: `client.get_account() -> TradeAccount`

No parameters required.

### Response Fields (TradeAccount)
| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Account ID |
| `account_number` | str | Account number |
| `status` | AccountStatus | ACTIVE, ONBOARDING, etc. |
| `currency` | str | USD |
| `cash` | str | Cash balance |
| `buying_power` | str | Total buying power (includes margin) |
| `non_marginable_buying_power` | str | Cash-only buying power |
| `regt_buying_power` | str | Reg T buying power |
| `daytrading_buying_power` | str | Day trading buying power |
| `options_buying_power` | str | Options buying power |
| `equity` | str | Cash + long_market_value + short_market_value |
| `last_equity` | str | Previous close equity |
| `long_market_value` | str | Long positions value |
| `short_market_value` | str | Short positions value |
| `initial_margin` | str | Initial margin requirement |
| `maintenance_margin` | str | Maintenance margin |
| `pattern_day_trader` | bool | PDT flag |
| `daytrade_count` | int | Day trades in last 5 days |
| `multiplier` | str | 1, 2, or 4 |
| `shorting_enabled` | bool | Can short |
| `trading_blocked` | bool | Trading blocked |
| `transfers_blocked` | bool | Transfers blocked |
| `account_blocked` | bool | Account blocked |
| `options_approved_level` | int | 0-3 |
| `options_trading_level` | int | 0-3 (effective) |
| `created_at` | datetime | Account creation time |
| `accrued_fees` | str | Fees collected |
| `pending_transfer_in` | str | Pending incoming transfers |

### Example
```python
account = client.get_account()
print(f"Equity: ${account.equity}")
print(f"Cash: ${account.cash}")
print(f"PDT: {account.pattern_day_trader}")
print(f"Day trades: {account.daytrade_count}")
```

## GET /v2/account/configurations — Get Config

SDK: `client.get_account_configurations() -> AccountConfiguration`

### Response Fields (AccountConfiguration)
| Field | Type | Description |
|-------|------|-------------|
| `dtbp_check` | DTBPCheck | Day trading buying power check: BOTH, ENTRY, EXIT |
| `trade_confirm_email` | TradeConfirmationEmail | ALL, NONE |
| `suspend_trade` | bool | Suspend trading |
| `no_shorting` | bool | Disable shorting |
| `fractional_trading` | bool | Allow fractional shares |
| `max_margin_multiplier` | str | "1" or "2" |
| `max_options_trading_level` | int | 0-3 |
| `pdt_check` | PDTCheck | ENTRY, EXIT, BOTH |

### Example
```python
config = client.get_account_configurations()
print(f"PDT check: {config.pdt_check}")
print(f"Max margin: {config.max_margin_multiplier}")
```

## PATCH /v2/account/configurations — Update Config

SDK: `client.set_account_configurations(AccountConfiguration) -> AccountConfiguration`

Pass an `AccountConfiguration` object with only the fields you want to change.

### Example
```python
from alpaca.trading.models import AccountConfiguration
from alpaca.trading.enums import DTBPCheck

config = AccountConfiguration(
    dtbp_check=DTBPCheck.ENTRY,
    no_shorting=True,
    max_margin_multiplier="1",
)
result = client.set_account_configurations(config)
```
