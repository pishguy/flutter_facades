## Flutter Facades

**Flutter Facades** یک سیستم Facade و Helper شبیه لاراول برای Flutter/Dart است. با استفاده از این کتابخانه می‌توانید به سرویس‌های عمومی اپلیکیشن مثل **Cache**، **Auth**، **Http**، **Log** و **Config** با API ساده‌ای مثل `Cache.get()` یا `cache().get()` دسترسی داشته باشید.

پشت صحنه این API به یک **IoC Container / Service Resolver** وصل است، پس implementationها قابل تعویض، قابل mock، قابل تست و قابل اتصال به backendهایی مثل Rearch هستند.

<div align="center">
  <a href="README.md">English</a> | <strong>فارسی</strong>
</div>

---

> **⚠️ اطلاعیه Alpha:** Flutter Facades در حال توسعه فعال است. API ممکن است تغییر کند. برای محیط Production توصیه نمی‌شود.

## مشکل این کتابخانه چه چیزی را حل می‌کند؟

- **دسترسی پراکنده به سرویس‌ها** — روش یکپارچه برای دسترسی به سرویس‌ها در سراسر اپلیکیشن وجود ندارد
- **boilerplate زیاد** — عبور دادن وابستگی‌ها از طریق constructorها، widget tree یا DI دستی
- **singletonهای تست‌ناپذیر** — state سراسری که در تست نمی‌توان آن را mock کرد
- **وابستگی service layer به widget tree** — نیاز به `BuildContext` فقط برای دسترسی به یک سرویس

## ویژگی‌ها

- **Facadeهای شبیه لاراول** — `Cache.get()`، `Config.get()`، `Log.info()`، `Http.get()`، `Auth.check()`
- **توابع کمکی** — `cache()`، `config()`، `logger()`، `http()`، `auth()` به عنوان جایگزین کوتاه‌تر
- **Service Container** — `SimpleContainer` با bindingهای transient، singleton و instance، به همراه child containerهای محدوده‌ای
- **Zone-aware Runtime** — پشتیبانی از resolverهای محدوده‌ای (request-level) با استفاده از Dart Zones
- **5 قرارداد (Contract)** — `AppConfig`، `AppHttpClient`، `AppLogger`، `AuthManager`، `CacheStore`، `AppUser`
- **5 پیاده‌سازی پیش‌فرض** — آماده کار: `MapConfig`، `ConsoleLogger`، `MemoryCacheStore`، `NullAuthManager`، `ThrowingHttpClient`
- **ارائه‌دهنده پیش‌فرض** — `DefaultFacadeServiceProvider` همه پیش‌فرض‌ها را یکجا ثبت می‌کند
- **سازگاری با Rearch** — `RearchFacadeResolver` و `RearchFacadeBootstrap` برای اپلیکیشن‌هایی که از Rearch استفاده می‌کنند
- **بدون وابستگی** — Dart خالص، بدون وابستگی runtime، قابل استفاده در هر پروژه Flutter یا Dart

---

## نصب

```yaml
dependencies:
  flutter_facades: ^0.1.0
```

```dart
import 'package:flutter_facades/flutter_facades.dart';
```

---

## شروع سریع

```dart
import 'package:flutter_facades/flutter_facades.dart';

void main() {
  // 1. ایجاد service container
  final container = SimpleContainer();

  // 2. ثبت provider پیش‌فرض
  final provider = DefaultFacadeServiceProvider(config: {
    'app.name': 'MyApp',
    'api.base_url': 'https://api.example.com',
  });
  provider.register(container);
  provider.boot(container);

  // 3. تنظیم root resolver
  FacadeRuntime.setRootResolver(container);

  // 4. استفاده از facadeها در هر جای کد!
  Cache.put('user_id', 42);
  print(Cache.get<int>('user_id')); // 42

  Log.info('Application started', context: {'version': '1.0.0'});
  print(Config.get<String>('app.name')); // MyApp
}
```

---

## Facadeهای موجود

| Facade   | تابع کمکی  | Contract          | پیاده‌سازی پیش‌فرض    |
|----------|-----------|-------------------|----------------------|
| `Auth`   | `auth()`  | `AuthManager`     | `NullAuthManager`    |
| `Cache`  | `cache()` | `CacheStore`      | `MemoryCacheStore`   |
| `Config` | `config()`| `AppConfig`       | `MapConfig`          |
| `Http`   | `http()`  | `AppHttpClient`   | `ThrowingHttpClient` |
| `Log`    | `logger()`| `AppLogger`       | `ConsoleLogger`      |

هر facade هم متدهای استاتیک و هم دسترسی مستقیم به سرویس زیرین را فراهم می‌کند:

```dart
Cache.put('key', value);      // متد استاتیک facade
cache().put('key', value);    // تابع کمکی
Cache.store.put('key', value); // دسترسی مستقیم به سرویس
```

---

## قراردادها (Contracts)

| Contract | کاربرد | متدهای کلیدی |
|----------|-------|-------------|
| `AppConfig` | دسترسی نوع-safe به تنظیمات | `get<T>(key)`، `getOrNull<T>(key)`، `has(key)` |
| `AppHttpClient` | HTTP client انتزاعی | `get()`، `post()`، `put()`، `delete()` |
| `AppLogger` | لاگینگ ساختاریافته | `debug()`، `info()`، `warning()`، `error()` |
| `AuthManager` | چرخه حیات احراز هویت | `check`، `user`، `token`، `attempt()`، `logout()` |
| `CacheStore` | کش عمومی با پشتیبانی TTL | `get()`، `put()`، `forget()`، `has()`، `flush()`، `remember()` |
| `AppUser` | مدل کاربر ساده | `id`، `name`، `email`، `extra` |

---

## پیاده‌سازی سفارشی

هر قراردادی را پیاده‌سازی کنید و ثبت کنید:

```dart
container.instance<AppLogger>(MyCloudLogger());

// حالا Log.info() به لاگ ابری شما می‌فرستد
Log.info('This goes to the cloud!', context: {'env': 'production'});
```

سه حالت binding در `SimpleContainer`:

```dart
container.bind<CacheStore>((c) => MyCache());       // نمونه جدید هر بار
container.singleton<CacheStore>((c) => MyCache());   // singleton تنبل
container.instance<CacheStore>(MyCache());            // نمونه آماده
```

---

## Resolverهای محدوده‌ای (Zones)

با `FacadeRuntime.runWithResolver` محدوده‌های request-level ایجاد کنید:

```dart
void handleRequest(Request request) {
  final scope = container.scope();
  scope.instance<AppConfig>(RequestConfig(request));

  FacadeRuntime.runWithResolver(scope, () {
    // در این محدوده، Config.get() تنظیمات سطح request را می‌خواند
    // در بیرون، به root resolver برمی‌گردد
    processRequest();
  });
}
```

---

## یکپارچگی با Rearch

برای اپلیکیشن‌هایی که از [Rearch](https://pub.dev/packages/rearch) استفاده می‌کنند:

```dart
RearchFacadeBootstrap.setAsRoot(
  cache: () => cacheCapsule(read, myContainer),
  logger: () => loggerCapsule(read, myContainer),
  config: () => configCapsule(read, myContainer),
  auth: () => authCapsule(read, myContainer),
  http: () => httpCapsule(read, myContainer),
);
```

این کار یک `RearchFacadeResolver` می‌سازد، هر پنج reader را ثبت می‌کند و آن را به عنوان root resolver تنظیم می‌کند.

---

## معماری

```
                        کد کاربر
                           |
            +--------------+--------------+
            |              |              |
       کلاس‌های Facade   توابع کمکی    resolve مستقیم
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
  (ظرف DI)            (سازگار با Rearch)
         |                   |
  provider پیش‌فرض    capsuleهای Rearch
  (5 پیاده‌سازی        (تعریف شده توسط
   آماده)              کاربر)
```

---

## تست

Flutter Facades تست را ساده می‌کند — پیاده‌سازی واقعی را با mock عوض کنید:

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
  final mockAuth = MockAuthManager();
  final container = SimpleContainer()
    ..instance<AuthManager>(mockAuth);
  FacadeRuntime.setRootResolver(container);

  expect(Auth.check, false);

  FacadeRuntime.reset();
});
```

---

## مجوز

MIT
