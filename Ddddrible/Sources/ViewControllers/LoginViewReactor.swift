//
//  LoginViewReactor.swift
//  Ddddrible
//
//  Created by __End on 2017/9/26.
//  Copyright © 2017年 Dressrose. All rights reserved.
//

import ReactorKit
import RxSwift
import RxCocoa

final class LoginViewReactor: Reactor {
    
    enum Action {
        case login
    }

    enum Mutation {
        case setLoading(Bool)
        case setLogin(Bool)
    }
    
    struct State {
        var isLoading: Bool = false
        var isLogin: Bool = false
    }
    
    // MARK: Properties.
    
    let initialState: State =  State()
    
    fileprivate let authService: AuthServiceType
    fileprivate let userService: UserServiceType
    
    init(authService: AuthServiceType, userService: UserServiceType) {
        self.authService = authService
        self.userService = userService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .login:
            let setLoading: Observable<Mutation> = Observable.just(Mutation.setLoading(true))
            let setLogin: Observable<Mutation> = self.authService.authorize()
                .asObservable()
                .flatMap { self.userService.fetchMe() }
                .map { true }
                .catchErrorJustReturn(false)
                .map(Mutation.setLogin)
            return setLoading.concat(setLogin)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var state = state
        switch mutation {
        case .setLoading(let isLoading):
            state.isLoading = isLoading
            return state
            
        case .setLogin(let isLogin):
            state.isLogin = isLogin
            return state
        }
    }
    
}


