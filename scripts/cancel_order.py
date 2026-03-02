"""Cancel one or all orders."""
import argparse
import os
from alpaca.trading.client import TradingClient


def main():
    parser = argparse.ArgumentParser(description="Cancel orders")
    parser.add_argument("order_id", nargs="?", help="Order ID to cancel (omit for all)")
    parser.add_argument("--all", action="store_true", help="Cancel all open orders")
    args = parser.parse_args()

    client = TradingClient(
        api_key=os.environ["APCA_API_KEY_ID"],
        secret_key=os.environ["APCA_API_SECRET_KEY"],
        paper=os.environ.get("APCA_PAPER", "true").lower() == "true",
    )

    if args.all:
        result = client.cancel_orders()
        print(f"Cancelled {len(result)} orders")
        for r in result:
            print(f"  {r}")
    elif args.order_id:
        client.cancel_order_by_id(order_id=args.order_id)
        print(f"Cancelled order {args.order_id}")
    else:
        print("Specify an order_id or use --all")


if __name__ == "__main__":
    main()
