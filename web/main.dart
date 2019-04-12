import 'package:angular/angular.dart';

import 'package:http/browser_client.dart';

import 'package:addressfolio/app_component.dart';
import 'package:addressfolio/src/accessor/fetcher.dart';

final client = new BrowserClient();

final fetcher = new Fetcher(client, '6F8UYZ5R8CKMNUUYM2RAQW59AGNBXZX5P4');

main() async {
  bootstrap(AppComponent);
}
