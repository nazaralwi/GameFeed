//
//  TabBarViewController.swift
//  GameFeed
//
//  Created by Macintosh on 19/09/25.
//  Copyright © 2025 Dicoding Indonesia. All rights reserved.
//

import UIKit
import Swinject

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let container = SwinjectContainer.getContainer()

        let homeVC = ViewController()
        homeVC.title = "Home"
        homeVC.viewModel = container.resolve(HomeViewModel.self)
        addProfileButton(to: homeVC)

        let homeNC = UINavigationController(rootViewController: homeVC)
        homeNC.tabBarItem = UITabBarItem(title: "Home",
                                         image: UIImage(systemName: "house"),
                                         tag: 0)

        let newReleaseVC = NewGameViewController()
        newReleaseVC.title = "New Release"
        newReleaseVC.viewModel = container.resolve(NewGameViewModel.self)
        addProfileButton(to: newReleaseVC)

        let newReleaseNC = UINavigationController(rootViewController: newReleaseVC)
        newReleaseNC.tabBarItem = UITabBarItem(title: "New Release",
                                         image: UIImage(systemName: "flame"),
                                         tag: 1)

        let searchVC = SearchGameViewController()
        searchVC.title = "Search"
        searchVC.viewModel = container.resolve(SearchGameViewModel.self)
        addProfileButton(to: searchVC)

        let searchNC = UINavigationController(rootViewController: searchVC)
        searchNC.tabBarItem = UITabBarItem(title: "Search",
                                         image: UIImage(systemName: "magnifyingglass"),
                                         tag: 2)

        let favoriteVC = FavoritesViewController()
        favoriteVC.title = "Favorite"
        favoriteVC.viewModel = container.resolve(FavoritesViewModel.self)
        addProfileButton(to: favoriteVC)

        let favoriteNC = UINavigationController(rootViewController: favoriteVC)
        favoriteNC.tabBarItem = UITabBarItem(title: "Favorite",
                                         image: UIImage(systemName: "heart"),
                                         tag: 3)

        viewControllers = [
            homeNC, newReleaseNC, searchNC, favoriteNC
        ]
    }

    private func addProfileButton(to vc: UIViewController) {
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.circle"),
            style: .plain,
            target: self,
            action: #selector(openProfile))
    }

    @objc private func openProfile() {
        let container = SwinjectContainer.getContainer()

        let profileVC = MyProfileViewController()
        profileVC.viewModel = container.resolve(MyProfileViewModel.self)
        profileVC.title = "Profile"

        if let nav = selectedViewController as? UINavigationController {
            nav.pushViewController(profileVC, animated: true)
        }
    }
}
