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
    private let emptyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "tray.fill")
        imageView.tintColor = .lightGray
        imageView.isHidden = true
        return imageView
    }()
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        label.text = "Games is empty"
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    var games: [GameUIModel] = []
    var selectedIndex = 0
    var viewModel: VM?
    var selection: (_ game: GameUIModel) -> Void = { _ in }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupCommonConstraint()
        setupCustomConstraint()

        tableView.delegate = self
        tableView.dataSource = self

        fetchGames()
    }

    private func setupSubviews() {
        [tableView, loadingIndicator, errorLabel, emptyImage, emptyLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    func setupCommonConstraint() {
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyImage.heightAnchor.constraint(equalToConstant: 150),
            emptyImage.widthAnchor.constraint(equalToConstant: 150),

            emptyLabel.topAnchor.constraint(equalTo: emptyImage.bottomAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: emptyImage.leadingAnchor),
            emptyLabel.trailingAnchor.constraint(equalTo: emptyImage.trailingAnchor)
        ])
    }

    func setupCustomConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func fetchGameSelector() {
        fetchGames()

        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    func gameIsEmpty(state: Bool) {
        emptyLabel.isHidden = state
        emptyImage.isHidden = state
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        selection(games[selectedIndex])
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
