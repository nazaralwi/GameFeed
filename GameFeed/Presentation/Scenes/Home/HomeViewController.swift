import UIKit

final class HomeViewController: BaseGameListViewController<HomeViewModel>, HomeViewModelDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.delegate = self
        fetchGames()
    }

    override func fetchGames() {
        viewModel?.fetchGames()
    }

    override func fetchBackground(for game: GameUIModel) {
        viewModel?.fetchBackground(for: game)
    }

    // MARK: - Delegate
    func didUpdateGames() {
        self.games = viewModel!.games
        tableView.reloadData()
    }

    func didUpdateLoadingIndicator(isLoading: Bool) {
        if isLoading {
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimating()
        }
    }

    func didReceivedError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)

        errorLabel.text = message
        errorLabel.isHidden = false
    }
}
