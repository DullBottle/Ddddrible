//
//  AppDelegate.swift
//  Ddddrible
//
//  Created by __End on 2017/9/23.
//  Copyright © 2017年 Dressrose. All rights reserved.
//

import UIKit

import CGFloatLiteral
import Immutable
import Kingfisher
import ManualLayout
import SnapKit
import SwiftyColor
import SwiftyImage
import Then
import TouchAreaInsets
import URLNavigator
import WebLinking
import RxViewController

final class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties.
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // MARK: UI.
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.configureAppearance()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        
        self.window = window
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if Navigator.open(url) {
            return true
        }
        if Navigator.present(url, wrap: true) != nil {
            return true
        }
        
        return false
    }

    // MARK: Appearance.
    
    func configureAppearance() {
        let navigationBarBackgroundImage = UIImage.resizable().color(.charcoal).image
        UINavigationBar.appearance().setBackgroundImage(navigationBarBackgroundImage, for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().tintColor = .slate
        UITabBar.appearance().tintColor = .charcoal
    }
    
}


























