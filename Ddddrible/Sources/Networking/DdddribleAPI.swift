//
//  DdddribleAPI.swift
//  Ddddrible
//
//  Created by __End on 2017/9/25.
//  Copyright © 2017年 Dressrose. All rights reserved.
//

import Moya
import MoyaSugar

enum DdddribleAPI {
    case url(URL)
    
    case me
    case shots
    case shot(id: Int)
    case isLikeShot(id: Int)
    case likeShot(id: Int)
    case unlikeShot(id: Int)
    case shotComments(id: Int)
}

extension DdddribleAPI: SugarTargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.dribbble.com/v1")!
    }
    
    var url: URL {
        switch self {
        case .url(let url):
            return url
        default:
            return self.defaultURL
        }
    }
 
    var route: Route {
        switch self {
        case .url(_):
            return .get("")
        case .me:
            return .get("/user")
        case .shots:
            return .get("/shots")
        case .shot(let id):
            return .get("/shots/\(id)")
        case .isLikeShot(let id):
            return .get("/shots/\(id)/like")
        case .likeShot(let id):
            return .post("/shots/\(id)/like")
        case .unlikeShot(let id):
            return .delete("/shots/\(id)/like")
        case .shotComments(let id):
            return .get("/shots/\(id)/comments")
        }
    }
    
    var params: Parameters? {
        switch self {
        case .shots:
            return ["per_page": 100]
            
        default:
            return nil
        }
    }
    
    var task: Task {
        switch self {
        default:
            return .request
        }
    }
    
    var httpHeaderFields: [String: String]? {
        return ["Accept": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
    
}








