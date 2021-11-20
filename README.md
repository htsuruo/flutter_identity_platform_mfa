# flutter_identity_platform_mfa

## Setup

1. 下記を参考にFirebaseのConfigurationファイルを設定します。
- [iOS Installation | FlutterFire](https://firebase.flutter.dev/docs/installation/ios#installing-your-firebase-configuration-file)
- [Android Installation | FlutterFire](https://firebase.flutter.dev/docs/installation/android#installing-your-firebase-configuration-file)

2. APIキーを`--dart-define`で渡します。
- `API_KEY`という名前でAPIキーをセットしています。
- ref. https://github.com/HTsuruo/flutter_identity_platform_mfa/blob/5ce1af9f6463f50af3600bd7f8f0e0a7bdd4cfd8/lib/gcloud_api_client.dart#L21