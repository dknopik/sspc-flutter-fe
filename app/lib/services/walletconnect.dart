
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:web3dart/web3dart.dart';

class WalletConnect {

  late Web3App client;
  late SessionData session;

  static final WalletConnect _instance = WalletConnect._internal();
 
  factory WalletConnect() {
    return _instance;
  }

  WalletConnect._internal() {
    print("initializing walletconnect");
    init();
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
    return await client.request(
      topic: session.topic,
      chainId: 'eip155:1',
      request: SessionRequestParams(
        method: 'eth_sign',
        params: [address.hex, message],
      ),
    );
  }
}