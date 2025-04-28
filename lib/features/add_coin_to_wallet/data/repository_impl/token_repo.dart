import 'package:web3dart/web3dart.dart';

import '../../../wallet/domain/entities/account_entity.dart';
import '../../domain/entities/token_balance.dart';
import '../../domain/entities/token_entities.dart';
import '../../domain/repo/token_repo.dart';
import '../data_source/token_local_data_source.dart';

class TokenRepoImpl implements TokenRepo {
  final TokenLocalDataSource localDataSource;
  final Web3Client? web3Client;

  TokenRepoImpl({
    required this.localDataSource,
    this.web3Client,
  });

  @override
  Future<void> addTokenToAccount({
    required AccountEntity account,
    required String contractAddress,
    required String symbol,
    required String name,
    required int decimals,
    String? logoUrl,
    required int networkId,
  }) async {
    if (!isValidEthereumAddress(contractAddress)) {
      throw Exception('Invalid contract address');
    }

    final token = TokenEntity(
      contractAddress: contractAddress,
      symbol: symbol,
      name: name,
      decimals: decimals,
      logoUrl: logoUrl,
      networkId: networkId,
    );

    await localDataSource.addToken(account, token);
  }

  @override
  Future<void> removeTokenFromAccount({
    required AccountEntity account,
    required String contractAddress,
    required int networkId,
  }) async {
    await localDataSource.removeToken(account, contractAddress, networkId);
  }

  @override
  Future<List<TokenEntity>> getAccountTokens({
    required AccountEntity account,
    required int networkId,
  }) async {
    return await localDataSource.getTokens(account, networkId);
  }

  @override
  Future<List<TokenBalanceEntity>> getTokenBalances({
    required AccountEntity account,
    required int networkId,
  }) async {
    final tokens =
        await getAccountTokens(account: account, networkId: networkId);
    final List<TokenBalanceEntity> balances = [];

    for (final token in tokens) {
      double balance = 0.0;
      double fiatValue = 0.0;

      if (web3Client != null) {
        balance = await _fetchTokenBalance(
          web3Client!,
          token.contractAddress,
          account.address,
          token.decimals,
        );

        final price = await getTokenPrice(
          contractAddress: token.contractAddress,
          networkId: networkId,
        );

        fiatValue = balance * price;
      } else {
        final cachedBalance =
            await localDataSource.getTokenBalance(account, token);
        balance = cachedBalance.balance;
        fiatValue = cachedBalance.fiatValue;
      }

      balances.add(TokenBalanceEntity(
        token: token,
        balance: balance,
        fiatValue: fiatValue,
      ));
    }

    return balances;
  }

  @override
  Future<double> getTokenPrice({
    required String contractAddress,
    required int networkId,
  }) async {
    // Implement price fetching from an API like CoinGecko or a price oracle
    // This is a placeholder implementation
    try {
      // For native token (ETH, BNB, etc)
      if (contractAddress.toLowerCase() == 'native') {
        return await localDataSource.getNativeTokenPrice(networkId);
      }

      return await localDataSource.getTokenPrice(contractAddress, networkId);
    } catch (e) {
      // Return 0 if price can't be fetched
      return 0.0;
    }
  }

  Future<double> _fetchTokenBalance(
    Web3Client client,
    String contractAddress,
    String accountAddress,
    int decimals,
  ) async {
    try {
      // For native token (ETH)
      if (contractAddress.toLowerCase() == 'native') {
        final balance =
            await client.getBalance(EthereumAddress.fromHex(accountAddress));
        return balance.getValueInUnit(EtherUnit.ether);
      }

      // For ERC20 tokens
      final contract = DeployedContract(
        ContractAbi.fromJson(erc20Abi, 'ERC20'),
        EthereumAddress.fromHex(contractAddress),
      );

      final balanceFunction = contract.function('balanceOf');
      final result = await client.call(
        contract: contract,
        function: balanceFunction,
        params: [EthereumAddress.fromHex(accountAddress)],
      );

      final balance = result[0] as BigInt;
      return balance / BigInt.from(10).pow(decimals);
    } catch (e) {
      throw Exception('Failed to fetch token balance: ${e.toString()}');
    }
  }

  bool isValidEthereumAddress(String address) {
    try {
      EthereumAddress.fromHex(address);
      return true;
    } catch (_) {
      return false;
    }
  }
}

// ERC20 ABI for token interactions
const String erc20Abi = '''
[
  {
    "constant": true,
    "inputs": [],
    "name": "name",
    "outputs": [{"name": "", "type": "string"}],
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "symbol",
    "outputs": [{"name": "", "type": "string"}],
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "decimals",
    "outputs": [{"name": "", "type": "uint8"}],
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [{"name": "_owner", "type": "address"}],
    "name": "balanceOf",
    "outputs": [{"name": "balance", "type": "uint256"}],
    "type": "function"
  }
]
''';
