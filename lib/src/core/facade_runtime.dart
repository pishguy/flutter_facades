import 'dart:async';

import 'exceptions.dart';
import 'service_resolver.dart';

class FacadeRuntime {
  FacadeRuntime._();

  static final Object _zoneResolverKey = Object();

  static ServiceResolver? _rootResolver;

  static void setRootResolver(ServiceResolver resolver) {
    _rootResolver = resolver;
  }

  static bool get hasRootResolver {
    return _rootResolver != null;
  }

  static ServiceResolver get currentResolver {
    final scopedResolver = Zone.current[_zoneResolverKey] as ServiceResolver?;

    if (scopedResolver != null) {
      return scopedResolver;
    }

    final rootResolver = _rootResolver;

    if (rootResolver != null) {
      return rootResolver;
    }

    throw const ResolverNotConfiguredException();
  }

  static T resolve<T>() {
    return currentResolver.resolve<T>();
  }

  static R runWithResolver<R>(
    ServiceResolver resolver,
    R Function() body,
  ) {
    return runZoned(
      body,
      zoneValues: {
        _zoneResolverKey: resolver,
      },
    );
  }

  static Future<R> runWithResolverAsync<R>(
    ServiceResolver resolver,
    Future<R> Function() body,
  ) {
    return runZoned(
      body,
      zoneValues: {
        _zoneResolverKey: resolver,
      },
    );
  }

  static void reset() {
    _rootResolver = null;
  }
}
