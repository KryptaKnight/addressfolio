import 'dart:async';
import 'package:http/http.dart';
import 'package:addressfolio/src/accessor/fetcher.dart';
import 'package:addressfolio/src/accessor/cryptonator.dart';

final client = new Client();

final fetcher = new Fetcher(client, '6F8UYZ5R8CKMNUUYM2RAQW59AGNBXZX5P4');

main() async {
  /* TODO
  final basket = new Basket(
      eth:
          new Set<String>.from(['0xb7258497d9b96134fc9cdd714b42bdbf98845494']));
  final Balances balance = await fetcher.getBalance(basket);
  print(balance);
  */

  // print(await fetcher.prices);

  /*
  print(await Future.wait<double>([
    fetcher.btcExplorer.getBalance('155fzsEBHy9Ri2bMQ8uuuR3tv1YzcDywd4'),
    fetcher.ltcExplorer.getBalance('LQ8ZMKRVXQEZXrnhWHh8ekSadbx5oAEZZF')
  ]));
  */

  print(await fetcher.neoExplorer.getBalance('AXUXDpQVXUKb2bcK3oJYT3HK86D38RREGq'));
}
