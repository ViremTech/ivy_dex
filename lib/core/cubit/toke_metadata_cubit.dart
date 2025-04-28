import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:ivy_dex/core/cubit/toke_metadata_state.dart';
import 'package:web3dart/web3dart.dart';

class TokenMetadataCubit extends Cubit<TokenMetadataState> {
  Web3Client? _client;
  final String _rpcUrl;
  final int _timeoutSeconds;

  TokenMetadataCubit({
    required String rpcUrl,
    int timeoutSeconds = 10,
  })  : _rpcUrl = rpcUrl,
        _timeoutSeconds = timeoutSeconds,
        super(TokenMetadataInitial());

  // Standard ERC20 ABI functions for metadata
  static const String _erc20Abi = '''
  [
    {"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},
    {"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},
    {"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"}
  ]
  ''';

  void _initializeClient() {
    _client ??= Web3Client(_rpcUrl, Client());
  }

  Future<void> fetchTokenMetadata(String contractAddress) async {
    if (contractAddress.isEmpty) {
      emit(const TokenMetadataError('Contract address cannot be empty'));
      return;
    }

    emit(TokenMetadataLoading());

    try {
      _initializeClient();

      final timeout = Duration(seconds: _timeoutSeconds);

      final contract = DeployedContract(
        ContractAbi.fromJson(_erc20Abi, 'ERC20'),
        EthereumAddress.fromHex(contractAddress),
      );

      final nameFunction = contract.function('name');
      final symbolFunction = contract.function('symbol');
      final decimalsFunction = contract.function('decimals');

      String name = '';
      String symbol = '';
      int decimals = 18;

      try {
        final nameResult = await _client!.call(
          contract: contract,
          function: nameFunction,
          params: [],
        ).timeout(timeout);
        name = nameResult.isNotEmpty ? nameResult[0].toString() : '';
      } catch (e) {
        print('Error fetching token name: $e');
        name = 'Unknown Token';
      }

      try {
        final symbolResult = await _client!.call(
          contract: contract,
          function: symbolFunction,
          params: [],
        ).timeout(timeout);
        symbol = symbolResult.isNotEmpty ? symbolResult[0].toString() : '';
      } catch (e) {
        print('Error fetching token symbol: $e');
        symbol = 'UNKNOWN';
      }

      try {
        final decimalsResult = await _client!.call(
          contract: contract,
          function: decimalsFunction,
          params: [],
        ).timeout(timeout);
        decimals = decimalsResult.isNotEmpty
            ? int.parse(decimalsResult[0].toString())
            : 18;
      } catch (e) {
        print('Error fetching token decimals: $e');
        decimals = 18;
      }

      if (name.isEmpty && symbol.isEmpty) {
        emit(const TokenMetadataError(
            'Could not retrieve any token information'));
        return;
      }

      emit(TokenMetadataLoaded(
        name: name.isEmpty ? 'Unknown Token' : name,
        symbol: symbol.isEmpty ? 'UNKNOWN' : symbol,
        decimals: decimals,
      ));
    } catch (e) {
      print('Token metadata fetch error: $e');
      emit(TokenMetadataError(
          'Failed to fetch token metadata: ${e.toString().split('\n').first}'));
    }
  }

  void reset() {
    emit(TokenMetadataInitial());
  }

  @override
  Future<void> close() async {
    if (_client != null) {
      _client!.dispose();
      _client = null;
    }
    return super.close();
  }
}
