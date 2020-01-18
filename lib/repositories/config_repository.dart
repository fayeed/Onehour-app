import 'package:firebase_remote_config/firebase_remote_config.dart';

class Config {
  Future<RemoteConfig> setupRemoteConfig() async {
    String value;

    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: false));

    remoteConfig.setDefaults(<String, dynamic>{
      'show_ads': false,
    });

    await remoteConfig.fetch(expiration: const Duration(seconds: 0));

    await remoteConfig.activateFetched();

    return remoteConfig;
  }
}
