import UIKit
import Flutter

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
