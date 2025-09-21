//
//  BaseGameListViewController.swift
//  GameFeed
//
//  Created by Macintosh on 21/09/25.
//  Copyright © 2025 Dicoding Indonesia. All rights reserved.
//

import UIKit

class BaseGameListViewController<VM>: UIViewController, UITableViewDelegate, UITableViewDataSource {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 360
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: "GameCell")
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = UIColor.gray
        tableView.refreshControl?.addTarget(
            self,
            action: #selector(fetchGameSelector),
            for: UIControl.Event.valueChanged)
        return tableView
    }()
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .large
        return indicator
    }()
    let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    var games: [GameUIModel] = []
    var selectedIndex = 0
    var viewModel: VM?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func setupView() {
        [tableView, loadingIndicator, errorLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc private func fetchGameSelector() {
        fetchGames()

        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row

        let container = SwinjectContainer.getContainer()

        let detailVC = DetailGameViewController()
        detailVC.viewModel = container.resolve(DetailViewModel.self)
        detailVC.game = games[selectedIndex]

        navigationController?.pushViewController(detailVC, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell
        else {
            return UITableViewCell()
        }

        let game = games[indexPath.row]

        cell.releaseGame.text = game.released
        cell.genreGame.text = game.genres
        cell.titleGame.text = game.name
        cell.ratingGame.text = "⭐️ " + game.rating

        if let downloadedImage = game.downloadedBackgroundImage {
            cell.photoGame.image = downloadedImage
        } else {
            if game.backgroundImagePath != "broken_image" {
                fetchBackground(for: game)
            } else {
                cell.photoGame.image = UIImage(systemName: "photo.badge.exclamationmark")
            }
        }

        return cell
    }

    func fetchGames() { /** Implemented on sub subclass **/ }
    func fetchBackground(for game: GameUIModel) { /** Implemented on sub subclass **/ }
}
