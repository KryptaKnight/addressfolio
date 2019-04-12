import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../addr_add/addr_add.dart';
import '../addr_list/addr_list.dart';

import '../../services/service.dart';

@Component(
  selector: 'addrs-view',
  styleUrls: const ['addrs_view.css'],
  templateUrl: 'addr_view.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
    AddrAddComponent,
    AddrListComponent,
  ],
  providers: const [],
)
class AddrsViewComponent {
  AddrsViewComponent();

  @Input()
  AddrsEditor editor;

  void add(String addr) {
    editor.add(addr);
  }
}
