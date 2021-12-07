//
//  ImageDetailViewModel.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/25.
//

import Combine

final class ImageDetailViewModel {
    @Published var currentImageIndex = -1
    
    var imageContainerViewModel: ImageContainerViewModel?
    var searchImageContainerViewModel: SearchImageContainerViewModel?
    
    init(viewModel: ImageContainerViewModel, currentIndex: Int) {
        imageContainerViewModel = viewModel
        currentImageIndex = currentIndex
    }
    
    init(viewModel: SearchImageContainerViewModel, currentIndex: Int) {
        searchImageContainerViewModel = viewModel
        currentImageIndex = currentIndex
    }
    
    public func getImageList() -> [ImageInfo]? {
        if let viewModel = imageContainerViewModel {
            return viewModel.imageInfoList
        } else if let viewModel = searchImageContainerViewModel {
            return viewModel.imageInfoList
        }
        
        return nil
    }
    
    public func setCurrentImage(index: Int) {
        currentImageIndex = index
        
        imageContainerViewModel?.checkLoadMoreData(index: index)
        searchImageContainerViewModel?.checkLoadMoreData(index: index)
    }     
}
