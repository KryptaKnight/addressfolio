import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../addrs_view/addrs_view.dart';

import '../../services/service.dart';

@Component(
  selector: 'basket-editor',
  styleUrls: const ['basket_editor.css'],
  templateUrl: 'basket_editor.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
    AddrsViewComponent,
  ],
  providers: const [],
)
class BasketComponent {
  final Service service;

  BasketComponent(this.service);
}
