//
//  ImageDetailCell.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/25.
//

import UIKit

class ImageDetailCell: UICollectionViewCell {
    private var task: URLSessionDataTask?
    @IBOutlet weak var detailImageVIew: UIImageView!
    
    public func setData(model: ImageInfo?) {
        guard let model = model else { return }
        
        if task == nil, let regular = model.urls?.regular {
            task = detailImageVIew.downloadImage(from: regular)
        }
    }
    
    override func prepareForReuse() {
        detailImageVIew.image = nil
        task?.cancel()
        task = nil
    }
}

