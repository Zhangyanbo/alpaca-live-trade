"""Get corporate action announcements."""
import argparse
import os
from datetime import date, timedelta
from alpaca.trading.client import TradingClient
from alpaca.trading.requests import GetCorporateAnnouncementsRequest
from alpaca.trading.enums import CorporateActionType


def main():
    parser = argparse.ArgumentParser(description="Get corporate action announcements")
    parser.add_argument("--type", dest="ca_type", nargs="+", default=["dividend"],
                        choices=["dividend", "merger", "spinoff", "split"],
                        help="Corporate action types")
    parser.add_argument("--since", type=date.fromisoformat,
                        default=date.today() - timedelta(days=30))
    parser.add_argument("--until", type=date.fromisoformat, default=date.today())
    parser.add_argument("--symbol", help="Filter by symbol")
    parser.add_argument("--limit", type=int, default=20)
    args = parser.parse_args()

    client = TradingClient(
        api_key=os.environ["APCA_API_KEY_ID"],
        secret_key=os.environ["APCA_API_SECRET_KEY"],
        paper=os.environ.get("APCA_PAPER", "true").lower() == "true",
    )

    type_map = {
        "dividend": CorporateActionType.DIVIDEND,
        "merger": CorporateActionType.MERGER,
        "spinoff": CorporateActionType.SPINOFF,
        "split": CorporateActionType.SPLIT,
    }
    ca_types = [type_map[t] for t in args.ca_type]

    kwargs = {"ca_types": ca_types, "since": args.since, "until": args.until}
    if args.symbol:
        kwargs["symbol"] = args.symbol

    announcements = client.get_corporate_announcements(
        filter=GetCorporateAnnouncementsRequest(**kwargs))

    for a in announcements[:args.limit]:
        print(f"[{a.ca_type}] {a.initiating_symbol or '?'} "
              f"ex={a.ex_date} pay={a.payable_date} "
              f"cash={a.cash} id={a.id}")


if __name__ == "__main__":
    main()
