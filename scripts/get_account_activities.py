"""Get account activities (fills, transfers, dividends, etc.)."""
import argparse
import os
from alpaca.trading.client import TradingClient


def main():
    parser = argparse.ArgumentParser(description="Get account activities")
    parser.add_argument("--type", dest="activity_type",
                        help="Activity type: FILL, TRANS, DIV, etc.")
    parser.add_argument("--limit", type=int, default=20, help="Max results")
    parser.add_argument("--date", help="Filter by date (YYYY-MM-DD)")
    args = parser.parse_args()

    client = TradingClient(
        api_key=os.environ["APCA_API_KEY_ID"],
        secret_key=os.environ["APCA_API_SECRET_KEY"],
        paper=os.environ.get("APCA_PAPER", "true").lower() == "true",
    )

    if args.activity_type:
        path = f"/account/activities/{args.activity_type}"
    else:
        path = "/account/activities"

    params = {"page_size": args.limit}
    if args.date:
        params["date"] = args.date

    activities = client.get(path, data=params)

    if not activities:
        print("No activities found.")
        return

    for a in activities:
        atype = a.get("activity_type", "?")
        symbol = a.get("symbol", "")
        side = a.get("side", "")
        qty = a.get("qty", "")
        price = a.get("price", "")
        net = a.get("net_amount", "")
        time = a.get("transaction_time", a.get("date", ""))
        desc = a.get("description", "")

        if atype == "FILL":
            print(f"[{atype}] {time} {symbol} {side} qty={qty} price={price}")
        else:
            print(f"[{atype}] {time} {symbol} net={net} {desc}")


if __name__ == "__main__":
    main()
