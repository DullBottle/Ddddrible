//
//  UserService.swift
//  Ddddrible
//
//  Created by __End on 2017/9/25.
//  Copyright © 2017年 Dressrose. All rights reserved.
//

import RxSwift

protocol UserServiceType {
    
    var currentUser: Observable<User?> { get }
    
    func fetchMe() -> Single<Void>
}

final class UserService: UserServiceType {
    
    fileprivate let networking: DdddribleNetworking
    
    fileprivate let userSubject = ReplaySubject<User?>.create(bufferSize: 1)
    
    lazy var currentUser: Observable<User?> = self.userSubject.asObserver().startWith(nil).shareReplay(1)
    
    init(networking: DdddribleNetworking) {
        self.networking = networking
    }
    
    func fetchMe() -> Single<Void> {
        return self.networking.request(.me).map(User.self).asSingle().do(onNext: { [weak self] user in
            self?.userSubject.onNext(user)
        }).map { _ in Void() }
    }
}









