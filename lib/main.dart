import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'wallet_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WalletProvider(),
      child: MaterialApp(
        title: 'MetaMask Flutter Android',
        theme: ThemeData.dark(),
        home: const WalletPage(),
      ),
    );
  }
}

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WalletProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('MetaMask + Flutter')),
      body: Center(
        child:
            provider.isConnected
                ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Wallet conectada"),
                    Text(provider.walletAddress ?? ''),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => provider.disconnect(),
                      child: const Text("Desconectar"),
                    ),
                  ],
                )
                : ElevatedButton(
                  onPressed: () => provider.connectWallet(),
                  child: const Text("Conectar MetaMask"),
                ),
      ),
    );
  }
}
