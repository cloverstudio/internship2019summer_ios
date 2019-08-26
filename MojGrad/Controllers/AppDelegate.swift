//
//  AppDelegate.swift
//  MojGrad
//
//  Created by Ja on 29/07/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMaps
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        
        GMSServices.provideAPIKey("sAIzaSyBCJZPC-fvpqUfL-iV392Dr90dfTSptLqo")
        
        if UserDefaults.standard.bool(forKey: Keys.rememberMe) {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            if UserDefaults.standard.integer(forKey: Keys.personRoleId) == 1 {
                let vc = storyboard.instantiateViewController(withIdentifier: "UserTabBarController")
                self.window?.rootViewController = vc
            } else if UserDefaults.standard.integer(forKey: Keys.personRoleId) == 2 {
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AdminTabBarController")//AdminTabBarController
                self.window?.rootViewController = vc
            }
        } else if UserDefaults.standard.bool(forKey: Keys.rememberMe) == false{
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            self.window?.rootViewController = vc
        }
       
//        Realm.Configuration.defaultConfiguration = Realm.Configuration(
//            schemaVersion: 1,
//            migrationBlock: { migration, oldSchemaVersion in
//                if (oldSchemaVersion < 1) {
//                    //write the migration logic here
//                }
//        })
        
//        print(Realm.Configuration.defaultConfiguration.fileURL)
//
//
//        let rel = RealmManager()
//
//        do {
//            let realm = try Realm()
//        } catch {
//            print("Error initialising new realm, \(error)")
//        }
        
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

