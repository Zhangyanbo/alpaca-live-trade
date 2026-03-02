"""List open positions."""
import argparse
import os
import sys
from alpaca.trading.client import TradingClient
from alpaca.common.exceptions import APIError


def main():
    parser = argparse.ArgumentParser(description="List open positions")
    parser.add_argument("symbol", nargs="?", help="Get specific position")
    args = parser.parse_args()

    client = TradingClient(
        api_key=os.environ["APCA_API_KEY_ID"],
        secret_key=os.environ["APCA_API_SECRET_KEY"],
        paper=os.environ.get("APCA_PAPER", "true").lower() == "true",
    )

    if args.symbol:
        try:
            p = client.get_open_position(symbol_or_asset_id=args.symbol)
        except APIError as e:
            print(f"No open position for {args.symbol}")
            sys.exit(1)
        print(f"Symbol:     {p.symbol}")
        print(f"Qty:        {p.qty} ({p.side})")
        print(f"Avg Entry:  ${p.avg_entry_price}")
        print(f"Current:    ${p.current_price}")
        print(f"Market Val: ${p.market_value}")
        print(f"Cost Basis: ${p.cost_basis}")
        print(f"P/L:        ${p.unrealized_pl} ({p.unrealized_plpc})")
        print(f"Intraday:   ${p.unrealized_intraday_pl} ({p.unrealized_intraday_plpc})")
    else:
        positions = client.get_all_positions()
        if not positions:
            print("No open positions.")
            return
        for p in positions:
            print(f"{p.symbol:8s} {p.side:5s} qty={p.qty:>8s} "
                  f"entry=${p.avg_entry_price:>10s} "
                  f"current=${p.current_price:>10s} "
                  f"P/L=${p.unrealized_pl:>10s}")


if __name__ == "__main__":
    main()
