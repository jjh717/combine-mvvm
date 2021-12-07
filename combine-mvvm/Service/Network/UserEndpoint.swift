//
//  UserEndpoint.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/24.
//
//

import Foundation

enum RequestType: String {
    case GET, POST
}

protocol APIConfiguration {
    var method: RequestType { get }
    var path: String { get }
    var parameters: [URLQueryItem]? { get }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}

enum UserEndpoint: APIConfiguration {
    case getRandomImageList(page: Int, per_page: Int)
    case searchTerm(query: String, page: Int, per_page: Int)
    
    // MARK: - HTTPMethod
    var method: RequestType {
        switch self {
        case .getRandomImageList, .searchTerm:
            return .GET
        }
    }

    // MARK: - Path
    var path: String {
        switch self {
        case .getRandomImageList:
            return "/photos"
        case .searchTerm:
            return "/search/photos"
        }
    }
    
    // MARK: - Parameters
    var parameters: [URLQueryItem]? {
        switch self {
        case .getRandomImageList(let page, let per_page):
            return [URLQueryItem(name: "page", value: "\(page)"),
                    URLQueryItem(name: "per_page", value: "\(per_page)")]
        case .searchTerm(let term, let page, let per_page):
            return [URLQueryItem(name: "query", value: "\(term)"),
                    URLQueryItem(name: "page", value: "\(page)"),
                    URLQueryItem(name: "per_page", value: "\(per_page)")]
        }
    }
    
    // MARK: - URLRequest
    func asURLRequest() -> URLRequest? {
        guard let baseUrl = URL(string: Constants.unSplash_baseURL) else { fatalError("URLComponents 생성 오류") }
        guard var components = URLComponents(url: baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }
        
        // Parameters
        components.queryItems = parameters

        guard let url = components.url else {
            fatalError("Could not get url")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

        // HTTP Method
        urlRequest.httpMethod = method.rawValue

        // Common Headers
        urlRequest.setValue("Client-ID \(Constants.unSplash_appKey)",
                            forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)

        return urlRequest
    }
}
