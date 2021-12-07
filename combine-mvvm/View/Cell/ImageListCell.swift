//
//  ImageListCell.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/24.
//

import UIKit

class ImageListCell: UITableViewCell {
    private var task: URLSessionDataTask?
    @IBOutlet weak var thumbImageView: UIImageView!
      
    public func setData(model: ImageInfo?) {
        guard let model = model else { return }
        
        if task == nil, let smallUrlStr = model.urls?.small {
            task = thumbImageView.downloadImage(from: smallUrlStr)
        }
    }
    
    override func prepareForReuse() {        
        thumbImageView.image = nil
        task?.cancel()
        task = nil
    }
}

