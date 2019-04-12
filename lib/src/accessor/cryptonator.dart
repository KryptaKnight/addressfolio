import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart';

class Cryptonator {
  final BaseClient client;

  Cryptonator(this.client);

  Future<PriceFull> getFull(String coin) async {
    final resp =
        await client.get('https://api.cryptonator.com/api/full/$coin-usd');
    return new PriceFull.fromMap(JSON.decode(resp.body));
  }

  Future<PriceFull> get fullBTC => getFull('btc');

  Future<PriceFull> get fullLTC => getFull('ltc');

  Future<PriceFull> get fullETH => getFull('eth');

  Future<PriceFull> get fullWTC => getFull('wtc');

  Future<PriceFull> get fullADX => getFull('ADX');

  Future<PriceFull> get fullNEO => getFull('NEO');

  Future<PriceFull> get fullGAS => getFull('GAS');

  Future<PriceFull> get fullNAV => getFull('NAV');
}

class PriceFull {
  final DateTime time;

  final String base;

  final String target;

  final double price;

  final double volume;

  final double change;

  final Map<String, Market> markets;

  const PriceFull(
      {this.time,
      this.base,
      this.target,
      this.price,
      this.volume,
      this.change,
      this.markets});

  factory PriceFull.fromMap(Map map) {
    final Map tickerMap = map['ticker'];
    final double price = double.parse(tickerMap['price'], (_) => 0.0);
    final double volume = double.parse(tickerMap['volume'], (_) => 0.0);
    final double change = double.parse(tickerMap['change'], (_) => 0.0);

    final markets = <String, Market>{};
    for (Map marketMap in tickerMap['markets']) {
      final market = new Market.fromMap(marketMap);
      markets[market.name] = market;
    }

    // TODO parse time
    return new PriceFull(
        base: tickerMap['base'],
        target: tickerMap['target'],
        price: price,
        volume: volume,
        change: change,
        markets: markets);
  }

  String toString() {
    final sb = new StringBuffer();
    sb.writeln('$base to $target');
    sb.writeln('Price: $price');
    sb.writeln('Volume: $volume');
    sb.writeln('Change: $change');
    sb.writeln('Markets: ');
    for (Market market in markets.values) {
      sb.writeln('  $market');
    }
    return sb.toString();
  }
}

class Market {
  final String name;

  final double price;

  final double volume;

  const Market(this.name, this.price, this.volume);

  factory Market.fromMap(Map map) {
    final double price = double.parse(map['price'], (_) => 0.0);
    return new Market(map['market'], price, map['volume'].toDouble() ?? 0.0);
  }

  String toString() {
    final sb = new StringBuffer();
    sb.write('$name [Price: $price] [Volume: $volume]');
    return sb.toString();
  }
}
