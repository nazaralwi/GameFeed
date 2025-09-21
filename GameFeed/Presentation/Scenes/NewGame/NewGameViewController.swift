import UIKit

final class NewGameViewController: BaseGameListViewController<NewGameViewModel>, NewGameViewModelDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.delegate = self
    }

    override func fetchGames() {
        let now = Date()
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: now)
        viewModel?.fetchNewGame(
            lastMonth: Formatter.formatDate(from: previousMonth ?? Date()),
            now: Formatter.formatDate(from: now)
        )
    }

    override func fetchBackground(for game: GameUIModel) {
        viewModel?.fetchBackground(for: game)
    }

    // MARK: - NewGameViewModelDelegate
    func didUpdateGames() {
        self.games = viewModel!.games
        self.tableView.reloadData()
        gameIsEmpty(state: !self.games.isEmpty)
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
