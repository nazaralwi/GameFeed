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
    @IBOutlet var deleteFromFavoriteButton: UIBarButtonItem!
    private lazy var favoriteProvider: FavoriteProvider = { return FavoriteProvider() }()
    
    var gameId: Int?
    var gameDetail: GameDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myViewHeight.constant = 2000
        scrollView.contentSize = myView.frame.size
        
        activityIndicator.startAnimating()
        addToFavoriteButton.isEnabled = false
        deleteFromFavoriteButton.isEnabled = false
        RAWGClient.getGameDetail(idGame: gameId ?? 0) { (game, error) in
            self.activityIndicator.stopAnimating()
            self.addToFavoriteButton.isEnabled = true
            self.deleteFromFavoriteButton.isEnabled = true
            print("Game Detail : \(game)")
            if let gameDetail = game {
                let metacritic = gameDetail.metacritic
                if let backgroundPath = gameDetail.backgroundImage {
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
    
    @IBAction func deleteFromFavorite(_ sender: Any) {
        favoriteProvider.deleteFavorite(gameId ?? 0) {
            DispatchQueue.main.async {
                let name = self.titleGameDetail.text ?? ""
                let alert = UIAlertController(title: "Successful", message: "\(name) deleted.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func addToFavorite(_ sender: Any) {
        addToFavorite()
    }
    
    private func addToFavorite() {
        let name = titleGameDetail.text ?? ""
        let overview = overviewGameDetail.text ?? ""
        let rating = ratingGameDetail.text ?? ""
        let genres = genreGameDetail.text ?? ""
        let released = releaseGameDetail.text ?? ""
        let platform = platformGameDetail.text ?? ""
        let publisher = publisherGameDetail.text ?? ""
        let metacritic = metacriticGameDetail.text ?? ""

        favoriteProvider.addToFavorite(gameId ?? 0, name, released, rating, genres) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Successful", message: "Add \(name) to favorite", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func loadFavorite() {
        favoriteProvider.getFavorite(gameId ?? 0) { (favorite) in
            DispatchQueue.main.async {
                self.titleGameDetail.text = favorite.name
                self.ratingGameDetail.text = favorite.rating
                self.releaseGameDetail.text = favorite.released
                self.genreGameDetail.text = favorite.genres
            }
        }
    }
    
    func toggleFavoriteButton(_ button: UIBarButtonItem, enable: Bool) {
        if enable {
            addToFavoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            addToFavoriteButton.image = UIImage(systemName: "heart")
        }
    }
}
