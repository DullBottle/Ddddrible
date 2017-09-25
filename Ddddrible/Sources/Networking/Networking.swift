//
//  Networking.swift
//  Ddddrible
//
//  Created by __End on 2017/9/25.
//  Copyright © 2017年 Dressrose. All rights reserved.
//

import Moya
import MoyaSugar
import RxSwift

typealias DdddribleNetworking = Networking<DdddribleAPI>

final class Networking<Target: SugarTargetType>: RxMoyaSugarProvider<Target> {
    
    init(plugins: [PluginType] = []) {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 10
        
        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        super.init(manager: manager, plugins: plugins)
    }
    
    @available(*, unavailable)
    override func request(_ token: Target) -> Observable<Response> {
        return super.request(token)
    }
    
    func request(_ token: Target, file: String = #file, function: String = #function, line: UInt = #line) -> Observable<Response> {
        
        let requestString = "\(token.method) \(token.path)"
        return super.request(token)
            .filterSuccessfulStatusCodes()
            .do(
                onNext: { value in
                    let message = "🍀 SUCCESS: \(requestString) (\(value.statusCode))"
                    logger.log(message, function: function, file: file, line: line)
                },
                onError: { error in
                    if let response = (error as? MoyaError)?.response {
                        if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                            let message = "❌ FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
                            logger.log(message, function: function, file: file, line: line)
                        } else if let rawString = String(data: response.data, encoding: .utf8) {
                            let message = "❌ FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
                            logger.log(message, function: function, file: file, line: line)
                        } else {
                            let message = "❌ FAILURE: \(requestString) (\(response.statusCode))"
                            logger.log(message, function: function, file: file, line: line)
                        }
                    } else {
                        let message = "❌ FAILURE: \(requestString)\n\(error)"
                        logger.log(message, function: function, file: file, line: line)
                    }
                },
                onSubscribe: {
                    let message = "🍔 REQUEST: \(requestString)"
                    logger.log(message, function: function, file: file, line: line)
            }
        )
    }
    
}





