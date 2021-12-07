//
//  SearchImageContainerViewModel.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/24.
//

import Combine
import CoreGraphics
 
final class SearchImageContainerViewModel: CommonLogic {
    private let serviceProvider: ServiceProvider
    private var bag = Set<AnyCancellable>()
    
    @Published private(set) var imageInfoList: [ImageInfo]?
    @Published private(set) var state: ImageContainerViewModelErrorState = .loading
    
    private var page = 1
    private var per_page = 20 //이미지 N 개씩 호출
    var searchTerm = "" //검색어
    
    init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }
     
    private func checkImageDataReset(checkTerm: String) {
        if searchTerm != checkTerm {
            imageInfoList?.removeAll()
            page = 1
        }
    }
    
    private func setSearchTerm(_ term: String) {
        searchTerm = term
    }
    
    private func setAPIResultState(_ loadState: ImageContainerViewModelErrorState) {
        state = loadState
    }
    
    func searchImageList(term: String) {
        checkImageDataReset(checkTerm: term)
        setSearchTerm(term)
        guard term != "" else { return }
        
        setAPIResultState(.loading)
        serviceProvider.unSplashRequest.searchImage(term: term, page: page, per_page: per_page)
            .sink(receiveCompletion: { [weak self] completion in  //sink : sink를 통해 publisher에 대한 subscription을 작성
                switch completion {
                case .finished:
                    if self?.state != .dataEnd {
                        self?.setAPIResultState(.finishedLoading)
                    }
                case .failure(let error):
                    guard let error = error as? CommonNetworkError else {
                        self?.setAPIResultState(.error(CommonNetworkError.unknown))
                        return
                    }
                    self?.setAPIResultState(.error(error))
                }
            }, receiveValue: { [weak self] result in                
                if result.total == 0 || result.total_pages == self?.page {
                    self?.setAPIResultState(.dataEnd)                    
                }
                
                self?.setImageInfoList(result.results)
            })
            .store(in: &bag) //store: Stores this type-erasing cancellable instance in the specified set
                                //Cancellable instance를 저장
    }
    
    private func setImageInfoList(_ imageInfoArr: [ImageInfo]?) {
        if imageInfoList == nil {
            imageInfoList = imageInfoArr
        } else if let imageInfoArr = imageInfoArr {
            imageInfoList?.append(contentsOf: imageInfoArr)
        }
    }
    
    private func setPage(_ page: Int) {
        self.page = page
    }
    
    func checkLoadMoreData(index: Int) {
        let currentItemCount = imageInfoList?.count ?? 0
        if state == .finishedLoading, state != .dataEnd,
            index > currentItemCount - per_page/2 {
            
            setPage(page + 1)
            searchImageList(term: searchTerm)
        }
    }
}
