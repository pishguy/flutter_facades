## Flutter Facades

**Flutter Facades** is a Laravel-inspired Facade and Helper system for Dart and Flutter. It provides a clean, static API for accessing common application services like **Cache**, **Auth**, **Http**, **Log**, and **Config** — without passing dependencies through constructors or widget trees.

Behind the scenes, every facade call routes through an **IoC container / Service Resolver**, so implementations are fully swappable, mockable, and testable.

<div align="center">
  <strong>English</strong> | <a href="README.fa.md">فارسی</a>
</div>

---

> **⚠️ Alpha Notice:** Flutter Facades is under active development. The API may change. Not recommended for production use.

## The Problem This Solves

- **Scattered service access** — No consistent way to access services across your app
- **Too much boilerplate** — Passing dependencies through constructors, widget trees, or manual DI
- **Untestable singletons** — Global state that's hard to mock or replace in tests
- **Service layer coupled to widget tree** — Needing `BuildContext` just to access a service

## Features

- **Laravel-style Facades** — `Cache.get()`, `Config.get()`, `Log.info()`, `Http.get()`, `Auth.check()`
- **Helper Functions** — `cache()`, `config()`, `logger()`, `http()`, `auth()` as shorthand alternatives
- **Service Container** — `SimpleContainer` with transient, singleton, and instance bindings, plus scoped child containers
- **Zone-aware Runtime** — `FacadeRuntime` supports request-level scoped resolvers via Dart Zones
- **5 Contracts** — `AppConfig`, `AppHttpClient`, `AppLogger`, `AuthManager`, `CacheStore`, `AppUser`
- **5 Default Implementations** — Work out of the box: `MapConfig`, `ConsoleLogger`, `MemoryCacheStore`, `NullAuthManager`, `ThrowingHttpClient`
- **Default Provider** — `DefaultFacadeServiceProvider` registers all defaults at once
- **Rearch Adapter** — `RearchFacadeResolver` and `RearchFacadeBootstrap` for apps using Rearch capsules
- **Zero Dependencies** — Pure Dart, no runtime dependencies, works with any Flutter or Dart project

---

## Getting Started

### Add dependency

```yaml
dependencies:
  flutter_facades: ^0.1.0
```

### Import

```dart
import 'package:flutter_facades/flutter_facades.dart';
```

---

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
  print(Cache.get<int>('user_id')); // 42

  Log.info('Application started', context: {'version': '1.0.0'});
  print(Config.get<String>('app.name')); // MyApp
}
```

---

## Available Facades

| Facade   | Helper       | Contract         | Default Implementation |
|----------|-------------|------------------|------------------------|
| `Auth`   | `auth()`    | `AuthManager`    | `NullAuthManager`      |
| `Cache`  | `cache()`   | `CacheStore`     | `MemoryCacheStore`     |
| `Config` | `config()`  | `AppConfig`      | `MapConfig`            |
| `Http`   | `http()`    | `AppHttpClient`  | `ThrowingHttpClient`   |
| `Log`    | `logger()`  | `AppLogger`      | `ConsoleLogger`        |

Each facade exposes both static methods and the underlying service:

```dart
Cache.put('key', value);      // Facade static method
cache().put('key', value);    // Helper function
Cache.store.put('key', value); // Direct access to the service
```

---

## Contracts / Interfaces

| Contract | Purpose | Key Methods |
|----------|---------|-------------|
| `AppConfig` | Type-safe config access | `get<T>(key)`, `getOrNull<T>(key)`, `has(key)` |
| `AppHttpClient` | Abstract HTTP client | `get()`, `post()`, `put()`, `delete()` |
| `AppLogger` | Structured logging | `debug()`, `info()`, `warning()`, `error()` |
| `AuthManager` | Auth lifecycle | `check`, `user`, `token`, `attempt()`, `logout()` |
| `CacheStore` | Generic cache with TTL | `get()`, `put()`, `forget()`, `has()`, `flush()`, `remember()` |
| `AppUser` | Simple user model | `id`, `name`, `email`, `extra` |

---

## Custom Implementations

Implement any contract and register it:

```dart
container.instance<AppLogger>(MyCloudLogger());

// Now Log.info() sends to your cloud logger
Log.info('This goes to the cloud!', context: {'env': 'production'});
```

With `SimpleContainer`, you have three binding modes:

```dart
container.bind<CacheStore>((c) => MyCache());       // New instance each time
container.singleton<CacheStore>((c) => MyCache());   // Lazy singleton
container.instance<CacheStore>(MyCache());            // Pre-built instance
```

---

## Scoped Resolvers (Zones)

Use `FacadeRuntime.runWithResolver` to create request-level scopes:

```dart
void handleRequest(Request request) {
  final scope = container.scope();
  scope.instance<AppConfig>(RequestConfig(request));

  FacadeRuntime.runWithResolver(scope, () {
    // Inside this scope, Config.get() reads request-level config
    // Outside, it falls back to the root resolver
    processRequest();
  });
}
```

---

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

This creates a `RearchFacadeResolver`, registers all five readers, and sets it as the root resolver in one call.

---

## Architecture

```
                        User Code
                           |
            +--------------+--------------+
            |              |              |
       Facade Classes   Helper Fns    Direct resolve
       (Auth, Cache,    (auth(),       (app<T>())
        Config, Http,    cache(),
        Log)             config(),
                         http(),
                         logger())
            |              |              |
            +------+-------+--------------+
                   |
          FacadeRuntime.resolve<T>()
            (zone-aware static)
                   |
         +---------+---------+
         |                   |
  SimpleContainer     RearchFacadeResolver
  (DI container)      (Rearch adapter)
         |                   |
    Default provider    Rearch capsules
    (5 out-of-box       (user-defined)
     implementations)
```

---

## Testing

Flutter Facades makes testing straightforward — swap real implementations with mocks:

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

```dart
test('mock auth', () {
  final mockAuth = MockAuthManager(); // Your mock
  final container = SimpleContainer()
    ..instance<AuthManager>(mockAuth);
  FacadeRuntime.setRootResolver(container);

  expect(Auth.check, false);

  FacadeRuntime.reset();
});
```

---

## License

MIT
