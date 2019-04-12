import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../../services/service.dart';

@Component(
  selector: 'addr-add',
  styleUrls: const ['addr_add.css'],
  templateUrl: 'addr_add.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
  ],
  providers: const [],
)
class AddrAddComponent {
  @Input()
  AddrsEditor editor;

  AddrAddComponent();

  String newAddr = '';

  final _stream = new StreamController<String>();

  @Output()
  Stream<String> get added => _stream.stream;

  add() {
    editor.add(newAddr).then((sts) {
      if(sts) {
        _stream.add(newAddr);
        newAddr = '';
      } else {
        // TODO show message
        window.alert('$newAddr is not a valid ${editor.coinName} address!');
      }
    });
  }
}
