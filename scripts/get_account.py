"""Get account details: equity, cash, buying power, PDT status."""
import argparse
import os
from alpaca.trading.client import TradingClient


def main():
    parser = argparse.ArgumentParser(description="Get Alpaca account details")
    parser.add_argument("--raw", action="store_true", help="Print raw response")
    args = parser.parse_args()

    client = TradingClient(
        api_key=os.environ["APCA_API_KEY_ID"],
        secret_key=os.environ["APCA_API_SECRET_KEY"],
        paper=os.environ.get("APCA_PAPER", "true").lower() == "true",
    )

    account = client.get_account()

    if args.raw:
        print(account)
        return

    print(f"Account: {account.account_number} (ID: {account.id})")
    print(f"Status:  {account.status}")
    print(f"Equity:  ${account.equity}")
    print(f"Cash:    ${account.cash}")
    print(f"Buying Power:     ${account.buying_power}")
    print(f"Non-Margin BP:    ${account.non_marginable_buying_power}")
    print(f"RegT BP:          ${account.regt_buying_power}")
    print(f"DT BP:            ${account.daytrading_buying_power}")
    print(f"Options BP:       ${account.options_buying_power}")
    print(f"Long MV:          ${account.long_market_value}")
    print(f"Short MV:         ${account.short_market_value}")
    print(f"Multiplier:       {account.multiplier}")
    print(f"PDT Flag:         {account.pattern_day_trader}")
    print(f"Day Trades (5d):  {account.daytrade_count}")
    print(f"Shorting:         {account.shorting_enabled}")
    print(f"Options Level:    {account.options_trading_level}")


if __name__ == "__main__":
    main()
