# Alpaca Live Trade (Agent Skill)

A [Cursor/Claude Agent Skill](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview) that lets an AI agent execute trading commands on [Alpaca](https://alpaca.markets) (stocks, options, crypto) via the **alpaca-py** SDK.

When you ask the agent to place trades, check positions, manage orders, or query account status, this skill is loaded on demand and provides instructions, endpoint references, and runnable scripts so the agent can carry out the operations correctly and safely.

## What This Skill Covers

- **Account**: Info, configurations, buying power, equity
- **Orders**: Market, limit, stop, bracket, multi-leg options (mleg)
- **Positions**: List, close, exercise options
- **Assets**: Lookup symbols and option contracts
- **Watchlists**: Create, update, delete, add/remove symbols
- **Market info**: Clock, calendar, portfolio history
- **Account activities**: Fills, dividends, transfers, etc.
- **Corporate actions**: Announcements
- **Crypto**: Wallets, transfers, perpetuals

## Safety Rules (Enforced by the Skill)

The skill instructs the agent to:

1. **No margin by default** — Use `non_marginable_buying_power` or `cash`; only use margin if you explicitly say "use margin".
2. **No naked options** — No naked calls/puts; covered calls and cash-secured puts are allowed.
3. **PDT awareness** — Warn and refuse same-day open+close when equity &lt; $30,000 or when day-trade count/PDT flag would be an issue, unless you explicitly confirm.

## Requirements

- Python 3.x
- [alpaca-py](https://github.com/alpacahq/alpaca-py) (use [uv](https://docs.astral.sh/uv/) or pip)
- Alpaca API keys (paper or live)

## Environment Setup

Set these before running any script or letting the agent trade:

```bash
export APCA_API_KEY_ID="your-key"
export APCA_API_SECRET_KEY="your-secret"
export APCA_PAPER="true"   # use "false" for live trading
```

**Never commit real API keys.** Use environment variables or a secrets manager.

## Project Layout

```
alpaca-live-trade/
├── SKILL.md              # Main skill instructions (metadata + body)
├── endpoints/            # API reference (account, orders, positions, …)
│   ├── 00-index.md
│   ├── 01-account.md
│   └── …
├── scripts/              # Executable Python scripts
│   ├── get_account.py
│   ├── submit_order.py
│   ├── get_orders.py
│   └── …
└── README.md
```

Scripts are intended to be run with:

```bash
uv run python scripts/<name>.py
```

(or `python scripts/<name>.py` if dependencies are installed in the current environment).

## Using This as a Cursor/Claude Skill

1. Put this folder in your Cursor/Claude skills directory (e.g. `~/.cursor/skills/alpaca-live-trade` or your project’s skills path).
2. The agent will use the skill when your request matches its description (e.g. “place a trade”, “check my Alpaca positions”, “cancel order”).
3. Ensure the environment variables above are set in the environment where the agent runs scripts.

## License

MIT — see [LICENSE](LICENSE).

## Disclaimer

This skill is for educational and automation convenience. Trading involves risk. The authors are not responsible for any trading losses. Use paper trading first and only use live trading if you understand the risks and Alpaca’s terms.
