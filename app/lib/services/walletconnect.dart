import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:web3dart/web3dart.dart';

class WalletConnect {

  late Web3App client;
  late SessionData session;

  static final WalletConnect _instance = WalletConnect._internal();
 
  factory WalletConnect() {
    return _instance;
  }

  final _w3mService = W3MService(
    projectId: '{YOUR_PROJECT_ID}',
    metadata: const PairingMetadata(
      name: 'SSPC - Stupid Simple Payment Channels',
      description: 'App for interacting with payment channels',
      url: 'https://www.walletconnect.com/',
      icons: ['https://walletconnect.com/walletconnect-logo.png'],
      redirect: Redirect(
        native: 'flutterdapp://',
        universal: 'https://www.walletconnect.com',
      ),
    ),
  );

  WalletConnect._internal() {
    print("initializing walletconnect");
    _w3mService.init();
  }

  

  void init() async {
    client = await Web3App.createInstance(
      relayUrl: '', // The relay websocket URL, leave blank to use the default
      projectId: '3376',
      metadata: PairingMetadata(
        name: 'SSPC - Stupid Simple Payment Cahnnels',
        description: 'Your favorite payment channel implementation',
        url: 'https://walletconnect.com',
        icons: ['https://avatars.githubusercontent.com/u/37784886'],
      ),
    );
    ConnectResponse resp = await client.connect(
      requiredNamespaces: {
        'eip155': RequiredNamespace(
          chains: ['eip155:1'], // Ethereum chain
          methods: ['eth_signTransaction', 'eth_sign'], // Requestable Methods
          events: ['eth_sendTransaction', 'eth_sign'], // Requestable Events
        ),
      });
    Uri? uri = resp.uri;
    print(uri);
    session = await resp.session.future;
  }

  dynamic sign(EthereumAddress address, String message) async {
    IWeb3App? app = _w3mService.web3App;
    if (app == null) {
      return;
    }
    return await app.request(
      topic: "SPCC",
      chainId: 'eip155:1',
      request: SessionRequestParams(
        method: 'personalSign',
        params: [message, address],
      ),
    );
  }
}