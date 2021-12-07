//
//  BaseViewController.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/25.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    public var serviceProvider: ServiceProvider?
    public var bag = Set<AnyCancellable>()
    func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
     
    func getViewController<T>(_ type: T.Type) -> UIViewController {
        return UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: type))
    }
}
