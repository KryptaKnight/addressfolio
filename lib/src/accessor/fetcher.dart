import 'dart:async';
import 'package:http/http.dart';

import 'etherscan.dart';
import 'cryptonator.dart';
import 'blockexplorer.dart';
export 'cryptonator.dart' show PriceFull;

class Basket {
  final Set<String> btc;

  final Set<String> ltc;

  final Set<String> eth;

  final Set<String> neo;

  final Set<String> nav;

  Basket(
      {Set<String> eth,
      Set<String> neo,
      Set<String> btc,
      Set<String> ltc,
      Set<String> nav})
      : btc = btc ?? new Set<String>(),
        ltc = ltc ?? new Set<String>(),
        eth = eth ?? new Set<String>(),
        neo = neo ?? new Set<String>(),
        nav = nav ?? new Set<String>();

  String toString() {
    final sb = new StringBuffer();
    sb.writeln('BTC: $btc');
    sb.writeln('LTC: $ltc');
    sb.writeln('ETH: $eth');
    sb.writeln('NEO: $neo');
    sb.writeln('NAV: $nav');
    return sb.toString();
  }
}

class Fetcher {
  final EtherScan ethScan;

  final Cryptonator cryptonator;

  final BtcBlockExplorer btcExplorer;

  final LtcBlockExplorer ltcExplorer;

  final NeoExplorer neoExplorer;

  Fetcher(BaseClient client, String ethScannerApi)
      : ethScan = new EtherScan(ethScannerApi, client),
        cryptonator = new Cryptonator(client),
        btcExplorer = new BtcBlockExplorer(client),
        ltcExplorer = new LtcBlockExplorer(client),
        neoExplorer = new NeoExplorer(client);

  Future<Balances> getBalance(Basket basket) async {
    final eths = <Future<double>>[];
    final wtcs = <Future<double>>[];
    final adexs = <Future<double>>[];
    for (String addr in basket.eth) {
      eths.add(ethScan.getBalance(addr));
      wtcs.add(ethScan.getTokenBalanceWTC(addr));
      adexs.add(ethScan.getTokenBalanceADEX(addr));
    }
    final btcs = <Future<double>>[];
    for (String addr in basket.btc) {
      btcs.add(btcExplorer.getBalance(addr));
    }
    final ltcs = <Future<double>>[];
    for (String addr in basket.ltc) {
      ltcs.add(ltcExplorer.getBalance(addr));
    }
    final neos = <Future<List<double>>>[];
    for (String addr in basket.neo) {
      neos.add(neoExplorer.getBalance(addr));
    }

    final List balances = await Future.wait([
      Future.wait(btcs),
      Future.wait(ltcs),
      Future.wait(eths),
      Future.wait(wtcs),
      Future.wait(adexs),
      Future.wait(neos),
    ]);

    final double btc = balances[0].fold(0.0, (a, b) => a + b);
    final double ltc = balances[1].fold(0.0, (a, b) => a + b);
    final double eth = balances[2].fold(0.0, (a, b) => a + b);
    final double wtc = balances[3].fold(0.0, (a, b) => a + b);
    final double adex = balances[4].fold(0.0, (a, b) => a + b);
    final double neo = balances[5].fold(0.0, (a, b) => a + b[0]);
    final double gas = balances[5].fold(0.0, (a, b) => a + b[1]);

    return new Balances(
      btc: btc,
      ltc: ltc,
      eth: eth,
      wtc: wtc,
      adex: adex,
      neo: neo,
      gas: gas,
    );
  }

  Future<Prices> get prices async {
    final List<PriceFull> prc = await Future.wait<PriceFull>([
      cryptonator.fullBTC,
      cryptonator.fullLTC,
      cryptonator.fullETH,
      cryptonator.fullWTC,
      cryptonator.fullADX,
      cryptonator.fullNEO,
      cryptonator.fullGAS,
    ]);

    return new Prices(
        btc: prc[0],
        ltc: prc[1],
        eth: prc[2],
        wtc: prc[3],
        adx: prc[4],
        neo: prc[5],
        gas: prc[6]);
  }
}

class Prices {
  final PriceFull btc;

  final PriceFull ltc;

  final PriceFull eth;

  final PriceFull wtc;

  final PriceFull adx;

  final PriceFull neo;

  final PriceFull gas;

  final PriceFull nav;

  Prices(
      {this.btc,
      this.ltc,
      this.eth,
      this.wtc,
      this.adx,
      this.neo,
      this.gas,
      this.nav});

  String toString() {
    final sb = new StringBuffer();

    sb.writeln('Bitcoin:');
    sb.writeln('--------');
    sb.writeln(btc);

    sb.writeln('Litecoin:');
    sb.writeln('--------');
    sb.writeln(ltc);

    sb.writeln('Ethereum:');
    sb.writeln('---------');
    sb.writeln(eth);

    sb.writeln('WaltonChain:');
    sb.writeln('------------');
    sb.writeln(wtc);

    sb.writeln('Adex:');
    sb.writeln('-----');
    sb.writeln(adx);

    sb.writeln('Neo:');
    sb.writeln('----');
    sb.writeln(neo);

    sb.writeln('Gas:');
    sb.writeln('----');
    sb.writeln(gas);

    return sb.toString();
  }
}

class Balances {
  final double eth;

  final double wtc;

  final double adex;

  final double neo;

  final double gas;

  final double btc;

  final double ltc;

  final double nav;

  Balances(
      {this.eth: 0.0,
      this.wtc: 0.0,
      this.adex: 0.0,
      this.neo: 0.0,
      this.gas: 0.0,
      this.btc: 0.0,
      this.ltc: 0.0,
      this.nav: 0.0});

  Balances operator *(/* num | Balances */ other) {
    if (other is num) {
      return new Balances(
          eth: eth * other,
          wtc: wtc * other,
          adex: adex * other,
          neo: neo * other,
          gas: gas * other,
          btc: btc * other,
          ltc: ltc * other,
          nav: nav * other);
    } else if (other is Balances) {
      return new Balances(
          eth: eth * other.eth,
          wtc: wtc * other.wtc,
          adex: adex * other.adex,
          neo: neo * other.neo,
          gas: gas * other.gas,
          btc: btc * other.btc,
          ltc: ltc * other.ltc,
          nav: nav * other.nav);
    }

    throw new UnsupportedError('${other.runtimeType} not supported!');
  }

  Balances operator +(/* num | Balances */ other) {
    if (other is num) {
      return new Balances(
          eth: eth + other,
          wtc: wtc + other,
          adex: adex + other,
          neo: neo + other,
          gas: gas + other,
          btc: btc + other,
          ltc: ltc + other,
          nav: nav + other);
    } else if (other is Balances) {
      return new Balances(
          eth: eth + other.eth,
          wtc: wtc + other.wtc,
          adex: adex + other.adex,
          neo: neo + other.neo,
          gas: gas + other.gas,
          btc: btc + other.btc,
          ltc: ltc + other.ltc,
          nav: nav + other.nav);
    }

    throw new UnsupportedError('${other.runtimeType} not supported!');
  }

  Balances operator -(/* num | Balances */ other) {
    if (other is num) {
      return new Balances(
          eth: eth - other,
          wtc: wtc - other,
          adex: adex - other,
          neo: neo - other,
          gas: gas - other,
          btc: btc - other,
          ltc: ltc - other,
          nav: nav - other);
    } else if (other is Balances) {
      return new Balances(
          eth: eth - other.eth,
          wtc: wtc - other.wtc,
          adex: adex - other.adex,
          neo: neo - other.neo,
          gas: gas - other.gas,
          btc: btc - other.btc,
          ltc: ltc - other.ltc,
          nav: nav - other.nav);
    }

    throw new UnsupportedError('${other.runtimeType} not supported!');
  }

  Balances operator -() {
    return new Balances(
        eth: -eth,
        wtc: -wtc,
        adex: -adex,
        neo: -neo,
        gas: -gas,
        btc: -btc,
        ltc: -ltc,
        nav: -nav);
  }

  String toString() {
    final sb = new StringBuffer();

    sb.writeln('ETH: $eth');
    sb.writeln('WTC: $wtc');
    sb.writeln('ADEX: $adex');
    sb.writeln('NEO: $neo');
    sb.writeln('GAS: $gas');
    sb.writeln('BTC: $btc');
    sb.writeln('LTC: $ltc');
    sb.writeln('NAV: $nav');

    return sb.toString();
  }
}

class Holding {
  final String name;

  final double amount;

  final double usdPerCoin;

  final double holdingUsd;

  const Holding({this.name, this.amount, this.usdPerCoin})
      : holdingUsd = amount * usdPerCoin;

  String get holdingUsdStr => holdingUsd.toStringAsFixed(2);

  factory Holding.eth(Prices price, Balances balance) {
    return new Holding(
        name: 'Ethereum', amount: balance.eth, usdPerCoin: price.eth.price);
  }

  factory Holding.wtc(Prices price, Balances balance) {
    return new Holding(
        name: 'Walton', amount: balance.wtc, usdPerCoin: price.wtc.price);
  }

  factory Holding.adx(Prices price, Balances balance) {
    return new Holding(
        name: 'Adex', amount: balance.adex, usdPerCoin: price.adx.price);
  }

  factory Holding.btc(Prices price, Balances balance) {
    return new Holding(
        name: 'Bitcoin', amount: balance.btc, usdPerCoin: price.btc.price);
  }

  factory Holding.ltc(Prices price, Balances balance) {
    return new Holding(
        name: 'Litecoin', amount: balance.ltc, usdPerCoin: price.ltc.price);
  }

  factory Holding.neo(Prices price, Balances balance) {
    return new Holding(
        name: 'Neo', amount: balance.neo, usdPerCoin: price.neo.price);
  }

  factory Holding.gas(Prices price, Balances balance) {
    return new Holding(
        name: 'Gas', amount: balance.gas, usdPerCoin: price.gas.price);
  }
}
