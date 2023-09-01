// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"ID","type":"bytes32"}],"name":"Accepted","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"ID","type":"bytes32"}],"name":"Closed","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"ID","type":"bytes32"},{"indexed":false,"internalType":"uint128","name":"round","type":"uint128"},{"indexed":false,"internalType":"uint64","name":"time","type":"uint64"}],"name":"Closing","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"ID","type":"bytes32"}],"name":"Open","type":"event"},{"inputs":[{"internalType":"bytes32","name":"id","type":"bytes32"}],"name":"accept","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"id","type":"bytes32"},{"internalType":"uint256","name":"valueA","type":"uint256"},{"internalType":"uint256","name":"valueB","type":"uint256"},{"internalType":"uint128","name":"round","type":"uint128"},{"internalType":"bytes","name":"sig","type":"bytes"}],"name":"challenge","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"name":"channels","outputs":[{"internalType":"address","name":"a","type":"address"},{"internalType":"address","name":"b","type":"address"},{"internalType":"uint256","name":"valueA","type":"uint256"},{"internalType":"uint256","name":"valueB","type":"uint256"},{"internalType":"enum Channel.Prog","name":"progression","type":"uint8"},{"internalType":"uint128","name":"round","type":"uint128"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"id","type":"bytes32"},{"internalType":"uint256","name":"valueA","type":"uint256"},{"internalType":"uint256","name":"valueB","type":"uint256"},{"internalType":"bytes","name":"sig","type":"bytes"}],"name":"cooperativeClose","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"id","type":"bytes32"},{"internalType":"uint256","name":"valueA","type":"uint256"},{"internalType":"uint256","name":"valueB","type":"uint256"},{"internalType":"uint128","name":"round","type":"uint128"},{"internalType":"bytes","name":"sig","type":"bytes"}],"name":"disputeChallenge","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"name":"disputes","outputs":[{"internalType":"uint64","name":"time","type":"uint64"},{"internalType":"address","name":"closer","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"id","type":"bytes32"}],"name":"forceClose","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"id","type":"bytes32"},{"components":[{"internalType":"address","name":"a","type":"address"},{"internalType":"address","name":"b","type":"address"},{"internalType":"uint256","name":"valueA","type":"uint256"},{"internalType":"uint256","name":"valueB","type":"uint256"},{"internalType":"enum Channel.Prog","name":"progression","type":"uint8"},{"internalType":"uint128","name":"round","type":"uint128"}],"internalType":"struct Channel.ChannelState","name":"state","type":"tuple"},{"internalType":"uint256","name":"valueA","type":"uint256"},{"internalType":"uint256","name":"valueB","type":"uint256"},{"internalType":"uint128","name":"round","type":"uint128"}],"name":"hashState","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"bytes32","name":"id","type":"bytes32"},{"internalType":"address","name":"addrB","type":"address"},{"internalType":"uint256","name":"valueA","type":"uint256"},{"internalType":"uint256","name":"valueB","type":"uint256"}],"name":"open","outputs":[],"stateMutability":"payable","type":"function"}]',
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
  Future<String> accept(
    _i2.Uint8List id, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, 'e4725ba1'));
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
  Future<String> challenge(
    _i2.Uint8List id,
    BigInt valueA,
    BigInt valueB,
    BigInt round,
    _i2.Uint8List sig, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, 'a7293956'));
    final params = [
      id,
      valueA,
      valueB,
      round,
      sig,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<Channels> channels(
    _i2.Uint8List $param6, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, '7a7ebd7b'));
    final params = [$param6];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return Channels(response);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> cooperativeClose(
    _i2.Uint8List id,
    BigInt valueA,
    BigInt valueB,
    _i2.Uint8List sig, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, '098d419d'));
    final params = [
      id,
      valueA,
      valueB,
      sig,
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
  Future<String> disputeChallenge(
    _i2.Uint8List id,
    BigInt valueA,
    BigInt valueB,
    BigInt round,
    _i2.Uint8List sig, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, '271d30ca'));
    final params = [
      id,
      valueA,
      valueB,
      round,
      sig,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<Disputes> disputes(
    _i2.Uint8List $param16, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, '11be1997'));
    final params = [$param16];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return Disputes(response);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> forceClose(
    _i2.Uint8List id, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, '267656cc'));
    final params = [id];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i2.Uint8List> hashState(
    _i2.Uint8List id,
    dynamic state,
    BigInt valueA,
    BigInt valueB,
    BigInt round, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, '31b5d50d'));
    final params = [
      id,
      state,
      valueA,
      valueB,
      round,
    ];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as _i2.Uint8List);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> open(
    _i2.Uint8List id,
    _i1.EthereumAddress addrB,
    BigInt valueA,
    BigInt valueB, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[8];
    assert(checkSignature(function, 'a72d6a48'));
    final params = [
      id,
      addrB,
      valueA,
      valueB,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
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
}

class Channels {
  Channels(List<dynamic> response)
      : a = (response[0] as _i1.EthereumAddress),
        b = (response[1] as _i1.EthereumAddress),
        valueA = (response[2] as BigInt),
        valueB = (response[3] as BigInt),
        progression = (response[4] as BigInt),
        round = (response[5] as BigInt);

  final _i1.EthereumAddress a;

  final _i1.EthereumAddress b;

  final BigInt valueA;

  final BigInt valueB;

  final BigInt progression;

  final BigInt round;
}

class Disputes {
  Disputes(List<dynamic> response)
      : time = (response[0] as BigInt),
        closer = (response[1] as _i1.EthereumAddress);

  final BigInt time;

  final _i1.EthereumAddress closer;
}

class Accepted {
  Accepted(
    List<dynamic> response,
    this.event,
  ) : ID = (response[0] as _i2.Uint8List);

  final _i2.Uint8List ID;

  final _i1.FilterEvent event;
}

class Closed {
  Closed(
    List<dynamic> response,
    this.event,
  ) : ID = (response[0] as _i2.Uint8List);

  final _i2.Uint8List ID;

  final _i1.FilterEvent event;
}

class Closing {
  Closing(
    List<dynamic> response,
    this.event,
  )   : ID = (response[0] as _i2.Uint8List),
        round = (response[1] as BigInt),
        time = (response[2] as BigInt);

  final _i2.Uint8List ID;

  final BigInt round;

  final BigInt time;

  final _i1.FilterEvent event;
}

class Open {
  Open(
    List<dynamic> response,
    this.event,
  ) : ID = (response[0] as _i2.Uint8List);

  final _i2.Uint8List ID;

  final _i1.FilterEvent event;
}
