"""Close one or all positions."""
import argparse
import os
import sys
from alpaca.trading.client import TradingClient
from alpaca.trading.requests import ClosePositionRequest
from alpaca.common.exceptions import APIError


def main():
    parser = argparse.ArgumentParser(description="Close positions")
    parser.add_argument("symbol", nargs="?", help="Symbol to close")
    parser.add_argument("--all", action="store_true", help="Close all positions")
    parser.add_argument("--qty", help="Number of shares to close")
    parser.add_argument("--percentage", help="Percentage to close (0-100)")
    parser.add_argument("--cancel-orders", action="store_true",
                        help="Cancel open orders before closing all")
    args = parser.parse_args()

    client = TradingClient(
        api_key=os.environ["APCA_API_KEY_ID"],
        secret_key=os.environ["APCA_API_SECRET_KEY"],
        paper=os.environ.get("APCA_PAPER", "true").lower() == "true",
    )

    if args.all:
        results = client.close_all_positions(cancel_orders=args.cancel_orders)
        print(f"Closing {len(results)} positions")
        for r in results:
            print(f"  {r}")
    elif args.symbol:
        close_opts = None
        if args.qty:
            close_opts = ClosePositionRequest(qty=args.qty)
        elif args.percentage:
            close_opts = ClosePositionRequest(percentage=args.percentage)

        try:
            order = client.close_position(args.symbol, close_options=close_opts)
            print(f"Close order: {order.id} status={order.status}")
        except APIError as e:
            print(f"Failed to close {args.symbol}: {e}")
            sys.exit(1)
    else:
        print("Specify a symbol or use --all")


if __name__ == "__main__":
    main()
