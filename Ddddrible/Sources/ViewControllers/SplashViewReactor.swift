//
//  SplashViewReactor.swift
//  Ddddrible
//
//  Created by __End on 2017/9/25.
//  Copyright © 2017年 Dressrose. All rights reserved.
//

import ReactorKit
import RxSwift
import RxCocoa

final class SplashViewReactor: Reactor {

    enum Action {
        case checkIfAuthenticated
    }
    
    enum Mutation {
        case setAuthenticated(Bool)
    }
    
    struct State {
        var isAuthenticated: Bool?
    }
    
    let initialState = State()
    
    init() {
        
    }
    
    
    
}


