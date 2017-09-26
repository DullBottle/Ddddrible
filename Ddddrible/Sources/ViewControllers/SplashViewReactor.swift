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
    
    fileprivate let userService: UserServiceType
    
    init(userService: UserServiceType) {
        self.userService = userService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkIfAuthenticated:
            return self.userService.fetchMe()
                .asObservable()
                .map { true }
                .catchErrorJustReturn(false)
                .map(Mutation.setAuthenticated)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setAuthenticated(let isAuthenticated):
            state.isAuthenticated = isAuthenticated
            return state
        }
    }
    
}






