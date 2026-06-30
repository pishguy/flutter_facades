# Flutter Facades

A Laravel-inspired Facade and Helper system for Dart and Flutter applications.

Access common application services like **Cache**, **Auth**, **Http**, **Log**, and **Config** through a simple, static API such as `Cache.get()` or `cache().get()`.

## The Problem This Solves

- **Scattered service access** — No consistent way to access services across your app
- **Too much boilerplate** — Passing dependencies through constructors, widget trees, or manual DI
- **Untestable singletons** — Global state that's hard to mock or replace in tests
- **Service layer coupled to widget tree** — Needing BuildContext just to access a service

## How It Works

Behind the simple facade API sits an **IoC container / Service Resolver**. Every call to `Cache.get()`, `auth()`, `Config.get()`, etc. is delegated to a registered implementation. This means:

- ✅ **Interchangeable implementations** — Swap implementations without touching your code
- ✅ **Easily mockable** — Replace real implementations with mocks in tests
- ✅ **Testable** — Your code depends on interfaces, not concrete classes
- ✅ **Rearch-compatible** — Works with Rearch capsules as a backend resolver
- ✅ **Zero dependencies** — Pure Dart, no runtime dependencies

## Quick Start

```dart
import 'package:flutter_facades/flutter_facades.dart';

void main() {
  // 1. Create a service container
  final container = SimpleContainer();

  // 2. Register the default service provider
  final provider = DefaultFacadeServiceProvider(config: {
    'app.name': 'MyApp',
    'api.base_url': 'https://api.example.com',
  });
  provider.register(container);
  provider.boot(container);

  // 3. Set the root resolver
  FacadeRuntime.setRootResolver(container);

  // 4. Use facades anywhere!
  Cache.put('user_id', 42);
  print(Cache.get('user_id')); // 42

  Log.info('Application started', context: {'version': '1.0.0'});
  print(Config.get<String>('app.name')); // MyApp
}
```

## Available Facades

| Facade   | Helper       | Contract         | Default Implementation |
|----------|-------------|------------------|------------------------|
| `Auth`   | `auth()`    | `AuthManager`    | `NullAuthManager`      |
| `Cache`  | `cache()`   | `CacheStore`     | `MemoryCacheStore`     |
| `Config` | `config()`  | `AppConfig`      | `MapConfig`            |
| `Http`   | `http()`    | `AppHttpClient`  | `ThrowingHttpClient`   |
| `Log`    | `logger()`  | `AppLogger`      | `ConsoleLogger`        |

## Custom Implementations

Implement any contract interface and register it:

```dart
container.instance<AppLogger>(MyCloudLogger());

// Now Log.info() sends to your cloud logger
```

## Contracts / Interfaces

- `AppConfig` — Type-safe config access
- `AppHttpClient` — Abstract HTTP client (get/post/put/delete)
- `AppLogger` — Structured logging with levels and context
- `AuthManager` — Auth lifecycle (login, logout, check)
- `CacheStore` — Generic cache with TTL support
- `AppUser` — Simple user model

## Testing

```dart
test('cache facade stores and retrieves values', () {
  final container = SimpleContainer()
    ..instance<CacheStore>(MemoryCacheStore());
  FacadeRuntime.setRootResolver(container);

  Cache.put('key', 'value');
  expect(Cache.get('key'), 'value');

  FacadeRuntime.reset();
});
```

## Rearch Integration

For apps using the [Rearch](https://pub.dev/packages/rearch) state management library:

```dart
RearchFacadeBootstrap.setAsRoot(
  cache: () => cacheCapsule(read, myContainer),
  logger: () => loggerCapsule(read, myContainer),
  config: () => configCapsule(read, myContainer),
  auth: () => authCapsule(read, myContainer),
  http: () => httpCapsule(read, myContainer),
);
```

## License

MIT
