import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivy_dex/core/constants/color.dart';

import 'package:ivy_dex/features/add_coin_to_wallet/presentation/bloc/token_bloc.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/presentation/bloc/token_event.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/presentation/bloc/token_state.dart';
import 'package:ivy_dex/features/wallet/domain/entities/account_entity.dart';
import 'package:ivy_dex/features/wallet/presentation/widgets/optinon_icon.dart';

import '../../../../core/widgets/button_widget.dart';
import '../../../add_coin_to_wallet/presentation/pages/token_list.dart';

class WalletHome extends StatefulWidget {
  final String walletAddress;
  final String privateKey;
  final int accountIndex;
  final int networkId;

  const WalletHome({
    super.key,
    required this.walletAddress,
    required this.privateKey,
    required this.accountIndex,
    required this.networkId,
  });

  @override
  State<WalletHome> createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  late AccountEntity _account;

  @override
  void initState() {
    super.initState();
    _account = AccountEntity(
      index: widget.accountIndex,
      address: widget.walletAddress,
      privateKey: widget.privateKey,
    );

    context.read<TokenBloc>().add(
          LoadTokens(
            account: _account,
            networkId: widget.networkId,
          ),
        );
  }

  String _getNetworkName(int networkId) {
    switch (networkId) {
      case 1:
        return 'Ethereum Main Network';
      case 56:
        return 'Binance Smart Chain';
      case 137:
        return 'Polygon Network';
      default:
        return 'Unknown Network';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        importAccountModal(context);
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 30,
                          ),
                          const SizedBox(width: 5),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Account ${widget.accountIndex}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _getNetworkName(widget.networkId),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.qr_code_scanner),
                  ],
                ),
                const SizedBox(height: 40),

                // Total wallet balance display with BLoC state
                BlocBuilder<TokenBloc, TokenState>(
                  builder: (context, state) {
                    if (state is TokenLoading) {
                      return const CircularProgressIndicator();
                    }

                    double totalBalance = 0;
                    double totalFiatValue = 0;
                    String nativeSymbol = 'ETH'; // Default

                    if (state is TokenBalancesLoaded) {
                      // Calculate total balance and find native token
                      for (var balance in state.balances) {
                        totalFiatValue += balance.fiatValue;
                        if (balance.token.contractAddress.toLowerCase() ==
                            'native') {
                          totalBalance = balance.balance;
                          nativeSymbol = balance.token.symbol;
                        }
                      }
                    }

                    return Column(
                      children: [
                        Text(
                          '${totalBalance.toStringAsFixed(4)} $nativeSymbol',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(fontSize: 35),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('\$${totalFiatValue.toStringAsFixed(2)}'),
                            const SizedBox(width: 7),
                            const Text(
                              '+5.42%',
                              style: TextStyle(color: kSuccessColor),
                            )
                          ],
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 40),
                SizedBox(
                  width: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconOption(
                        icon: Icons.send_outlined,
                        text: 'Send',
                      ),
                      IconOption(
                        icon: Icons.account_balance_wallet_outlined,
                        text: 'Receive',
                      ),
                      IconOption(
                        icon: Icons.settings_ethernet,
                        text: 'Buy',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  dividerHeight: 0,
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(text: 'Tokens'),
                    Tab(text: 'Collectibles'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      TokenList(
                        account: _account,
                        networkId: widget.networkId,
                      ),
                      const Center(
                        child: Text('NFT Collection Coming Soon'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void importAccountModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        padding: EdgeInsets.only(
            top: 12,
            left: 26,
            right: 26,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        height: MediaQuery.of(context).size.height * 0.65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 40,
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Header
                Center(
                  child: Text(
                    'Import Account',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Imported accounts are viewable in your wallet but are not recoverable with your Ivy Wallet seed phrase',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        'Learn more about imported account',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Here',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: kPrimaryColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    helperText:
                        'e.g \n0x4c0883a6910395b6c85f73bb2b59d3b4e5e6a\n295d0f3aa0f75c0c15b19766b79',
                    labelText: 'Paste you private key string',
                  ),
                ),
              ],
            ),
            ButtonWidget(
              color: kPrimaryColor,
              text: 'Import',
              onTap: () {},
            ),
          ],
        ),
      );
    },
  );
}
