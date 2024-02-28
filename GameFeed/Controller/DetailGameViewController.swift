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
        RAWGClient.getGameDetail(idGame: gameId ?? 0) { (game, error) in
            self.isLoading(state: false)
            if let gameDetail = game {
                let metacritic = gameDetail.metacritic
                if let backgroundPath = gameDetail.backgroundImage {
                   self.path = backgroundPath
                   RAWGClient.downloadBackground(backgroundPath: backgroundPath) { (data, error) in
                       guard let data = data else {
                           return
                       }
                       
                       let image = UIImage(data: data)
                       self.photoGameDetail.image = image
                   }
                }
                self.overviewGameDetail.text = gameDetail.description
                self.titleGameDetail.text = gameDetail.name
                self.ratingGameDetail.text = String(format: "%.2f", gameDetail.rating ?? "")
                self.genreGameDetail.text = Formatter.formatGenre(from: gameDetail.genres ?? [])
                self.releaseGameDetail.text = Formatter.formatDate(from: gameDetail.released ?? "")
                self.platformGameDetail.text = Formatter.formatPlatform(from: gameDetail.platforms)
                self.publisherGameDetail.text = Formatter.formatPublisher(from: gameDetail.publishers)
                self.metacriticGameDetail.text = String(metacritic ?? 0)
            }
        }
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
        favoriteProvider.deleteFavorite(gameId ?? 0)
    }
    
    private func addToFavorite() {
        let name = titleGameDetail.text ?? ""
        let rating = ratingGameDetail.text ?? ""
        let genres = genreGameDetail.text ?? ""
        let released = releaseGameDetail.text ?? ""

        favoriteProvider.addToFavorite(gameId ?? 0, name, released, rating, genres, path, true)
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
        if scrollView.contentOffset.y >= (titleGameDetail.frame.origin.y + titleGameDetail.frame.height) && !didChangeTitle {
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
