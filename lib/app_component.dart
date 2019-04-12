import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'src/components/basket_editor/basket_editor.dart';
import 'src/components/holdings/holdings.dart';
import 'src/services/service.dart';

@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
    BasketComponent,
    HoldingsComponent
  ],
  providers: const [materialProviders, Service],
)
class AppComponent {
  final Service service;

  AppComponent(this.service);
  // Nothing here yet. All logic is in TodoListComponent.
}
