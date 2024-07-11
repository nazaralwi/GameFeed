import UIKit
import Combine

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
    
    var rawgService: RAWGService?

    var cancellables = Set<AnyCancellable>()

    var gameId: Int?
    var gameDetail: GameDetail!
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
        if favoriteProvider.checkData(id: gameId ?? 0) {
            addToFavoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            addToFavoriteButton.image = UIImage(systemName: "heart")
        }

        isLoading(state: true)
        rawgService?.getGameDetail(idGame: gameId ?? 0)
            .flatMap { [self] gameDetail -> AnyPublisher<(GameDetail, Data?), Error> in
                let backgroundPublisher: AnyPublisher<Data?, Error>
                if let backgroundPath = gameDetail.backgroundImage {
                    self.path = backgroundPath
                    backgroundPublisher = (rawgService?.downloadBackground(backgroundPath: backgroundPath)
                        .map { Optional($0) }
                        .catch { _ in Just(nil).setFailureType(to: Error.self) }
                        .eraseToAnyPublisher())!
                } else {
                    backgroundPublisher = Just(nil).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
                return backgroundPublisher.map { (gameDetail, $0) }.eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { completion in
                self.isLoading(state: false)
                if case .failure(let error) = completion {
                    print("Failed with error: \(error)")
                }
            }, receiveValue: { gameDetail, imageData in
                if let imageData = imageData {
                    self.photoGameDetail.image = UIImage(data: imageData)
                }
                self.overviewGameDetail.text = gameDetail.description
                self.titleGameDetail.text = gameDetail.name
                self.ratingGameDetail.text = String(format: "%.2f", gameDetail.rating ?? 0.0)
                self.genreGameDetail.text = Formatter.formatGenre(from: gameDetail.genres ?? [])
                self.releaseGameDetail.text = Formatter.formatDate(from: gameDetail.released ?? "")
                self.platformGameDetail.text = Formatter.formatPlatform(from: gameDetail.platforms)
                self.publisherGameDetail.text = Formatter.formatPublisher(from: gameDetail.publishers)
                self.metacriticGameDetail.text = String(gameDetail.metacritic ?? 0)
            })
            .store(in: &cancellables)
    }

    @IBAction func addToFavorite(_ sender: Any) {
        if !favoriteProvider.checkData(id: gameId ?? 0) {
            addToFavorite()
            addToFavoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            deleteFromFavorite()
            addToFavoriteButton.image = UIImage(systemName: "heart")
        }
    }

    private func deleteFromFavorite() {
        _ = favoriteProvider.deleteFavorite(gameId ?? 0)
    }

    private func addToFavorite() {
        let name = titleGameDetail.text ?? ""
        let rating = ratingGameDetail.text ?? ""
        let genres = genreGameDetail.text ?? ""
        let released = releaseGameDetail.text ?? ""

        let path = self.path

        let game = GameFavoriteViewModel(
            idGame: gameId ?? 0,
            name: name,
            released: released,
            rating: rating,
            backgroundImage: path,
            genres: genres)

        _ = favoriteProvider.addToFavorite(game: game, true)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }

    private func isLoading(state: Bool) {
        if state {
            activityIndicator.startAnimating()
            addToFavoriteButton.isEnabled = false
        } else {
            self.activityIndicator.stopAnimating()
            self.addToFavoriteButton.isEnabled = true
        }
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
