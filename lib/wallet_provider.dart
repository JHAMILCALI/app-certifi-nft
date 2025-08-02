import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

class WalletProvider with ChangeNotifier {
  WalletConnect? _connector;
  SessionStatus? _session;
  String? _walletAddress;

  String? get walletAddress => _walletAddress;
  bool get isConnected => _session != null;

  WalletProvider() {
    _initWalletConnect();
  }

  void _initWalletConnect() {
    _connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
        name: 'Flutter Wallet App',
        description: 'Flutter + MetaMask + WalletConnect',
        url: 'https://flutter.dev',
        icons: ['https://flutter.dev/favicon.ico'],
      ),
    );

    _connector!.on('connect', (session) {
      final s = session as SessionStatus;
      _session = s;
      _walletAddress = s.accounts[0];
      notifyListeners();
    });

    _connector!.on('session_update', (payload) {
      final s = payload as SessionStatus;
      _walletAddress = s.accounts[0];
      notifyListeners();
    });

    _connector!.on('disconnect', (_) {
      _session = null;
      _walletAddress = null;
      notifyListeners();
    });
  }

  Future<void> connectWallet() async {
    if (!_connector!.connected) {
      try {
        final session = await _connector!.createSession(
          onDisplayUri: (uri) async {
            final metamaskUri = Uri.parse(uri);
            await launchUrl(metamaskUri, mode: LaunchMode.externalApplication);
          },
        );
        _session = session;
        _walletAddress = session.accounts[0];
        notifyListeners();
      } catch (e) {
        debugPrint('Error al conectar: $e');
      }
    }
  }

  Future<void> disconnect() async {
    await _connector?.killSession();
    _session = null;
    _walletAddress = null;
    notifyListeners();
  }
}
