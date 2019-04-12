import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../../services/service.dart';

@Component(
  selector: 'holdings',
  styleUrls: const ['holdings.css'],
  templateUrl: 'holdings.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
  ],
  providers: const [],
)
class HoldingsComponent {
  final Service service;

  HoldingsComponent(this.service);
}
