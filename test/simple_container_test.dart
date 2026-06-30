import 'package:test/test.dart';
import 'package:flutter_facades/flutter_facades.dart';

void main() {
  test('bind creates new instance every time', () {
    final container = SimpleContainer();

    container.bind<DateTime>((_) => DateTime.now());

    final first = container.resolve<DateTime>();
    final second = container.resolve<DateTime>();

    expect(first, isA<DateTime>());
    expect(second, isA<DateTime>());
  });

  test('singleton creates instance only once', () {
    final container = SimpleContainer();

    var count = 0;

    container.singleton<String>((_) {
      count++;
      return 'hello';
    });

    expect(container.resolve<String>(), 'hello');
    expect(container.resolve<String>(), 'hello');
    expect(count, 1);
  });

  test('instance returns registered object', () {
    final container = SimpleContainer();

    final cache = MemoryCacheStore();

    container.instance<CacheStore>(cache);

    expect(container.resolve<CacheStore>(), same(cache));
  });

  test('child scope falls back to parent', () {
    final root = SimpleContainer();
    root.instance<AppLogger>(ConsoleLogger());

    final child = root.scope();

    expect(child.resolve<AppLogger>(), isA<ConsoleLogger>());
  });

  test('child scope can override parent', () {
    final root = SimpleContainer();
    final rootCache = MemoryCacheStore();
    root.instance<CacheStore>(rootCache);

    final child = root.scope();
    final childCache = MemoryCacheStore();
    child.instance<CacheStore>(childCache);

    expect(root.resolve<CacheStore>(), same(rootCache));
    expect(child.resolve<CacheStore>(), same(childCache));
  });

  test('throws when binding not found', () {
    final container = SimpleContainer();

    expect(
      () => container.resolve<CacheStore>(),
      throwsA(isA<BindingNotFoundException>()),
    );
  });
}
