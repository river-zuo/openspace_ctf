# 添加代码、新合约后的执行日志
```
❯ forge test -vv
[⠊] Compiling...
No files changed, compilation skipped

Ran 1 test for test/Vault.t.sol:VaultExploiter
[PASS] testExploit() (gas: 618835)
Logs:
  before crack 110000000000000000
  after crack 0
  withdraw_after_crack balance 1100000000000000000

Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 651.29µs (243.79µs CPU time)

Ran 1 test suite in 122.69ms (651.29µs CPU time): 1 tests passed, 0 failed, 0 skipped (1 total tests)
```
## Try to Hack Vault 

Read the smart contract `Vault.sol`, try to steal all eth from the vault.

You can write a hacker contract and add some code to pass the `forge test` .

### Tips 
you need understand following knowledge points:
1. reentrance 
2. ABI encoding
3. delegatecall
 

### Anvil

```shell
$ anvil
```

### Deploy

```shell
forge script script/Vault.s.sol --rpc-url http://127.0.0.1:8545 --broadcast
```

## test

```
forge test -vvv
```