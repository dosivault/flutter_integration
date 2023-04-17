# The issue

1. If we use `url_launcher` plugin to open an url, it will open a webview with a preview page (I don't know why).
2. And then user click the open button on the preview web page, the dynamic link's translated to something else (I don't know why either)

# The solution

1. Must to call to native for `UIApplication.shared.open(url)` function to avoid the preview page.
2. So, we need call bridge from flutter to native, code example:

File: `ios/Runner/AppDelegate.swift`

```swift
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let openDynamicLinkChannel = FlutterMethodChannel(
        name: "open_dynamic_link",
        binaryMessenger: controller.binaryMessenger
      )
      openDynamicLinkChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          let dynamicLink = call.arguments as! String
          guard let url = URL(string: dynamicLink) else { return }
          UIApplication.shared.open(url)
      })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

File: `lib/main.dart`

```dart
Future<void> openDynamicLink(dynamicLink) async {
  try {
    await platform.invokeListMethod(
      'openDynamicLink',
      dynamicLink
    );
  } on PlatformException catch (e) {
    print("call native open url error: " + e.details);
  }
}

void _incrementCounter() {
  var dynamicLink = 'https://dosivault.page.link/muUh?uri_wc=' +
    Uri.encodeComponent(walletUri);
  print("wc url: " + dynamicLink);
  openDynamicLink(dynamicLink);
}
```