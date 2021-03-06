import UIKit
import Flutter
import Firebase
import FBSDKCoreKit
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
//     didRegisterForRemoteNotificationWithDeviceToken deviceToken : Data
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//       Messaging.messaging().apnsToken=deviceToken
    GeneratedPluginRegistrant.register(with: self)
    AppEvents.shared.activateApp()


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    override  func application(
             _ app: UIApplication,
             open url: URL,
             options: [UIApplication.OpenURLOptionsKey : Any] = [:]
         ) -> Bool {

             ApplicationDelegate.shared.application(
                 app,
                 open: url,
                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                 annotation: options[UIApplication.OpenURLOptionsKey.annotation]
             )

         }

}


// two files of same name

//Last one is latest
