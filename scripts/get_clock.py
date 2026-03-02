"""Get market clock status."""
import os
from alpaca.trading.client import TradingClient


def main():
    client = TradingClient(
        api_key=os.environ["APCA_API_KEY_ID"],
        secret_key=os.environ["APCA_API_SECRET_KEY"],
        paper=os.environ.get("APCA_PAPER", "true").lower() == "true",
    )

    clock = client.get_clock()
    print(f"Timestamp:  {clock.timestamp}")
    print(f"Is Open:    {clock.is_open}")
    print(f"Next Open:  {clock.next_open}")
    print(f"Next Close: {clock.next_close}")


if __name__ == "__main__":
    main()
