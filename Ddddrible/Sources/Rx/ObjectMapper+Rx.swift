//
//  ObjectMapper+Rx.swift
//  Ddddrible
//
//  Created by __End on 2017/9/26.
//  Copyright © 2017年 Dressrose. All rights reserved.
//

import Moya
import ObjectMapper
import RxSwift

extension ObservableType where E == Moya.Response {

    /// `map() -> Object.self`
    func map<T: ImmutableMappable>(_ mappableType: T.Type) -> Observable<T> {
        return self.mapString().map({ (JSONString) -> T in
            return try Mapper<T>().map(JSONString: JSONString)
        }).do(onError: { error in
            if error is MapError {
                logger.log("\(error)")
            }
        })
    }
    
    /// `map() -> [Object.self]`
    func map<T: ImmutableMappable>(_ mappableType: [T].Type) -> Observable<[T]> {
        return self.mapString().map({ (JSONString) -> [T] in
            return try Mapper<T>().mapArray(JSONString: JSONString)
        }).do(onError: { error in
            if error is MapError {
                logger.log("\(error)")
            }
        })
    }
    
    /// `map() -> List<T>` to find the `nextURL`
    func map<T: ImmutableMappable>(_ mappableType: List<T>.Type) -> Observable<List<T>> {
        return self.map({ (response) -> List<T> in
            let JSONString = try response.mapString()
            let items = try Mapper<T>().mapArray(JSONString: JSONString)
            let nextURL = (response.response as? HTTPURLResponse)?
                .findLink(relation: "next")
                .flatMap({ URL(string: $0.uri) })
            return List(items: items, nextURL: nextURL)
        }).do(onError: { error in
            if error is MapError {
                logger.log("\(error)")
            }
        })
    }
    
}







