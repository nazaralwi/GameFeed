import UIKit

final class FavoritesViewController: BaseGameListViewController<FavoritesViewModel>, FavoritesViewModelDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.delegate = self
    }

    override func fetchGames() {
        viewModel?.fetchUsers()
    }

    override func fetchBackground(for game: GameUIModel) {
        viewModel?.fetchBackground(for: game)
    }

    // MARK: - FavoritesViewModelDelegate
    func didUpdateGames() {
        self.games = viewModel!.games
        self.tableView.reloadData()
        gameIsEmpty(state: !self.games.isEmpty)
    }

    func didUpdateLoadingIndicator(isLoading: Bool) {
        if isLoading {
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
        } else {
            self.loadingIndicator.isHidden = true
            self.loadingIndicator.stopAnimating()
        }
    }

    func didReceivedError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
