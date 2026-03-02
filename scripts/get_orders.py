"""List orders with optional filters."""
import argparse
import os
from alpaca.trading.client import TradingClient
from alpaca.trading.requests import GetOrdersRequest
from alpaca.trading.enums import QueryOrderStatus, OrderSide


def main():
    parser = argparse.ArgumentParser(description="List orders")
    parser.add_argument("--status", default="open", choices=["open", "closed", "all"])
    parser.add_argument("--limit", type=int, default=50)
    parser.add_argument("--side", choices=["buy", "sell"])
    parser.add_argument("--symbols", nargs="+", help="Filter by symbols")
    args = parser.parse_args()

    client = TradingClient(
        api_key=os.environ["APCA_API_KEY_ID"],
        secret_key=os.environ["APCA_API_SECRET_KEY"],
        paper=os.environ.get("APCA_PAPER", "true").lower() == "true",
    )

    status_map = {
        "open": QueryOrderStatus.OPEN,
        "closed": QueryOrderStatus.CLOSED,
        "all": QueryOrderStatus.ALL,
    }

    kwargs = {"status": status_map[args.status], "limit": args.limit}
    if args.side:
        kwargs["side"] = OrderSide.BUY if args.side == "buy" else OrderSide.SELL
    if args.symbols:
        kwargs["symbols"] = args.symbols

    orders = client.get_orders(filter=GetOrdersRequest(**kwargs))

    if not orders:
        print("No orders found.")
        return

    for o in orders:
        print(f"[{o.status}] {o.symbol} {o.side} {o.type} "
              f"qty={o.qty} filled={o.filled_qty} "
              f"limit={o.limit_price} stop={o.stop_price} "
              f"id={o.id}")


if __name__ == "__main__":
    main()
