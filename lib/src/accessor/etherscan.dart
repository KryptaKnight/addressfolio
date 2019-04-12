import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

class EtherScan {
  final String apiKey;

  final BaseClient client;

  EtherScan(this.apiKey, this.client);

  Future<double> getBalance(String address) async {
    final query = <String, String>{
      'module': 'account',
      'action': 'balance',
      'address': address,
      'tag': 'latest',
      'apikey': apiKey,
    };

    final uri = new Uri.https('api.etherscan.io', 'api', query);

    // TODO handle error and exception
    final res = await client.get(uri);
    return _getBalance(res.body) * 1e-18;
  }

  Future<double> getTokenBalance(String contractAddress, String address) async {
    final query = <String, String>{
      'module': 'account',
      'action': 'tokenbalance',
      'contractaddress': contractAddress,
      'address': address,
      'tag': 'latest',
      'apikey': apiKey,
    };

    final uri = new Uri.https('api.etherscan.io', 'api', query);

    // TODO handle error and exception
    final res = await client.get(uri);
    return _getBalance(res.body);
  }

  Future<double> getTokenBalanceWTC(String address) async =>
      await getTokenBalance(
          '0xb7cb1c96db6b22b0d3d9536e0108d062bd488f74', address) *
      1e-18;

  Future<double> getTokenBalanceADEX(String address) async =>
      await getTokenBalance(
          '0x4470BB87d77b963A013DB939BE332f927f2b992e', address) *
      1e-4;

  static double _getBalance(String resp) {
    final map = JSON.decode(resp);

    if (map is! Map) throw new Exception('Invalid response!');

    if (map['message'] != 'OK') throw new Exception('Invalid response!');

    if (map['result'] is! String) throw new Exception('Invalid response!');

    int ret = int.parse(map['result'], onError: (_) => null);

    if (ret == null) throw new Exception('Invalid response!');

    return ret.toDouble();
  }
}
