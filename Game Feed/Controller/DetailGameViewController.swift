import UIKit

class DetailGameViewController: UIViewController {

    @IBOutlet weak var photoGameDetail: UIImageView!
    @IBOutlet weak var titleGameDetail: UILabel!
    @IBOutlet weak var ratingGameDetail: UILabel!
    @IBOutlet var overviewGameDetail: UILabel!
    @IBOutlet var platformGameDetail: UILabel!
    @IBOutlet var releaseGameDetail: UILabel!
    @IBOutlet var genreGameDetail: UILabel!
    @IBOutlet var developerGameDetail: UILabel!
    @IBOutlet var metacriticGameDetail: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var myView: UIView!
    @IBOutlet var myViewHeight: NSLayoutConstraint!
    
    // Get gameId from ViewController
    var gameId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myViewHeight.constant = 2000
        scrollView.contentSize = myView.frame.size
        
        activityIndicator.startAnimating()
        RAWGClient.getGameDetail(id: gameId ?? 0) { (game, error) in
            self.activityIndicator.stopAnimating()
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
                self.ratingGameDetail.text = String(format: "%.2f", gameDetail.rating)
                self.genreGameDetail.text = Formatter.formatGenre(from: gameDetail.genres ?? [])
                self.releaseGameDetail.text = Formatter.formatDate(from: gameDetail.released ?? "")
                self.metacriticGameDetail.text = String(metacritic)
            }
        }
    }
}
