import 'simple_container.dart';

abstract class ServiceProvider {
  void register(SimpleContainer container);

  Future<void> boot(SimpleContainer container) async {}
}
