"""Submit an order (market, limit, stop, stop_limit, trailing_stop)."""
import argparse
import os
import sys
from alpaca.trading.client import TradingClient
from alpaca.trading.requests import (
    MarketOrderRequest, LimitOrderRequest,
    StopOrderRequest, StopLimitOrderRequest,
    TrailingStopOrderRequest,
)
from alpaca.trading.enums import OrderSide, TimeInForce, OrderClass
from alpaca.common.exceptions import APIError


def main():
    parser = argparse.ArgumentParser(description="Submit an order")
    parser.add_argument("symbol", help="Symbol to trade")
    parser.add_argument("side", choices=["buy", "sell"])
    parser.add_argument("--qty", type=float, help="Quantity")
    parser.add_argument("--notional", type=float, help="Dollar amount")
    parser.add_argument("--type", dest="order_type", default="market",
                        choices=["market", "limit", "stop", "stop_limit", "trailing_stop"])
    parser.add_argument("--tif", default="day",
                        choices=["day", "gtc", "opg", "cls", "ioc", "fok"])
    parser.add_argument("--limit-price", type=float)
    parser.add_argument("--stop-price", type=float)
    parser.add_argument("--trail-price", type=float)
    parser.add_argument("--trail-percent", type=float)
    parser.add_argument("--extended-hours", action="store_true")
    parser.add_argument("--order-class", choices=["simple", "bracket", "oco", "oto"])
    parser.add_argument("--take-profit", type=float, help="Take profit limit price")
    parser.add_argument("--stop-loss-price", type=float, help="Stop loss stop price")
    parser.add_argument("--stop-loss-limit", type=float, help="Stop loss limit price")
    parser.add_argument("--client-order-id", help="Custom order ID")
    args = parser.parse_args()

    if not args.qty and not args.notional:
        parser.error("Either --qty or --notional is required")

    client = TradingClient(
        api_key=os.environ["APCA_API_KEY_ID"],
        secret_key=os.environ["APCA_API_SECRET_KEY"],
        paper=os.environ.get("APCA_PAPER", "true").lower() == "true",
    )

    side = OrderSide.BUY if args.side == "buy" else OrderSide.SELL
    tif = TimeInForce(args.tif)

    common = {"symbol": args.symbol, "side": side, "time_in_force": tif}
    if args.qty:
        common["qty"] = args.qty
    if args.notional:
        common["notional"] = args.notional
    if args.extended_hours:
        common["extended_hours"] = True
    if args.client_order_id:
        common["client_order_id"] = args.client_order_id

    if args.order_class:
        common["order_class"] = OrderClass(args.order_class)
    if args.take_profit:
        common["take_profit"] = {"limit_price": args.take_profit}
    if args.stop_loss_price:
        sl = {"stop_price": args.stop_loss_price}
        if args.stop_loss_limit:
            sl["limit_price"] = args.stop_loss_limit
        common["stop_loss"] = sl

    if args.order_type == "market":
        req = MarketOrderRequest(**common)
    elif args.order_type == "limit":
        req = LimitOrderRequest(limit_price=args.limit_price, **common)
    elif args.order_type == "stop":
        req = StopOrderRequest(stop_price=args.stop_price, **common)
    elif args.order_type == "stop_limit":
        req = StopLimitOrderRequest(
            stop_price=args.stop_price, limit_price=args.limit_price, **common)
    elif args.order_type == "trailing_stop":
        ts_kwargs = {}
        if args.trail_price:
            ts_kwargs["trail_price"] = args.trail_price
        if args.trail_percent:
            ts_kwargs["trail_percent"] = args.trail_percent
        req = TrailingStopOrderRequest(**ts_kwargs, **common)

    try:
        order = client.submit_order(order_data=req)
    except APIError as e:
        print(f"Order rejected: {e}")
        sys.exit(1)

    print(f"Order ID:     {order.id}")
    print(f"Status:       {order.status}")
    print(f"Symbol:       {order.symbol}")
    print(f"Side:         {order.side}")
    print(f"Type:         {order.type}")
    print(f"Qty:          {order.qty}")
    print(f"Limit Price:  {order.limit_price}")
    print(f"Stop Price:   {order.stop_price}")
    print(f"TIF:          {order.time_in_force}")
    print(f"Order Class:  {order.order_class}")


if __name__ == "__main__":
    main()
