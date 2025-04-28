import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivy_dex/core/constants/color.dart';
import 'package:ivy_dex/core/widgets/button_widget.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/presentation/bloc/token_bloc.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/presentation/bloc/token_event.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/presentation/bloc/token_state.dart';
import 'package:ivy_dex/features/wallet/domain/entities/account_entity.dart';

import '../../../../core/cubit/toke_metadata_cubit.dart';
import '../../../../core/cubit/toke_metadata_state.dart';

class AddTokenPage extends StatefulWidget {
  final AccountEntity account;
  final int networkId;

  const AddTokenPage({
    super.key,
    required this.account,
    this.networkId = 1, // Default to Ethereum Mainnet
  });

  @override
  State<AddTokenPage> createState() => _AddTokenPageState();
}

class _AddTokenPageState extends State<AddTokenPage> {
  final TextEditingController contractController = TextEditingController();
  final TextEditingController symbolController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController decimalController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isAddressValid = false;
  bool _isSubmitting = false;
  bool _isMetadataFetching = false;

  // Get network RPC URL based on network ID
  String get rpcUrl {
    // final String api =
    //     'https://gas.api.infura.io/v3/521e58e72a324173aa74fbf08a139ebb';

    switch (widget.networkId) {
      case 1:
        return 'https://mainnet.infura.io/v3/521e58e72a324173aa74fbf08a139ebb';
      case 5:
        return 'https://goerli.infura.io/v3/YOUR_INFURA_KEY';
      case 11155111:
        return 'https://sepolia.infura.io/v3/YOUR_INFURA_KEY';
      case 137:
        return 'https://polygon-rpc.com';
      default:
        return 'https://mainnet.infura.io/v3/521e58e72a324173aa74fbf08a139ebb';
    }
  }

  @override
  void initState() {
    super.initState();
    decimalController.text = '18'; // Default for most ERC20 tokens
  }

  @override
  void dispose() {
    contractController.dispose();
    symbolController.dispose();
    nameController.dispose();
    decimalController.dispose();
    super.dispose();
  }

  void _validateContractAddress() {
    if (contractController.text.isNotEmpty) {
      context.read<TokenBloc>().add(
            ValidateAddress(address: contractController.text),
          );
    }
  }

  void _fetchTokenMetadata() {
    if (_isAddressValid && contractController.text.isNotEmpty) {
      setState(() {
        _isMetadataFetching = true;
      });

      context
          .read<TokenMetadataCubit>()
          .fetchTokenMetadata(contractController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TokenMetadataCubit(rpcUrl: rpcUrl),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Import Token'),
          ),
          body: BlocConsumer<TokenBloc, TokenState>(
            listener: (context, state) {
              if (state is TokenOperationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                Navigator.of(context).pop();
              } else if (state is TokenOperationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
                setState(() {
                  _isSubmitting = false;
                });
              } else if (state is AddressValidationState) {
                setState(() {
                  _isAddressValid = state.isValid;
                });

                if (state.isValid) {
                  _fetchTokenMetadata();
                }
              }
            },
            builder: (context, state) {
              return BlocListener<TokenMetadataCubit, TokenMetadataState>(
                listener: (context, metadataState) {
                  if (metadataState is TokenMetadataLoaded) {
                    setState(() {
                      symbolController.text = metadataState.symbol;
                      nameController.text = metadataState.name;
                      decimalController.text =
                          metadataState.decimals.toString();
                      _isMetadataFetching = false;
                    });
                  } else if (metadataState is TokenMetadataError) {
                    setState(() {
                      _isMetadataFetching = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Metadata error: ${metadataState.message}'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 30),
                                TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: contractController,
                                  decoration: InputDecoration(
                                    labelText: 'Contract Address',
                                    suffixIcon: _isAddressValid
                                        ? const Icon(Icons.check_circle,
                                            color: kSuccessColor)
                                        : null,
                                    errorText:
                                        state is AddressValidationState &&
                                                !state.isValid
                                            ? 'Invalid Ethereum address'
                                            : null,
                                    helperText:
                                        'Enter a valid ERC20 token contract address',
                                  ),
                                  onChanged: (_) {
                                    _validateContractAddress();
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a contract address';
                                    }
                                    if (!_isAddressValid) {
                                      return 'Address is not valid';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                BlocBuilder<TokenMetadataCubit,
                                    TokenMetadataState>(
                                  builder: (context, metadataState) {
                                    return Column(
                                      children: [
                                        if (_isMetadataFetching)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Row(
                                              children: [
                                                const SizedBox(
                                                  height: 16,
                                                  width: 16,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  'Fetching token metadata...',
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.7),
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        TextFormField(
                                          style: const TextStyle(
                                              color: Colors.white),
                                          controller: symbolController,
                                          enabled: !_isMetadataFetching,
                                          decoration: const InputDecoration(
                                            labelText: 'Symbol',
                                            helperText:
                                                'Token symbol (e.g. UNI, LINK)',
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a token symbol';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          style: const TextStyle(
                                              color: Colors.white),
                                          controller: nameController,
                                          enabled: !_isMetadataFetching,
                                          decoration: const InputDecoration(
                                            labelText: 'Name',
                                            helperText:
                                                'Full token name (e.g. Uniswap, Chainlink)',
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a token name';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          style: const TextStyle(
                                              color: Colors.white),
                                          controller: decimalController,
                                          enabled: !_isMetadataFetching,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            labelText: 'Decimals',
                                            helperText:
                                                'Number of token decimals (usually 18)',
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter decimal places';
                                            }
                                            try {
                                              int decimals = int.parse(value);
                                              if (decimals < 0 ||
                                                  decimals > 36) {
                                                return 'Decimals must be between 0 and 36';
                                              }
                                            } catch (e) {
                                              return 'Please enter a valid number';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Note: Adding custom tokens is done at your own risk. Make sure to verify the token contract address before adding.',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: ButtonWidget(
                            color: kPrimaryColor,
                            text:
                                _isSubmitting ? 'Importing...' : 'Import Token',
                            onTap: (_isSubmitting || _isMetadataFetching)
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isSubmitting = true;
                                      });

                                      context.read<TokenBloc>().add(
                                            AddToken(
                                              account: widget.account,
                                              contractAddress:
                                                  contractController.text,
                                              symbol: symbolController.text,
                                              name: nameController.text,
                                              decimals: int.parse(
                                                  decimalController.text),
                                              networkId: widget.networkId,
                                            ),
                                          );
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
