//
//  MyTabBarController.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/24.
//

import UIKit

final class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    private var serviceProvider = ServiceProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self        
         
        guard let vcs = self.viewControllers else { return }
        guard vcs.count > 0 else { return }
        guard let listNavi = self.viewControllers?[0] as? UINavigationController else { return }
        guard listNavi.viewControllers.count > 0 else { return }
        guard let mainViewController = listNavi.viewControllers[0] as? MainViewController else { return }

        mainViewController.serviceProvider = self.serviceProvider

        guard vcs.count > 1 else { return }
        guard let navi = self.viewControllers?[1] as? UINavigationController else { return }
        guard navi.viewControllers.count > 0 else { return }
        guard let searchViewController = navi.viewControllers[0] as? SearchViewController else { return }

        searchViewController.serviceProvider = self.serviceProvider
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let navi = viewController as? UINavigationController else { return }
        navi.popToRootViewController(animated: false)
    }
}
