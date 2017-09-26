//
//  SplashViewController.swift
//  Ddddrible
//
//  Created by __End on 2017/9/25.
//  Copyright © 2017年 Dressrose. All rights reserved.
//

import UIKit
import ReactorKit

final class SplashViewController: BaseViewController, View {

    typealias Reactor = SplashViewReactor
    
    // MARK: Properties.
    
    private let presentLoginScreen: VoidClosure
    private let presentMainScreen: VoidClosure
    
    // MARK: UI.
    
    fileprivate let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    // MARK: Initializing.
    
    init(reactor: Reactor, presentLoginScreen: @escaping VoidClosure, presentMainScreen: @escaping VoidClosure) {
        defer { self.reactor = reactor }
        self.presentLoginScreen = presentLoginScreen
        self.presentMainScreen = presentMainScreen
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.activityIndicatorView.startAnimating()
        self.view.addSubview(self.activityIndicatorView)
    }
    
    override func setupConstraints() {
        self.activityIndicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    // MARK: Configure.
    func bind(reactor: Reactor) {
        //
        // Input.
        //
        self.rx.viewDidAppear
            .map { _ in Reactor.Action.checkIfAuthenticated }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //
        // Output.
        //
        reactor.state
            .map { $0.isAuthenticated }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isAuthenticated in
            
                if isAuthenticated {
                    self?.presentMainScreen()
                } else {
                    self?.presentLoginScreen()
                }
            
            }).disposed(by: self.disposeBag)
    }
}





