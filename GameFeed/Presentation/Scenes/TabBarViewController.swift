//
//  TabBarViewController.swift
//  GameFeed
//
//  Created by Macintosh on 19/09/25.
//  Copyright © 2025 Dicoding Indonesia. All rights reserved.
//

import UIKit
import GameFeedDomain

class TabBarViewController: UITabBarController {
    let networking: Networking
    let remoteDataSource: GameRemoteDataSource
    let gameFeedUseCase: GameFeedUseCase

    let favoriteProvider: CoreDataFavoriteDataSource
    let favoriteUseCase: FavoriteUseCase

    let profileDataSource: UserDefaultProfileDataSource
    let profileUseCase: ProfileUseCase

    init(networking: Networking,
         remoteDataSource: GameRemoteDataSource,
         gameFeedUseCase: GameFeedUseCase,
         favoriteProvider: CoreDataFavoriteDataSource,
         favoriteUseCase: FavoriteUseCase,
         profileDataSource: UserDefaultProfileDataSource,
         profileUseCase: ProfileUseCase) {
        self.networking = networking
        self.remoteDataSource = remoteDataSource
        self.gameFeedUseCase = gameFeedUseCase
        self.favoriteProvider = favoriteProvider
        self.favoriteUseCase = favoriteUseCase
        self.profileDataSource = profileDataSource
        self.profileUseCase = profileUseCase

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = HomeViewController()
        let homeViewModel = HomeViewModel(gameFeedUseCase: gameFeedUseCase)
        homeVC.title = "Home"
        homeVC.viewModel = homeViewModel
        homeVC.selection = { game in
            let detailVC = DetailGameViewController()
            detailVC.viewModel = DetailViewModel(gameFeedUseCase: self.gameFeedUseCase,
                                                 favoriteUseCase: self.favoriteUseCase)
            detailVC.game = game

            homeVC.navigationController?.pushViewController(detailVC, animated: true)
        }
        homeVC.navigationItem.rightBarButtonItems = [profileButton(), searchButton()]

        let homeNC = UINavigationController(rootViewController: homeVC)
        homeNC.tabBarItem = UITabBarItem(title: "Home",
                                         image: UIImage(systemName: "house"),
                                         tag: 0)

        let newReleaseVC = NewGameViewController()
        let newGameViewModel = NewGameViewModel(gameFeedUseCase: gameFeedUseCase)
        newReleaseVC.title = "New Release"
        newReleaseVC.viewModel = newGameViewModel
        newReleaseVC.selection = { game in
            let detailVC = DetailGameViewController()
            detailVC.viewModel = DetailViewModel(gameFeedUseCase: self.gameFeedUseCase,
                                                 favoriteUseCase: self.favoriteUseCase)
            detailVC.game = game

            newReleaseVC.navigationController?.pushViewController(detailVC, animated: true)
        }
        newReleaseVC.navigationItem.rightBarButtonItems = [profileButton(), searchButton()]

        let newReleaseNC = UINavigationController(rootViewController: newReleaseVC)
        newReleaseNC.tabBarItem = UITabBarItem(title: "New Release",
                                         image: UIImage(systemName: "flame"),
                                         tag: 1)

        let favoriteVC = FavoritesViewController()
        favoriteVC.title = "Favorite"
        favoriteVC.viewModel = FavoritesViewModel(gameFeedUseCase: gameFeedUseCase, favoriteUseCase: favoriteUseCase)
        favoriteVC.selection = { game in
            let detailVC = DetailGameViewController()
            detailVC.viewModel = DetailViewModel(gameFeedUseCase: self.gameFeedUseCase,
                                                 favoriteUseCase: self.favoriteUseCase)
            detailVC.game = game

            favoriteVC.navigationController?.pushViewController(detailVC, animated: true)
        }
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
        let searchVC = SearchGameViewController()
        let searchViewModel = SearchGameViewModel(gameFeedUseCase: gameFeedUseCase)
        searchVC.viewModel = searchViewModel
        searchVC.title = "Search"

        if let nav = selectedViewController as? UINavigationController {
            nav.pushViewController(searchVC, animated: true)
        }
    }

    @objc private func openProfile() {
        let profileVC = MyProfileViewController()
        let profileViewModel = MyProfileViewModel(profileUseCase: profileUseCase)
        profileVC.viewModel = profileViewModel
        profileVC.title = "Profile"

        if let nav = selectedViewController as? UINavigationController {
            nav.pushViewController(profileVC, animated: true)
        }
    }

}
