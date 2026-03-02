# Crypto & Perpetual Wallets

These endpoints manage crypto wallet operations. Most require raw API calls as they are not wrapped by the SDK.

**Note:** Crypto wallet endpoints may not be available on all account types.

## Crypto Wallets

### GET /v2/wallets — List Wallets
```python
wallets = client.get("/wallets")
```

### GET /v2/wallets/transfers — List Transfers
```python
transfers = client.get("/wallets/transfers")
```

### POST /v2/wallets/transfers — Create Transfer
```python
transfer = client.post("/wallets/transfers", data={
    "amount": "0.01",
    "address": "0x...",
    "asset": "ETH"
})
```

### GET /v2/wallets/transfers/{transfer_id} — Get Transfer
```python
transfer = client.get(f"/wallets/transfers/{transfer_id}")
```

### GET /v2/wallets/whitelists — List Whitelisted Addresses
```python
whitelist = client.get("/wallets/whitelists")
```

### POST /v2/wallets/whitelists — Add Whitelisted Address
```python
result = client.post("/wallets/whitelists", data={
    "address": "0x...",
    "asset": "ETH"
})
```

### DELETE /v2/wallets/whitelists/{id} — Remove Whitelisted Address
```python
client.delete(f"/wallets/whitelists/{address_id}")
```

### GET /v2/wallets/fees/estimate — Estimate Fees
```python
fees = client.get("/wallets/fees/estimate", data={
    "asset": "ETH",
    "from_address": "0x...",
    "to_address": "0x...",
    "amount": "0.01"
})
```

## Perpetual Wallets

### GET /v2/perpetuals/wallets — List Perpetual Wallets
```python
wallets = client.get("/perpetuals/wallets")
```

### GET /v2/perpetuals/wallets/transfers — List Transfers
```python
transfers = client.get("/perpetuals/wallets/transfers")
```

### POST /v2/perpetuals/wallets/transfers — Create Transfer
```python
transfer = client.post("/perpetuals/wallets/transfers", data={...})
```

### GET /v2/perpetuals/wallets/transfers/{id} — Get Transfer
```python
transfer = client.get(f"/perpetuals/wallets/transfers/{transfer_id}")
```

### GET /v2/perpetuals/leverage — Get Leverage
```python
leverage = client.get("/perpetuals/leverage")
```

### POST /v2/perpetuals/leverage — Set Leverage
```python
result = client.post("/perpetuals/leverage", data={"leverage": "5"})
```

### GET /v2/perpetuals/account_vitals — Account Vitals
```python
vitals = client.get("/perpetuals/account_vitals")
```
