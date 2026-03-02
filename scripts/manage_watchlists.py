"""Create, update, delete, and list watchlists."""
import argparse
import os
from alpaca.trading.client import TradingClient
from alpaca.trading.requests import CreateWatchlistRequest, UpdateWatchlistRequest


def main():
    parser = argparse.ArgumentParser(description="Manage watchlists")
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("list", help="List all watchlists")

    create = sub.add_parser("create", help="Create a watchlist")
    create.add_argument("name", help="Watchlist name")
    create.add_argument("symbols", nargs="+", help="Symbols to add")

    get = sub.add_parser("get", help="Get watchlist by ID")
    get.add_argument("watchlist_id")

    update = sub.add_parser("update", help="Update a watchlist")
    update.add_argument("watchlist_id")
    update.add_argument("--name", help="New name")
    update.add_argument("--symbols", nargs="+", help="New symbol list")

    add = sub.add_parser("add", help="Add symbol to watchlist")
    add.add_argument("watchlist_id")
    add.add_argument("symbol")

    remove = sub.add_parser("remove", help="Remove symbol from watchlist")
    remove.add_argument("watchlist_id")
    remove.add_argument("symbol")

    delete = sub.add_parser("delete", help="Delete a watchlist")
    delete.add_argument("watchlist_id")

    args = parser.parse_args()

    client = TradingClient(
        api_key=os.environ["APCA_API_KEY_ID"],
        secret_key=os.environ["APCA_API_SECRET_KEY"],
        paper=os.environ.get("APCA_PAPER", "true").lower() == "true",
    )

    if args.command == "list":
        for wl in client.get_watchlists():
            asset_syms = [a.symbol for a in (wl.assets or [])]
            print(f"{wl.id}  {wl.name:20s}  {asset_syms}")

    elif args.command == "create":
        wl = client.create_watchlist(CreateWatchlistRequest(
            name=args.name, symbols=args.symbols))
        print(f"Created: {wl.id} '{wl.name}'")

    elif args.command == "get":
        wl = client.get_watchlist_by_id(args.watchlist_id)
        print(f"ID:   {wl.id}")
        print(f"Name: {wl.name}")
        for a in wl.assets or []:
            print(f"  {a.symbol}: {a.name}")

    elif args.command == "update":
        kwargs = {}
        if args.name:
            kwargs["name"] = args.name
        if args.symbols:
            kwargs["symbols"] = args.symbols
        wl = client.update_watchlist_by_id(
            args.watchlist_id, UpdateWatchlistRequest(**kwargs))
        print(f"Updated: {wl.name}")

    elif args.command == "add":
        wl = client.add_asset_to_watchlist_by_id(args.watchlist_id, args.symbol)
        print(f"Added {args.symbol} to {wl.name}")

    elif args.command == "remove":
        wl = client.remove_asset_from_watchlist_by_id(args.watchlist_id, args.symbol)
        print(f"Removed {args.symbol} from {wl.name}")

    elif args.command == "delete":
        client.delete_watchlist_by_id(args.watchlist_id)
        print(f"Deleted watchlist {args.watchlist_id}")


if __name__ == "__main__":
    main()
