# Doubler Contract Verification

Byte-for-byte verification of the **Doubler** pyramid scheme contract deployed on Ethereum mainnet.

| Field | Value |
|-------|-------|
| Contract | [`0xc1824278b767d9efb304c63128b1a92babc3fa4b`](https://etherscan.io/address/0xc1824278b767d9efb304c63128b1a92babc3fa4b) |
| Block | 1,028,387 |
| Date | February 19, 2016 |
| Deployer | `0x4f691fb14282fd40517511b47d33fed39dbd6a69` |
| Compiler | soljson v0.2.1+commit.91a6b35f |
| Optimizer | Enabled |
| Runtime | 1,137 bytes |
| Creation | 1,183 bytes |
| Match | Exact (runtime) |
| Balance | ~28 ETH (locked) |

## What Is This?

A classic Ponzi/pyramid scheme from early Ethereum. New participants call `enter()` with at least 1 ETH. The contract takes a 10% fee and queues them for a 2x payout, funded by later entrants. The owner can drain accumulated fees via `collectFees()`.

28 ETH remain locked in the contract -- participants who entered too late and will never be paid out.

## How It Works

1. `enter()` -- Join the pyramid with at least 1 ETH
2. First participant's deposit goes entirely to fees (no one above to pay)
3. Subsequent deposits: 10% to fees, 90% to balance
4. When balance exceeds 2x the next-in-line's deposit, they get paid 180% (2x minus their 10% fee)
5. `collectFees()` -- Owner withdraws accumulated fees
6. `setOwner(address)` -- Transfer ownership

## Verification

```bash
./verify.sh
```

Requires Node.js. Downloads the solc binary automatically.

## Source

The contract follows the well-documented "Doubler" pattern found across multiple early Ethereum deployments. Source reconstructed from on-chain bytecode analysis and cross-referenced with identical contracts in the [ethereum-ponzi](https://github.com/blockchain-unica/ethereum-ponzi) research corpus.

## Part Of

- [awesome-ethereum-proofs](https://github.com/cartoonitunes/awesome-ethereum-proofs) -- Registry of exact bytecode verifications
- [EthereumHistory.com](https://ethereumhistory.com) -- The archive of Ethereum contract history
