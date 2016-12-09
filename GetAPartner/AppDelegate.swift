//
//  AppDelegate.swift
//  GetAPartner
//
//  Created by 游宗翰 on 2016/9/20.
//  Copyright © 2016年 han. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.2, green: 0.6039215686, blue: 0.9607843137, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        if let barFone = UIFont(name: "Menlo-Regular", size: 24){
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), NSFontAttributeName:barFone]
        }

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

// MARK:- YULog
/*
 1. 添加在 AppDelegate.swift 最下面為全域函式
 2. 在TARGETS -> Build Setting 搜尋Swift Flags
 3. Debug中添加 -D DEBUG
 */
func YULog<T>(_ messsage : T, file : String = #file, lineNum : Int = #line) {
    
    #if DEBUG
        
        let fileName = (file as NSString).lastPathComponent
        
        print("文件名:\(fileName)行數:\(lineNum) -『\(messsage)』")
        
    #endif
}
