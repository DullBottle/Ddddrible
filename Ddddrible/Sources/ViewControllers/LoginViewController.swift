//
//  LoginViewController.swift
//  Ddddrible
//
//  Created by __End on 2017/9/26.
//  Copyright © 2017年 Dressrose. All rights reserved.
//

import UIKit
import ReactorKit
import SafariServices

typealias VoidClosure = () -> Void

final class LoginViewController: BaseViewController, View {
    
    typealias Reactor = LoginViewReactor
    
    // MARK: Constants
    
    fileprivate struct Metric {
        static let logoViewTop = 70.f
        static let logoViewSize = 225.f
        
        static let titleLabelTop = 10.f
        
        static let loginButtonLeftRight = 30.f
        static let loginButtonBottom = 40.f
        static let loginButtonHeight = 40.f
    }
    
    fileprivate struct Font {
        static let titleLabel = UIFont.boldSystemFont(ofSize: 60)
        static let loginButtonTitle = UIFont.boldSystemFont(ofSize: 15)
    }
    
    // MARK: Properties.

    fileprivate let presentMainScreen: VoidClosure
    
    // MARK: UI.
    let logoView = UIImageView(image: #imageLiteral(resourceName: "Icon512"))
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ddddrible"
        label.font = Font.titleLabel
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = Font.loginButtonTitle
        button.setTitle("Login", for: .normal)
        button.setBackgroundImage(UIImage.resizable().color(0xFF2719.color).corner(radius: 3).image, for: .normal)
        button.setBackgroundImage(UIImage.resizable().color(0xC32116.color).corner(radius: 3).image, for: .highlighted)
        return button
    }()
    
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    // MARK: Initializing.
    
    init(reactor: Reactor, presentMainScreen: @escaping VoidClosure) {
        defer { self.reactor = reactor }
        self.presentMainScreen = presentMainScreen
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure.
    
    func bind(reactor: LoginViewController.Reactor) {
        //
        // Input.
        //
        self.loginButton.rx.tap
            .map { Reactor.Action.login }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //
        // Output.
        //
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.loginButton.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLogin }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
            self?.presentMainScreen()
        }).disposed(by: self.disposeBag)
    }
}

























