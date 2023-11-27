//
//  ViewController.swift
//  MovieApp
//
//  Created by Caner Karabulut on 17.11.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}
//MARK: - Helpers
extension MainTabBarViewController {
    private func setup() {
        viewControllers = [
            createViewController(rootViewController: HomeViewController(), title: "Home", imageName: "house.fill"),
            createViewController(rootViewController: UpcomingViewController(), title: "Upcoming", imageName: "clock.arrow.circlepath"),
            createViewController(rootViewController: SearchViewController(), title: "Search", imageName: "sparkle.magnifyingglass"),
            createViewController(rootViewController: DownloadsViewController(), title: "Downloads", imageName: "arrow.down.to.line.circle"),
            createViewController(rootViewController: FavoritesViewController(), title: "Favorites", imageName: "star.circle")
        ]
        tabBar.tintColor = .purple
    }
    private func createViewController(rootViewController: UIViewController, title: String, imageName: String) -> UINavigationController {
        rootViewController.title = title
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
       
        let controller = UINavigationController(rootViewController: rootViewController)
        controller.navigationBar.prefersLargeTitles = true
        controller.navigationBar.isTranslucent = true
        controller.navigationBar.compactAppearance = appearance
        controller.navigationBar.standardAppearance = appearance
        controller.navigationBar.scrollEdgeAppearance = appearance
        controller.navigationBar.compactScrollEdgeAppearance = appearance
        controller.tabBarItem.title = title
        controller.tabBarItem.image = UIImage(systemName: imageName)
        return controller
    }
}
