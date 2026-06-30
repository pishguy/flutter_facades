## 0.1.0

- Initial release
- Core: `SimpleContainer`, `FacadeRuntime`, `ServiceProvider`
- Contracts: `AppConfig`, `AppHttpClient`, `AppLogger`, `AuthManager`, `CacheStore`, `AppUser`
- Facades: `Auth`, `Cache`, `Config`, `Http`, `Log`
- Helpers: `app<T>()`, `auth()`, `cache()`, `config()`, `http()`, `logger()`
- Implementations: `MapConfig`, `ConsoleLogger`, `MemoryCacheStore`, `NullAuthManager`, `ThrowingHttpClient`
- Default provider: `DefaultFacadeServiceProvider`
- Rearch adapter: `RearchFacadeResolver`, `RearchFacadeBootstrap`
