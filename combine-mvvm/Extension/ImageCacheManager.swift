//
//  ImageCacheManager.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/25.
//

import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {}
    
    let imageCache = NSCache<NSString, UIImage>()
}
