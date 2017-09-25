//
//  BaseViewController.swift
//  Ddddrible
//
//  Created by __End on 2017/9/25.
//  Copyright © 2017年 Dressrose. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    // MARK: Properties.
    
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    var automaticallyAdjustsLeftBarButtonItem = true
    
    // MARK: Initializings
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    // MARK: Rx.
    
    var disposeBag = DisposeBag()
    
    // MARK: Life Cycle.
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.automaticallyAdjustsLeftBarButtonItem {
            self.adjustLeftBarButtonItem()
        }
    }
    
    private(set) var didSetupConstraints = false
    
    // MARK: Layout Constraints.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            self.setupConstraints()
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func setupConstraints() {
        // Override point
    }
    
    
    // MARK: Adjusting Navigation Item
    
    func adjustLeftBarButtonItem() {
        if self.navigationController?.viewControllers.count ?? 0 > 1 {  // pushed.
            self.navigationItem.leftBarButtonItem = nil
        } else if self.presentingViewController != nil {                // presented.
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,target: self,action: #selector(cancelButtonDidTap))
        }
    }
    
    func cancelButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
}





