//
//  UITextField-extension.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/25.
//

import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField } // receiving notifications with objects which are instances of UITextFields
            .compactMap(\.text) // extracting text and removing optional values (even though the text cannot be nil)
            .eraseToAnyPublisher() //지금까지의 데이터 스트림이 어떠했던 최종적인 형태의 Publisher를 리턴
    }
}
