//
//  ModelType.swift
//  Ddddrible
//
//  Created by __End on 2017/9/25.
//  Copyright © 2017年 Dressrose. All rights reserved.
//

import ObjectMapper
import Then

protocol ModelType: ImmutableMappable, Then {
    associatedtype Event
}

