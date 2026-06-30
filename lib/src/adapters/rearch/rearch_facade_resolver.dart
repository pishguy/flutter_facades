import '../../core/exceptions.dart';
import '../../core/service_resolver.dart';

typedef RearchServiceReader<T> = T Function();

class RearchFacadeResolver implements ServiceResolver {
  RearchFacadeResolver({
    Map<Type, RearchServiceReader<dynamic>> readers = const {},
  }) : _readers = Map<Type, RearchServiceReader<dynamic>>.from(readers);

  final Map<Type, RearchServiceReader<dynamic>> _readers;

  void register<T>(RearchServiceReader<T> reader) {
    _readers[T] = reader;
  }

  bool contains<T>() {
    return _readers.containsKey(T);
  }

  void unregister<T>() {
    _readers.remove(T);
  }

  void reset() {
    _readers.clear();
  }

  @override
  T resolve<T>() {
    final reader = _readers[T];

    if (reader == null) {
      throw BindingNotFoundException(T);
    }

    final value = reader();

    if (value is T) {
      return value;
    }

    throw InvalidBindingTypeException(
      expected: T,
      actual: value,
    );
  }
}
