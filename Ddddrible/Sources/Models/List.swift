//
//  List.swift
//  Ddddrible
//
//  Created by __End on 2017/9/26.
//  Copyright © 2017年 Dressrose. All rights reserved.
//

import Foundation

struct List<Element> {
    var items: [Element]
    var nextURL: URL?
    
    init(items: [Element], nextURL: URL? = nil) {
        self.items = items
        self.nextURL = nextURL
    }
}
