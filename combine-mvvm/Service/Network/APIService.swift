//
//  APIService.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/24.
//

import Foundation
import Combine
 
protocol APIServiceProtocol {
    func fetch<T: Codable>(_ type: T.Type?, request: URLRequest?) -> AnyPublisher<T, Error>
}
 
class APIService: APIServiceProtocol {
    func fetch<T: Codable>(_ type: T.Type? = nil, request: URLRequest?) -> AnyPublisher<T, Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
         
        //Future:
        //단일 이벤트와 종료 혹은 실패를 제공하는 publisher
        //Swift에서 asynchronous 프로그래밍을 위해 callback기반 completion handler
        //Future는 Output과 Error, promise 클로저가 있다.
        return Future<T, Error> { [weak self] promise in
            guard let urlRequest = request else {
                promise(.failure(CommonNetworkError.urlRequest))
                return
            }
            
            dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data)
                    promise(.success(model))
                } catch {
                    promise(.failure(CommonNetworkError.decode))
                }
            }
        }
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher() //지금까지의 데이터 스트림이 어떠했던 최종적인 형태의 Publisher를 리턴
    }
}
