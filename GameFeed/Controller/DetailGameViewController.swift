import UIKit

class DetailGameViewController: UIViewController {
    @IBOutlet var photoGameDetail: UIImageView!
    @IBOutlet var titleGameDetail: UILabel!
    @IBOutlet var ratingGameDetail: UILabel!
    @IBOutlet var overviewGameDetail: UILabel!
    @IBOutlet var platformGameDetail: UILabel!
    @IBOutlet var releaseGameDetail: UILabel!
    @IBOutlet var genreGameDetail: UILabel!
    @IBOutlet var publisherGameDetail: UILabel!
    @IBOutlet var metacriticGameDetail: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var myView: UIView!
    @IBOutlet var myViewHeight: NSLayoutConstraint!
    @IBOutlet var addToFavoriteButton: UIBarButtonItem!
    private lazy var favoriteProvider: FavoriteProvider = { return FavoriteProvider() }()
    
    var detailViewModel: DetailViewModel?

    var gameId: Int?
    var game: GameUIModel?
    var path = String()

    var didChangeTitle = false
    var defaultTitle = ""
    var animateUp: CATransition = {
        let animation = CATransition()
        animation.duration = 0.5
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromTop
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        return animation
    }()

    var animateDown: CATransition = {
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

        detailViewModel?.delegate = self

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

    func setupView() {
        populatingGames()
        detailViewModel?.fetchFavoriteState(for: gameId ?? 0)
        detailViewModel?.fetchGameDetail(idGame: gameId ?? 0)
    }

    func populatingGames() {
        guard let game = game else { return }

        self.overviewGameDetail.text = game.description
        self.titleGameDetail.text = game.name
        self.ratingGameDetail.text = game.rating
        self.genreGameDetail.text = game.genres
        self.releaseGameDetail.text = game.released
        self.platformGameDetail.text = game.platforms
        self.publisherGameDetail.text = game.publishers
        self.metacriticGameDetail.text = String(game.metacritic ?? 0)
        self.photoGameDetail.image = game.downloadedBackgroundImage

        self.path = game.backgroundImage ?? ""
    }

    @IBAction func addToFavorite(_ sender: Any) {
        detailViewModel?.updateFavoriteState(for: gameId ?? 0)
    }

    private func deleteFromFavorite() {
        detailViewModel?.deleteGameFavorite(gameId ?? 0)
    }

    private func addToFavorite() {
        let name = titleGameDetail.text ?? ""
        let rating = ratingGameDetail.text ?? ""
        let genres = genreGameDetail.text ?? ""
        let released = releaseGameDetail.text ?? ""

        let path = self.path

        let game = GameUIModel(
            idGame: gameId ?? 0,
            name: name,
            released: released,
            description: nil,
            rating: rating,
            backgroundImage: path,
            genres: genres,
            platforms: nil,
            publishers: nil,
            metacritic: nil)

        detailViewModel?.addGameToFavorite(game)
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
