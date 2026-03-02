"""Get account configuration."""
import os
from alpaca.trading.client import TradingClient


def main():
    client = TradingClient(
        api_key=os.environ["APCA_API_KEY_ID"],
        secret_key=os.environ["APCA_API_SECRET_KEY"],
        paper=os.environ.get("APCA_PAPER", "true").lower() == "true",
    )

    config = client.get_account_configurations()
    print(f"DTBP Check:         {config.dtbp_check}")
    print(f"Trade Confirm Email: {config.trade_confirm_email}")
    print(f"Suspend Trade:      {config.suspend_trade}")
    print(f"No Shorting:        {config.no_shorting}")
    print(f"Fractional Trading: {config.fractional_trading}")
    print(f"Max Margin Multi:   {config.max_margin_multiplier}")
    print(f"Max Options Level:  {config.max_options_trading_level}")
    print(f"PDT Check:          {config.pdt_check}")


if __name__ == "__main__":
    main()
