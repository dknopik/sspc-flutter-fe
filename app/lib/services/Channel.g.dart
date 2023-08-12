// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"type":"function","name":"open","inputs":[{"name":"id","type":"uint256"},{"name":"addr_b","type":"address"},{"name":"value_a","type":"uint256"},{"name":"value_b","type":"uint256"}],"outputs":[],"stateMutability":"payable"},{"type":"function","name":"accept","inputs":[{"name":"id","type":"uint256"}],"outputs":[],"stateMutability":"payable"},{"type":"function","name":"cooperative_close","inputs":[{"name":"id","type":"uint256"},{"name":"value_a","type":"uint256"},{"name":"value_b","type":"uint256"},{"name":"sig","type":"bytes"}],"outputs":[],"stateMutability":"payable"},{"type":"event","name":"Dispute","inputs":[{"name":"time","type":"uint64","indexed":false},{"name":"closer","type":"address","indexed":false}],"anonymous":false},{"type":"event","name":"HashContents","inputs":[{"name":"id","type":"uint256","indexed":false},{"name":"a","type":"address","indexed":false},{"name":"b","type":"address","indexed":false},{"name":"value_a","type":"uint256","indexed":false},{"name":"value_b","type":"uint256","indexed":false},{"name":"round","type":"uint128","indexed":false}],"anonymous":false},{"type":"event","name":"Open","inputs":[{"name":"id","type":"uint256","indexed":true}],"anonymous":false},{"type":"event","name":"Accepted","inputs":[{"name":"id","type":"uint256","indexed":true}],"anonymous":false},{"type":"event","name":"Closing","inputs":[{"name":"id","type":"uint256","indexed":true},{"name":"round","type":"uint128","indexed":false},{"name":"time","type":"uint64","indexed":false}],"anonymous":false},{"type":"event","name":"Closed","inputs":[{"name":"id","type":"uint256","indexed":true}],"anonymous":false},{"type":"event","name":"Context","inputs":[],"anonymous":false}]',
  'Channel',
);

class Channel extends _i1.GeneratedContract {
  Channel({
    required _i1.EthereumAddress address,
    required _i1.Web3Client client,
    int? chainId,
  }) : super(
          _i1.DeployedContract(
            _contractAbi,
            address,
          ),
          client,
          chainId,
        );

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> open(
    BigInt id,
    _i1.EthereumAddress addr_b,
    BigInt value_a,
    BigInt value_b, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, '5bae2931'));
    final params = [
      id,
      addr_b,
      value_a,
      value_b,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> accept(
    BigInt id, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '19b05f49'));
    final params = [id];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> cooperative_close(
    BigInt id,
    BigInt value_a,
    BigInt value_b,
    _i2.Uint8List sig, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, 'a56aebe6'));
    final params = [
      id,
      value_a,
      value_b,
      sig,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// Returns a live stream of all Dispute events emitted by this contract.
  Stream<Dispute> disputeEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('Dispute');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return Dispute(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all HashContents events emitted by this contract.
  Stream<HashContents> hashContentsEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('HashContents');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return HashContents(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all Open events emitted by this contract.
  Stream<Open> openEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('Open');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return Open(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all Accepted events emitted by this contract.
  Stream<Accepted> acceptedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('Accepted');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return Accepted(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all Closing events emitted by this contract.
  Stream<Closing> closingEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('Closing');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return Closing(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all Closed events emitted by this contract.
  Stream<Closed> closedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('Closed');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return Closed(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all Context events emitted by this contract.
  Stream<Context> contextEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('Context');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return Context(
        decoded,
        result,
      );
    });
  }
}

class Dispute {
  Dispute(
    List<dynamic> response,
    this.event,
  )   : time = (response[0] as BigInt),
        closer = (response[1] as _i1.EthereumAddress);

  final BigInt time;

  final _i1.EthereumAddress closer;

  final _i1.FilterEvent event;
}

class HashContents {
  HashContents(
    List<dynamic> response,
    this.event,
  )   : id = (response[0] as BigInt),
        a = (response[1] as _i1.EthereumAddress),
        b = (response[2] as _i1.EthereumAddress),
        valuea = (response[3] as BigInt),
        valueb = (response[4] as BigInt),
        round = (response[5] as BigInt);

  final BigInt id;

  final _i1.EthereumAddress a;

  final _i1.EthereumAddress b;

  final BigInt valuea;

  final BigInt valueb;

  final BigInt round;

  final _i1.FilterEvent event;
}

class Open {
  Open(
    List<dynamic> response,
    this.event,
  ) : id = (response[0] as BigInt);

  final BigInt id;

  final _i1.FilterEvent event;
}

class Accepted {
  Accepted(
    List<dynamic> response,
    this.event,
  ) : id = (response[0] as BigInt);

  final BigInt id;

  final _i1.FilterEvent event;
}

class Closing {
  Closing(
    List<dynamic> response,
    this.event,
  )   : id = (response[0] as BigInt),
        round = (response[1] as BigInt),
        time = (response[2] as BigInt);

  final BigInt id;

  final BigInt round;

  final BigInt time;

  final _i1.FilterEvent event;
}

class Closed {
  Closed(
    List<dynamic> response,
    this.event,
  ) : id = (response[0] as BigInt);

  final BigInt id;

  final _i1.FilterEvent event;
}

class Context {
  Context(
    List<dynamic> response,
    this.event,
  );

  final _i1.FilterEvent event;
}
