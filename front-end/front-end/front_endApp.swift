//
//  front_endApp.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/20/22.
//


import SwiftUI
import Firebase

@main
struct front_endApp: App {
    @StateObject var router = Router()
    @StateObject var hasLoaded = HasLoaded()
    @StateObject var userInfo = UserInfo.instance
    @StateObject var cache = Cache.instance
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(hasLoaded)
                .environmentObject(userInfo)
                .environmentObject(cache)
                .environmentObject(router)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate{
    
    let gcmMessageIDKey = "gcm.message_id"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self

        
        // register for remote notifications
        let authOptions: UNAuthorizationOptions = [[.alert, .badge, .sound]]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()
        
        return true
    }
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
      -> UIBackgroundFetchResult {


      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      return UIBackgroundFetchResult.newData
    }
    
    func application(_ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("errorbaby")
    }
    
}

extension AppDelegate: MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        
        UserInfo.instance.token = dataDict["token"]!
        
        print(dataDict)
        
    }
    
   
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
    let userInfo = notification.request.content.userInfo

    print(userInfo)

    // Change this to your preferred presentation option
    return [[.banner, .badge, .sound]]
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse) async {
    let userInfo = response.notification.request.content.userInfo

    // ...

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print full message.
    print(userInfo)
  }
}


