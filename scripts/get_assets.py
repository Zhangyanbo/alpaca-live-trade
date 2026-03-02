"""Look up asset details."""
import argparse
import os
from alpaca.trading.client import TradingClient
from alpaca.trading.requests import GetAssetsRequest
from alpaca.trading.enums import AssetStatus, AssetClass


def main():
    parser = argparse.ArgumentParser(description="Look up assets")
    parser.add_argument("symbol", nargs="?", help="Specific symbol to look up")
    parser.add_argument("--asset-class", choices=["us_equity", "crypto"],
                        help="Filter by asset class")
    parser.add_argument("--status", choices=["active", "inactive"], default="active")
    parser.add_argument("--limit", type=int, default=20)
    args = parser.parse_args()

    client = TradingClient(
        api_key=os.environ["APCA_API_KEY_ID"],
        secret_key=os.environ["APCA_API_SECRET_KEY"],
        paper=os.environ.get("APCA_PAPER", "true").lower() == "true",
    )

    if args.symbol:
        asset = client.get_asset(symbol_or_asset_id=args.symbol)
        print(f"Symbol:       {asset.symbol}")
        print(f"Name:         {asset.name}")
        print(f"Class:        {asset.asset_class}")
        print(f"Exchange:     {asset.exchange}")
        print(f"Status:       {asset.status}")
        print(f"Tradable:     {asset.tradable}")
        print(f"Marginable:   {asset.marginable}")
        print(f"Shortable:    {asset.shortable}")
        print(f"Fractionable: {asset.fractionable}")
    else:
        kwargs = {"status": AssetStatus(args.status.upper())}
        if args.asset_class:
            kwargs["asset_class"] = AssetClass(args.asset_class)
        assets = client.get_all_assets(filter=GetAssetsRequest(**kwargs))
        for a in assets[:args.limit]:
            print(f"{a.symbol:10s} {a.name[:40]:40s} {a.exchange}")


if __name__ == "__main__":
    main()
