import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivy_dex/core/constants/color.dart';
import 'package:ivy_dex/core/widgets/button_widget.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/domain/entities/token_balance.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/presentation/bloc/token_bloc.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/presentation/bloc/token_event.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/presentation/bloc/token_state.dart';
import 'package:ivy_dex/features/wallet/domain/entities/account_entity.dart';

import 'add_token_page.dart';

class TokenList extends StatelessWidget {
  final AccountEntity account;
  final int networkId;

  const TokenList({
    Key? key,
    required this.account,
    this.networkId = 1, // Default to Ethereum Mainnet
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TokenBloc, TokenState>(
      listener: (context, state) {
        if (state is TokenOperationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is TokenLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        List<TokenBalanceEntity> balances = [];

        if (state is TokenBalancesLoaded) {
          balances = state.balances;
        }

        return Column(
          children: [
            Expanded(
              child: balances.isEmpty
                  ? Center(
                      child: Text(
                        'No tokens found. Add tokens to get started.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        context.read<TokenBloc>().add(
                              RefreshBalances(
                                account: account,
                                networkId: networkId,
                              ),
                            );
                      },
                      child: ListView.builder(
                        itemCount: balances.length,
                        itemBuilder: (context, index) {
                          final token = balances[index];
                          return TokenListItem(
                            tokenBalance: token,
                            onRemove: () {
                              // Show confirm dialog
                              _showRemoveTokenDialog(context, token);
                            },
                          );
                        },
                      ),
                    ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ButtonWidget(
                    color: kPrimaryColor,
                    text: 'Add Token',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddTokenPage(account: account),
                        ),
                      );
                    })),
          ],
        );
      },
    );
  }

  void _showRemoveTokenDialog(BuildContext context, TokenBalanceEntity token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Token'),
        content: Text('Are you sure you want to remove ${token.token.symbol}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TokenBloc>().add(
                    RemoveToken(
                      accountIndex: account.index,
                      address: account.address,
                      privateKey: account.privateKey,
                      contractAddress: token.token.contractAddress,
                      networkId: networkId,
                    ),
                  );
              Navigator.of(context).pop();
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

class TokenListItem extends StatelessWidget {
  final TokenBalanceEntity tokenBalance;
  final VoidCallback onRemove;

  const TokenListItem({
    Key? key,
    required this.tokenBalance,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[800],
          child: tokenBalance.token.logoUrl != null &&
                  tokenBalance.token.logoUrl!.isNotEmpty
              ? Image.network(
                  tokenBalance.token.logoUrl!,
                  errorBuilder: (context, error, stackTrace) {
                    return Text(tokenBalance.token.symbol[0]);
                  },
                )
              : Text(tokenBalance.token.symbol[0]),
        ),
        title: Text(tokenBalance.token.name),
        subtitle: Text(tokenBalance.token.symbol),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${tokenBalance.balance.toStringAsFixed(4)} ${tokenBalance.token.symbol}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '\$${tokenBalance.fiatValue.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
