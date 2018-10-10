//
//  AppDelegate.swift
//  story_point_calc
//
//  Created by Kostas Kremizas on 23/09/2018.
//  Copyright © 2018 kremizas. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let viewModel = Dependencies.makeViewModel()
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
        viewController.configure(viewModel)
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        return true
    }
}

