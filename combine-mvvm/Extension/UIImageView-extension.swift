//
//  UIImageView-extension.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/24.
//

import UIKit

extension UIImageView {
    func downloadImage(from imgURL: String) -> URLSessionDataTask? {
        guard let url = URL(string: imgURL) else { return nil }
 
        image = nil
        
        if let imageToCache = ImageCacheManager.shared.imageCache.object(forKey: imgURL as NSString) {
            self.image = imageToCache
            return nil
        }
 
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print(err)
                return
            }

            DispatchQueue.main.async {
                guard let data = data,
                        let imageToCache = UIImage(data: data) else { return }
                ImageCacheManager.shared.imageCache.setObject(imageToCache, forKey: imgURL as NSString)
                self.image = imageToCache
            }
        }
        task.resume()
        return task
    }
}
