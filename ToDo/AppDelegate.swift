//
//  AppDelegate.swift
//  ToDo
//
//  Created by Yusuf ali cezik on 10.04.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
       
        //realm kaydettiği adresi bulup /Userstan itibaren kopyalayıp realm browserdan açmak için
      print("real",Realm.Configuration.defaultConfiguration.fileURL!)
        
    
        //Realm için;
        do{
            
            _ = try Realm()
        }catch{
            print("Error realm")
        }
         return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }



}

