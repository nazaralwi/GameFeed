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
        homeVC.navigationItem.rightBarButtonItems = [profileButton(), searchButton()]

        let homeNC = UINavigationController(rootViewController: homeVC)
        homeNC.tabBarItem = UITabBarItem(title: "Home",
                                         image: UIImage(systemName: "house"),
                                         tag: 0)

        let newReleaseVC = NewGameViewController()
        newReleaseVC.title = "New Release"
        newReleaseVC.viewModel = container.resolve(NewGameViewModel.self)
        newReleaseVC.navigationItem.rightBarButtonItems = [profileButton(), searchButton()]

        let newReleaseNC = UINavigationController(rootViewController: newReleaseVC)
        newReleaseNC.tabBarItem = UITabBarItem(title: "New Release",
                                         image: UIImage(systemName: "flame"),
                                         tag: 1)

        let favoriteVC = FavoritesViewController()
        favoriteVC.title = "Favorite"
        favoriteVC.viewModel = container.resolve(FavoritesViewModel.self)
        favoriteVC.navigationItem.rightBarButtonItem = profileButton()

        let favoriteNC = UINavigationController(rootViewController: favoriteVC)
        favoriteNC.tabBarItem = UITabBarItem(title: "Favorite",
                                         image: UIImage(systemName: "heart"),
                                         tag: 3)

        viewControllers = [
            homeNC, newReleaseNC, favoriteNC
        ]
    }

    private func searchButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(search))
    }

    private func profileButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            image: UIImage(systemName: "person.circle"),
            style: .plain,
            target: self,
            action: #selector(openProfile))
    }

    @objc private func search() {
        let container = SwinjectContainer.getContainer()

        let searchVC = SearchGameViewController()
        searchVC.viewModel = container.resolve(SearchGameViewModel.self)
        searchVC.title = "Search"

        if let nav = selectedViewController as? UINavigationController {
            nav.pushViewController(searchVC, animated: true)
        }
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
