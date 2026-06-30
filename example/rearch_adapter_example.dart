import 'package:flutter_facades/flutter_facades.dart';

// This is a conceptual example. In a real project, you would use
// the actual Rearch API to read from capsules.

CacheStore cacheCapsule(dynamic use) {
  return MemoryCacheStore();
}

AppLogger loggerCapsule(dynamic use) {
  return ConsoleLogger();
}

AppConfig configCapsule(dynamic use) {
  return const MapConfig({
    'app.name': 'Rearch Demo App',
    'api.base_url': 'https://api.example.com',
  });
}

AuthManager authCapsule(dynamic use) {
  return NullAuthManager();
}

AppHttpClient httpCapsule(dynamic use) {
  return ThrowingHttpClient();
}

Future<void> main() async {
  // This object would be created with the actual Rearch API.
  // For this example, we simulate it.
  final rearchContainer = Object();

  // In a real project, you would use something like:
  // rearchContainer.read(cacheCapsule)
  // or
  // rearchContainer(cacheCapsule)
  // depending on the Rearch API version.

  RearchFacadeBootstrap.setAsRoot(
    cache: () {
      // In real code: return rearchContainer.read(cacheCapsule);
      return cacheCapsule(rearchContainer);
    },
    auth: () {
      // In real code: return rearchContainer.read(authCapsule);
      return authCapsule(rearchContainer);
    },
    http: () {
      // In real code: return rearchContainer.read(httpCapsule);
      return httpCapsule(rearchContainer);
    },
    logger: () {
      // In real code: return rearchContainer.read(loggerCapsule);
      return loggerCapsule(rearchContainer);
    },
    config: () {
      // In real code: return rearchContainer.read(configCapsule);
      return configCapsule(rearchContainer);
    },
  );

  await Cache.put('token', 'abc');

  final token = await cache().get<String>('token');

  Log.info('Token loaded from Rearch-backed resolver', context: {
    'token': token,
  });
}
