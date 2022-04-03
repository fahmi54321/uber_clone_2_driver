import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    [GMSServices provideAPIKey:@"AIzaSyDI4X-fug0yawUaQ0I4xeNUXmaSRxlb5B8"];
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
