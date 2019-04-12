import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'addr-list',
  styleUrls: const ['addr_list.css'],
  templateUrl: 'addr_list.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
  ],
  providers: const [],
)
class AddrListComponent {
  AddrListComponent();

  @Input()
  Set<String> addrs;

  final _stream = new StreamController<String>();

  @Output()
  Stream<String> get removed => _stream.stream;

  void remove(String addr) {
    _stream.add(addr);
  }
}
