//
//  AppDelegate.swift
//  AudioRecorder
//
//  Created by Вадим Суходольский on 09/04/2018.
//  Copyright © 2018 Вадим Суходольский. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        RealmController.setup()
        return true
    }



}

