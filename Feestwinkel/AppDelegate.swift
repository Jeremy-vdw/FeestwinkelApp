//
//  AppDelegate.swift
//  Feestwinkel
//
//  Created by Jeremie Van de Walle on 20/12/17.
//  Copyright © 2017 Jeremie Van de Walle. All rights reserved.
//
import RealmSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let fwColor = UIColor(red:0.74, green:0.18, blue:0.09, alpha:1.0)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window?.tintColor = fwColor
       // let fireworkOverviewController = window!.rootViewController as! FireworkOverviewController
        //fireworkOverviewController.fireworkData = fireworkData
        let seedFileURL = Bundle.main.url(forResource: "firework", withExtension: "realm")
        let config = Realm.Configuration(fileURL: seedFileURL, readOnly: true)
        Realm.Configuration.defaultConfiguration = config
        return true
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        guard let fireworkOverviewController = window!.rootViewController as? FireworkOverviewController else {
            return
        }
        fireworkOverviewController.locationManager?.startUpdatingLocation()
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        guard let fireworkOverviewController = window!.rootViewController as? FireworkOverviewController else {
            return
        }
        fireworkOverviewController.locationManager?.stopUpdatingLocation()
    }
    



}

