"""Get portfolio history."""
import argparse
import os
from alpaca.trading.client import TradingClient
from alpaca.trading.requests import GetPortfolioHistoryRequest


def main():
    parser = argparse.ArgumentParser(description="Get portfolio history")
    parser.add_argument("--period", default="1M",
                        help="Period: 1D, 1W, 1M, 3M, 1A, all")
    parser.add_argument("--timeframe", help="Timeframe: 1Min, 5Min, 15Min, 1H, 1D")
    args = parser.parse_args()

    client = TradingClient(
        api_key=os.environ["APCA_API_KEY_ID"],
        secret_key=os.environ["APCA_API_SECRET_KEY"],
        paper=os.environ.get("APCA_PAPER", "true").lower() == "true",
    )

    kwargs = {"period": args.period}
    if args.timeframe:
        kwargs["timeframe"] = args.timeframe

    history = client.get_portfolio_history(
        history_filter=GetPortfolioHistoryRequest(**kwargs))

    print(f"Base Value: ${history.base_value}")
    print(f"Timeframe:  {history.timeframe}")
    print(f"Data Points: {len(history.timestamp)}")
    print()

    from datetime import datetime
    for i, ts in enumerate(history.timestamp):
        dt = datetime.fromtimestamp(ts)
        equity = history.equity[i] if history.equity else "N/A"
        pl = history.profit_loss[i] if history.profit_loss else "N/A"
        pct = history.profit_loss_pct[i] if history.profit_loss_pct else "N/A"
        print(f"  {dt.strftime('%Y-%m-%d %H:%M')}  "
              f"equity=${equity}  P/L=${pl}  ({pct})")


if __name__ == "__main__":
    main()
