//
//  SearchImageInfo.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/25.
//

import Foundation

struct SearchResult: Codable, Equatable {
    let total: Int?
    let total_pages: Int?
    let results: [ImageInfo]?
}
 
  
