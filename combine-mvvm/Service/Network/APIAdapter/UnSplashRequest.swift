//
//  UnSplashAPIService.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/24.
//

import Combine

protocol UnSplashRequestType {
    func fetchRandomImage(page: Int, per_page: Int) -> AnyPublisher<[ImageInfo], Error>
    func searchImage(term: String, page: Int, per_page: Int) -> AnyPublisher<SearchResult, Error>
}
 
class UnSplashRequest: APIService, UnSplashRequestType {
    func fetchRandomImage(page: Int, per_page: Int) -> AnyPublisher<[ImageInfo], Error> {
        return fetch(request: UserEndpoint.getRandomImageList(page: page, per_page: per_page).asURLRequest())
    }
    
    func searchImage(term: String, page: Int, per_page: Int) -> AnyPublisher<SearchResult, Error> {
        return fetch(SearchResult.self, request: UserEndpoint.searchTerm(query: term, page: page, per_page: per_page).asURLRequest())
    }
}
