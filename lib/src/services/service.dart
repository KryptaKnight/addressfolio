import 'dart:async';

import 'package:angular/core.dart';
import 'package:http/browser_client.dart';

import '../accessor/fetcher.dart';

class AddrsEditor {
  final Service service;

  final String coinName;

  final Set<String> addrs;

  final Function onUpdate;

  AddrsEditor(this.service, this.coinName, this.addrs, this.onUpdate);

  Future<bool> add(String addr) async {
    if (addrs.contains(addr)) return false;

    if(!await validateAddr(addr)) return false;

    addrs.add(addr);

    // Trigger update
    onUpdate();

    return true;
  }

  void remove(String addr) {
    if (!addrs.contains(addr)) return;

    addrs.remove(addr);

    // Trigger update
    onUpdate();
  }

  void removeAll(List<String> addr) {
    if (!addrs.containsAll(addr)) return;

    addrs.removeAll(addr);

    // Trigger update
    onUpdate();
  }

  Future<bool> validateAddr(String addr) async {
    if(coinName == 'Ethereum') {
      try {
        await Service.fetcher.ethScan.getTokenBalanceWTC(addr);
      } catch(e) {
        // TODO Exception could be for reasons other than invalid address
        return false;
      }
      return true;
    } else if(coinName == 'Bitcoin') {
      try {
        await Service.fetcher.btcExplorer.getBalance(addr);
      } catch(e) {
        // TODO Exception could be for reasons other than invalid address
        return false;
      }
      return true;
    } else if(coinName == 'Litecoin') {
      try {
        await Service.fetcher.ltcExplorer.getBalance(addr);
      } catch(e) {
        // TODO Exception could be for reasons other than invalid address
        return false;
      }
      return true;
    } else if(coinName == 'Neo') {
      try {
        await Service.fetcher.neoExplorer.getBalance(addr);
      } catch(e) {
        // TODO Exception could be for reasons other than invalid address
        return false;
      }
      return true;
    } else if(coinName == 'Nav') {
      // TODO
    }

    throw new Exception('Unsupported coin!');
  }
}

@Injectable()
class Service {
  final Basket basket = new Basket();

  AddrsEditor _ethEditor;

  AddrsEditor get ethEditor => _ethEditor;

  AddrsEditor _btcEditor;

  AddrsEditor get btcEditor => _btcEditor;

  AddrsEditor _ltcEditor;

  AddrsEditor get ltcEditor => _ltcEditor;

  AddrsEditor _neoEditor;

  AddrsEditor get neoEditor => _neoEditor;

  AddrsEditor _navEditor;

  AddrsEditor get navEditor => _navEditor;

  LoggedInUser _user;

  LoggedInUser get user => _user;

  Service() {
    _ethEditor = new AddrsEditor(this, 'Ethereum', basket.eth, update);
    _btcEditor = new AddrsEditor(this, 'Bitcoin', basket.btc, update);
    _ltcEditor = new AddrsEditor(this, 'Litecoin', basket.ltc, update);
    _neoEditor = new AddrsEditor(this, 'Neo', basket.neo, update);
    _navEditor = new AddrsEditor(this, 'Nav', basket.nav, update);

    new Timer.periodic(new Duration(seconds: 30), (_) => update());
  }

  static final client = new BrowserClient();

  static final fetcher =
      new Fetcher(client, '6F8UYZ5R8CKMNUUYM2RAQW59AGNBXZX5P4');

  Balances _balances = new Balances();

  Balances get balances => _balances;

  Prices _prices;

  Prices get prices => _prices;

  List<Holding> _holdings = [];

  Iterable<Holding> get holdings => _holdings;

  Future update() async {
    final res = await Future.wait([fetcher.getBalance(basket), fetcher.prices]);
    _balances = res[0];
    _prices = res[1];

    final h = new List<Holding>();

    if (_balances.btc != 0) h.add(new Holding.btc(prices, balances));
    if (_balances.ltc != 0) h.add(new Holding.ltc(prices, balances));
    if (_balances.eth != 0) h.add(new Holding.eth(prices, balances));
    if (_balances.wtc != 0) h.add(new Holding.wtc(prices, balances));
    if (_balances.adex != 0) h.add(new Holding.adx(prices, balances));
    if (_balances.neo != 0) h.add(new Holding.neo(prices, balances));
    if (_balances.gas != 0) h.add(new Holding.gas(prices, balances));

    _holdings = h;
  }
}

class LoggedInUser {
  final String id;

  final String name;

  LoggedInUser(this.id, this.name);
}
