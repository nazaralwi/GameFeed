import UIKit

final class DetailGameViewController: UIViewController {
    @IBOutlet private var photoGameDetail: UIImageView!
    @IBOutlet private var titleGameDetail: UILabel!
    @IBOutlet private var ratingGameDetail: UILabel!
    @IBOutlet private var overviewGameDetail: UILabel!
    @IBOutlet private var platformGameDetail: UILabel!
    @IBOutlet private var releaseGameDetail: UILabel!
    @IBOutlet private var genreGameDetail: UILabel!
    @IBOutlet private var publisherGameDetail: UILabel!
    @IBOutlet private var metacriticGameDetail: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var myView: UIView!
    @IBOutlet private var myViewHeight: NSLayoutConstraint!
    @IBOutlet private var addToFavoriteButton: UIBarButtonItem!

    public var viewModel: DetailViewModel?
    public var game: GameUIModel?

    private var didChangeTitle = false
    private var defaultTitle = ""

    private var animateUp: CATransition = {
        let animation = CATransition()
        animation.duration = 0.5
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromTop
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        return animation
    }()

    private var animateDown: CATransition = {
        let animation = CATransition()
        animation.duration = 0.5
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromBottom
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        return animation
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self

        viewModel?.delegate = self

        myViewHeight.constant = 2000
        scrollView.contentSize = myView.frame.size

        let titleLabelView = UILabel.init(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        titleLabelView.backgroundColor = .clear
        titleLabelView.textAlignment = .center
        titleLabelView.textColor = .white
        titleLabelView.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabelView.text = defaultTitle
        self.navigationItem.titleView = titleLabelView

        setupView()
    }

    private func setupView() {
        viewModel?.fetchGameDetail(idGame: game?.idGame ?? 0)
        populatingGames()
    }

    private func populatingGames() {
        guard let game = game else { return }

        self.overviewGameDetail.text = game.description
        self.titleGameDetail.text = game.name
        self.ratingGameDetail.text = game.rating
        self.genreGameDetail.text = game.genres
        self.releaseGameDetail.text = game.released
        self.platformGameDetail.text = game.platforms
        self.publisherGameDetail.text = game.publishers
        self.metacriticGameDetail.text = String(game.metacritic)

        if let downloadedImage = game.downloadedBackgroundImage {
            self.photoGameDetail.image = downloadedImage
        } else {
            if game.backgroundImagePath != "broken_image" {
//                viewModel!.fetchBackground(for: game)
            } else {
                self.photoGameDetail.image = UIImage(systemName: "photo.badge.exclamationmark")
            }
        }
    }

    @IBAction private func addToFavorite(_ sender: Any) {
        viewModel?.updateFavoriteState(for: game?.idGame ?? 0)
    }

    private func deleteFromFavorite() {
        viewModel?.deleteGameFavorite(game?.idGame ?? 0)
    }

    private func addToFavorite() {
        viewModel?.addGameToFavorite(game!)
    }
}

extension DetailGameViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yAxis = titleGameDetail.frame.origin.y
        let height = titleGameDetail.frame.height
        if scrollView.contentOffset.y >=
            (yAxis + height) && !didChangeTitle {
            if let label = navigationItem.titleView as? UILabel {
                label.layer.add(animateUp, forKey: "changeTitle")
                label.text = titleGameDetail.text
            }
            didChangeTitle = true
        } else if scrollView.contentOffset.y < titleGameDetail.frame.origin.y && didChangeTitle {
            if let label = navigationItem.titleView as? UILabel {
                label.layer.add(animateDown, forKey: "changeTitle")
                label.text = defaultTitle
            }
            didChangeTitle = false
        }
    }
}

extension DetailGameViewController: DetailViewModelDelegate {
    func didLoadDetailGame(game: GameUIModel) {
        self.overviewGameDetail.text = game.description
        self.platformGameDetail.text = game.platforms
        self.publisherGameDetail.text = game.publishers
        self.metacriticGameDetail.text = String(game.metacritic ?? 0)
    }

    func didFetchFavoriteState(isFavorite: Bool) {
        if isFavorite {
            addToFavoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            addToFavoriteButton.image = UIImage(systemName: "heart")
        }
    }

    func didUpdateFavoriteState(isFavorite: Bool) {
        if isFavorite {
            addToFavorite()
            addToFavoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            deleteFromFavorite()
            addToFavoriteButton.image = UIImage(systemName: "heart")
        }
    }

    func didUpdateLoadingIndicator(isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            addToFavoriteButton.isEnabled = false
        } else {
            self.activityIndicator.stopAnimating()
            self.addToFavoriteButton.isEnabled = true
        }
    }

    func didReceivedError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
