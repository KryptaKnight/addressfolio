import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

class BtcBlockExplorer {
  final BaseClient client;

  BtcBlockExplorer(this.client);

  Future<double> getBalance(String address) async {
    // TODO handle error and exception
    final res =
        await client.get('https://blockexplorer.com/api/addr/$address/balance');
    final int balance = int.parse(res.body);
    if (balance is! int) throw new Exception('Invalid response!');
    return balance * 1e-8;
  }
}

class LtcBlockExplorer {
  final BaseClient client;

  LtcBlockExplorer(this.client);

  Future<double> getBalance(String address) async {
    // TODO handle error and exception
    final res = await client
        .get('https://api.blockcypher.com/v1/ltc/main/addrs/$address');
    return JSON.decode(res.body)['balance'] * 1e-8;
  }
}

class NeoExplorer {
  final BaseClient client;

  NeoExplorer(this.client);

  Future<List<double>> getBalance(String address) async {
    final data = <String, dynamic>{
      'jsonrpc': '2.0',
      'id': '1',
      'method': 'getaccountstate',
      'params': "['$address']",
    };

    final uri = new Uri.http('seed1.neo.org:10332', '', data);

    // TODO handle error and exception
    final res = await client.get(uri);
    final Map resMap = JSON.decode(res.body);
    final List<Map> balances = resMap['result']['balances'];

    double neo;
    double gas;

    for(Map idv in balances) {
      if(idv['asset'] == '0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7') {
        gas = double.parse(idv['value']);
      }
      if(idv['asset'] == '0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b') {
        neo = double.parse(idv['value']);
      }
    }

    return <double>[neo, gas];
  }
}
