"""Get market calendar for a date range."""
import argparse
import os
from datetime import date, timedelta
from alpaca.trading.client import TradingClient
from alpaca.trading.requests import GetCalendarRequest


def main():
    parser = argparse.ArgumentParser(description="Get market calendar")
    parser.add_argument("--start", type=date.fromisoformat, default=date.today(),
                        help="Start date (YYYY-MM-DD)")
    parser.add_argument("--end", type=date.fromisoformat,
                        default=date.today() + timedelta(days=30),
                        help="End date (YYYY-MM-DD)")
    args = parser.parse_args()

    client = TradingClient(
        api_key=os.environ["APCA_API_KEY_ID"],
        secret_key=os.environ["APCA_API_SECRET_KEY"],
        paper=os.environ.get("APCA_PAPER", "true").lower() == "true",
    )

    calendar = client.get_calendar(
        filters=GetCalendarRequest(start=args.start, end=args.end))

    for day in calendar:
        print(f"{day.date}  open={day.open}  close={day.close}")


if __name__ == "__main__":
    main()
