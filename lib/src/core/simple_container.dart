import 'exceptions.dart';
import 'service_resolver.dart';

typedef ServiceFactory<T> = T Function(SimpleContainer container);

class SimpleContainer implements ServiceResolver {
  SimpleContainer({SimpleContainer? parent}) : _parent = parent;

  final SimpleContainer? _parent;

  final Map<Type, ServiceFactory<dynamic>> _factories = {};
  final Map<Type, ServiceFactory<dynamic>> _singletonFactories = {};
  final Map<Type, dynamic> _singletonInstances = {};
  final Map<Type, dynamic> _instances = {};

  void bind<T>(ServiceFactory<T> factory) {
    _factories[T] = factory;

    _singletonFactories.remove(T);
    _singletonInstances.remove(T);
    _instances.remove(T);
  }

  void singleton<T>(ServiceFactory<T> factory) {
    _singletonFactories[T] = factory;

    _factories.remove(T);
    _singletonInstances.remove(T);
    _instances.remove(T);
  }

  void instance<T>(T value) {
    _instances[T] = value;

    _factories.remove(T);
    _singletonFactories.remove(T);
    _singletonInstances.remove(T);
  }

  bool contains<T>() {
    return _instances.containsKey(T) ||
        _singletonInstances.containsKey(T) ||
        _singletonFactories.containsKey(T) ||
        _factories.containsKey(T) ||
        (_parent?.contains<T>() ?? false);
  }

  @override
  T resolve<T>() {
    final type = T;

    if (_instances.containsKey(type)) {
      return _instances[type] as T;
    }

    if (_singletonInstances.containsKey(type)) {
      return _singletonInstances[type] as T;
    }

    if (_singletonFactories.containsKey(type)) {
      final factory = _singletonFactories[type] as ServiceFactory<T>;
      final value = factory(this);
      _singletonInstances[type] = value;
      return value;
    }

    if (_factories.containsKey(type)) {
      final factory = _factories[type] as ServiceFactory<T>;
      return factory(this);
    }

    if (_parent != null) {
      return _parent!.resolve<T>();
    }

    throw BindingNotFoundException(type);
  }

  SimpleContainer scope() {
    return SimpleContainer(parent: this);
  }

  void reset<T>() {
    final type = T;

    _factories.remove(type);
    _singletonFactories.remove(type);
    _singletonInstances.remove(type);
    _instances.remove(type);
  }

  void resetAll() {
    _factories.clear();
    _singletonFactories.clear();
    _singletonInstances.clear();
    _instances.clear();
  }
}
