//
//  main.swift
//  testing_the_waters_of_ios
//
//  Created by Kostas Kremizas on 23/09/2018.
//  Copyright © 2018 kremizas. All rights reserved.
//

import Foundation
import UIKit

let testTarget = "testing_the_waters_of_iosTests"
let appDelegateClass: AnyClass = NSClassFromString("\(testTarget).TestingAppDelegate") ?? AppDelegate.self

let appDelegateClassString = NSStringFromClass(appDelegateClass)

UIApplicationMain(CommandLine.argc,
                  CommandLine.unsafeArgv,
                  nil,
                  appDelegateClassString)
