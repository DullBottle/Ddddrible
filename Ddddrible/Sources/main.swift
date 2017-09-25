//
//  main.swift
//  Ddddrible
//
//  Created by __End on 2017/9/23.
//  Copyright © 2017年 Dressrose. All rights reserved.
//

import UIKit

private func appDelegateClassName() -> String {
    let isTesting = NSClassFromString("XCTestCase") != nil
    Bundle.main.object(forInfoDictionaryKey: "")
    return isTesting ? "DdddribleTests.StubAppDelegate" : NSStringFromClass(AppDelegate.self)
}

UIApplicationMain(CommandLine.argc,
                  UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc)),
                  NSStringFromClass(AppDelegate.self),
                  appDelegateClassName())

