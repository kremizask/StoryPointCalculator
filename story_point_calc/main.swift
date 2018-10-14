//
//  main.swift
//  story_point_calc
//
//  Created by Kostas Kremizas on 23/09/2018.
//  Copyright © 2018 kremizas. All rights reserved.
//

import Foundation
import UIKit

let testTarget = "story_point_calcTests"
let appDelegateClass: AnyClass = NSClassFromString("\(testTarget).TestingAppDelegate") ?? AppDelegate.self

let appDelegateClassString = NSStringFromClass(appDelegateClass)

UIApplicationMain(CommandLine.argc,
                  CommandLine.unsafeArgv,
                  nil,
                  appDelegateClassString)
