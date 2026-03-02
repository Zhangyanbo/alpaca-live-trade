"""Query option contracts (option chain)."""
import argparse
import os
from datetime import date
from alpaca.trading.client import TradingClient
from alpaca.trading.requests import GetOptionContractsRequest
from alpaca.trading.enums import AssetStatus


def main():
    parser = argparse.ArgumentParser(description="Query option contracts")
    parser.add_argument("underlying", help="Underlying symbol (e.g. AAPL)")
    parser.add_argument("--type", dest="contract_type", choices=["call", "put"])
    parser.add_argument("--exp-gte", type=date.fromisoformat,
                        help="Expiration >= date (YYYY-MM-DD)")
    parser.add_argument("--exp-lte", type=date.fromisoformat,
                        help="Expiration <= date (YYYY-MM-DD)")
    parser.add_argument("--exp", type=date.fromisoformat,
                        help="Exact expiration date (YYYY-MM-DD)")
    parser.add_argument("--strike-gte", type=float, help="Strike >= value")
    parser.add_argument("--strike-lte", type=float, help="Strike <= value")
    parser.add_argument("--limit", type=int, default=50)
    args = parser.parse_args()

    client = TradingClient(
        api_key=os.environ["APCA_API_KEY_ID"],
        secret_key=os.environ["APCA_API_SECRET_KEY"],
        paper=os.environ.get("APCA_PAPER", "true").lower() == "true",
    )

    kwargs = {
        "underlying_symbols": [args.underlying],
        "status": AssetStatus.ACTIVE,
    }
    if args.contract_type:
        from alpaca.trading.enums import ContractType
        kwargs["type"] = ContractType(args.contract_type)
    if args.exp_gte:
        kwargs["expiration_date_gte"] = args.exp_gte
    if args.exp_lte:
        kwargs["expiration_date_lte"] = args.exp_lte
    if args.exp:
        kwargs["expiration_date"] = args.exp
    if args.strike_gte:
        kwargs["strike_price_gte"] = str(args.strike_gte)
    if args.strike_lte:
        kwargs["strike_price_lte"] = str(args.strike_lte)
    if args.limit:
        kwargs["limit"] = args.limit

    result = client.get_option_contracts(
        request=GetOptionContractsRequest(**kwargs))

    contracts = result.option_contracts or []
    print(f"Found {len(contracts)} contracts")
    for c in contracts:
        print(f"  {c.symbol:25s} {c.type:4s} strike={c.strike_price:>8.2f} "
              f"exp={c.expiration_date} OI={c.open_interest}")


if __name__ == "__main__":
    main()
