//
//  AppDelegate.swift
//  Inyore
//
//  Created by Arslan on 22/09/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import SideMenu
import IQKeyboardManagerSwift

import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.toolbarTintColor = #colorLiteral(red: 0.9568627451, green: 0.4549019608, blue: 0.1254901961, alpha: 1)
        
        Thread.sleep(forTimeInterval: 2.0)
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        if #available(iOS 10.0, *)
        {
            print("iOS 10.0 Notification Trigger")
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        }
            
        else
        {
            print("iOS 10.0 or later Notification Trigger")
            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound.default
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    //MARK:- APNS
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        
        Messaging.messaging().apnsToken = deviceToken
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Apple token : \(token)")
        UserDefaults.standard.set(token, forKey: "app_id")
    }
    
    //MARK:- Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error){
        
        print("APNs registration failed: \(error)")
    }
    
    //MARK:- FCM Token
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?){
        
        print("Firebase registration token: \(fcmToken ?? "")")
        UserDefaults.standard.set(fcmToken!, forKey: "fcm_key")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        
        print("Push notification received in foreground.")
        completionHandler([.alert, .badge, .sound])
        
        let userInfo = notification.request.content.userInfo
        let AnyHashable = userInfo["aps"] as! NSDictionary
        
        if let badge = AnyHashable["badge"] as? Int{
            
            let dict = ["badge": badge]
            NotificationCenter.default.post(name: Notification.Name("setBadge"), object: nil, userInfo: dict)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void){
        
        print(#function)
        let userInfo = response.notification.request.content.userInfo
        guard let type = userInfo["type"] as? String else{return}
        if type == "article"{
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openSingleTruth"), object: nil, userInfo: userInfo)
        }
        else{
            
            self.gotoSingleCommunity(info: userInfo)
        }
        
        completionHandler()
    }
    
    private func gotoSingleCommunity(info: [AnyHashable: Any])
    {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        guard let community_id = info["community_id"] as? String else{return}
        guard let community_title = info["community_title"] as? String else{return}

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let singleCommunityVC = storyboard.instantiateViewController(identifier: "singleCommunityVC") as! SingleCommunityViewController
        
        singleCommunityVC.community_id = Int(community_id)!
        singleCommunityVC.communityTitle = community_title
        
        let navController = UINavigationController(rootViewController: singleCommunityVC)
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .fullScreen

        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
    
    
}
