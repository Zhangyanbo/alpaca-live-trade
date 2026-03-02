"""Replace (modify) an existing order."""
import argparse
import os
from alpaca.trading.client import TradingClient
from alpaca.trading.requests import ReplaceOrderRequest
from alpaca.trading.enums import TimeInForce


def main():
    parser = argparse.ArgumentParser(description="Replace an order")
    parser.add_argument("order_id", help="Order ID to replace")
    parser.add_argument("--qty", type=int)
    parser.add_argument("--limit-price", type=float)
    parser.add_argument("--stop-price", type=float)
    parser.add_argument("--trail", type=float)
    parser.add_argument("--tif", choices=["day", "gtc", "opg", "cls", "ioc", "fok"])
    parser.add_argument("--client-order-id")
    args = parser.parse_args()

    client = TradingClient(
        api_key=os.environ["APCA_API_KEY_ID"],
        secret_key=os.environ["APCA_API_SECRET_KEY"],
        paper=os.environ.get("APCA_PAPER", "true").lower() == "true",
    )

    kwargs = {}
    if args.qty is not None:
        kwargs["qty"] = args.qty
    if args.limit_price is not None:
        kwargs["limit_price"] = args.limit_price
    if args.stop_price is not None:
        kwargs["stop_price"] = args.stop_price
    if args.trail is not None:
        kwargs["trail"] = args.trail
    if args.tif:
        kwargs["time_in_force"] = TimeInForce(args.tif)
    if args.client_order_id:
        kwargs["client_order_id"] = args.client_order_id

    if not kwargs:
        print("No changes specified. Use --help for options.")
        return

    order = client.replace_order_by_id(
        order_id=args.order_id,
        order_data=ReplaceOrderRequest(**kwargs),
    )
    print(f"Replaced order: {order.id}")
    print(f"  Status: {order.status}")
    print(f"  Qty: {order.qty}")
    print(f"  Limit: {order.limit_price}")
    print(f"  Stop: {order.stop_price}")


if __name__ == "__main__":
    main()
