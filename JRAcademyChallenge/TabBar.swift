//
//  tabbar.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 4.06.2023.
//

import Foundation
import UIKit

class TabBar: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    UITabBar.appearance().barTintColor = .systemBackground
    tabBar.tintColor = .label
    setupViewControllers()
  }
  
 
  func setupViewControllers() {
        viewControllers = [
            createNavController(for: GameHomeViewController(), title: "Games", image: UIImage(systemName: "gamecontroller.fill")!),
            createNavController(for: FavoritesViewController(), title: NSLocalizedString("Favorites", comment: ""), image: UIImage(systemName: "star.fill")!)
        ]
    }
  
  fileprivate func createNavController(for rootViewController: UIViewController,
                                                    title: String,
                                                    image: UIImage) -> UIViewController {
          let navController = UINavigationController(rootViewController: rootViewController)
          navController.tabBarItem.title = title
          navController.tabBarItem.image = image
          navController.navigationBar.prefersLargeTitles = true
          rootViewController.navigationItem.title = title
          return navController
      }
}
