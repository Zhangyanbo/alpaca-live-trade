"""Update account configuration via raw PATCH (partial update supported)."""
import argparse
import os
import sys
import requests


def main():
    parser = argparse.ArgumentParser(description="Update account configuration")
    parser.add_argument("--dtbp-check", choices=["both", "entry", "exit"])
    parser.add_argument("--trade-confirm-email", choices=["all", "none"])
    parser.add_argument("--suspend-trade", type=lambda x: x.lower() == "true")
    parser.add_argument("--no-shorting", type=lambda x: x.lower() == "true")
    parser.add_argument("--fractional-trading", type=lambda x: x.lower() == "true")
    parser.add_argument("--max-margin-multiplier", choices=["1", "2", "4"])
    parser.add_argument("--max-options-level", type=int, choices=[0, 1, 2, 3])
    parser.add_argument("--pdt-check", choices=["both", "entry", "exit"])
    args = parser.parse_args()

    api_key = os.environ["APCA_API_KEY_ID"]
    secret_key = os.environ["APCA_API_SECRET_KEY"]
    is_paper = os.environ.get("APCA_PAPER", "true").lower() == "true"
    base_url = "https://paper-api.alpaca.markets" if is_paper else "https://api.alpaca.markets"

    payload = {}
    if args.dtbp_check:
        payload["dtbp_check"] = args.dtbp_check
    if args.trade_confirm_email:
        payload["trade_confirm_email"] = args.trade_confirm_email
    if args.suspend_trade is not None:
        payload["suspend_trade"] = args.suspend_trade
    if args.no_shorting is not None:
        payload["no_shorting"] = args.no_shorting
    if args.fractional_trading is not None:
        payload["fractional_trading"] = args.fractional_trading
    if args.max_margin_multiplier:
        payload["max_margin_multiplier"] = args.max_margin_multiplier
    if args.max_options_level is not None:
        payload["max_options_trading_level"] = args.max_options_level
    if args.pdt_check:
        payload["pdt_check"] = args.pdt_check

    if not payload:
        print("No configuration changes specified. Use --help for options.")
        return

    resp = requests.patch(
        f"{base_url}/v2/account/configurations",
        headers={
            "APCA-API-KEY-ID": api_key,
            "APCA-API-SECRET-KEY": secret_key,
            "content-type": "application/json",
        },
        json=payload,
    )

    if resp.status_code == 200:
        data = resp.json()
        print("Configuration updated successfully:")
        for k, v in data.items():
            print(f"  {k}: {v}")
    else:
        print(f"Failed ({resp.status_code}): {resp.text}")
        sys.exit(1)


if __name__ == "__main__":
    main()
