//
//  ServiceProvider.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/24.
//

import Foundation

protocol ServiceProviderType: AnyObject {
    var unSplashRequest: UnSplashRequestType { get }
}

final class ServiceProvider: ServiceProviderType {
    lazy var unSplashRequest: UnSplashRequestType = UnSplashRequest()
}
