import 'package:flutter_facades/flutter_facades.dart';

Future<void> main() async {
  final container = SimpleContainer();

  final provider = DefaultFacadeServiceProvider(
    config: {
      'app.name': 'Demo App',
      'api.base_url': 'https://api.example.com',
    },
  );

  provider.register(container);
  await provider.boot(container);

  FacadeRuntime.setRootResolver(container);

  await Cache.put('token', 'abc');

  final tokenFromFacade = await Cache.get<String>('token');
  final tokenFromHelper = await cache().get<String>('token');

  Log.info('Token loaded', context: {
    'facade_token': tokenFromFacade,
    'helper_token': tokenFromHelper,
  });

  final appName = Config.get<String>('app.name');

  Log.info('App name is $appName');
}
