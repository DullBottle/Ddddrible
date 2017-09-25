//
//  Logger.swift
//  Ddddrible
//
//  Created by __End on 2017/9/25.
//  Copyright © 2017年 Dressrose. All rights reserved.
//

import Foundation

/// A shared instance of `Logger`.
let logger = Logger()

class Logger {
    
    // MARK: Properties.
    
    lazy fileprivate var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        
        return formatter
    }()
    
    func log(_ message: String, function: String = #function, file: String = #file, line: UInt = #line) {
        
        let logMessage = combineLogMessage(message, function: function, file: file, line: line)
        printToConsole(logMessage)
    }
}

private extension Logger {
    
    func combineLogMessage(_ message: String, function: String, file: String, line: UInt) -> String {
        
        let date = dateFormatter.string(from: Date())
        let file = URL(fileURLWithPath: file).lastPathComponent
        
        return "`\(date)` [\(file):\(line)] \(function): \(message)\n"
    }
    
    func printToConsole(_ logMessage: String) {
        print(logMessage)
    }
}






