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
    
    var game: Game!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let backgroundPath = game.backgroundImage {
            RAWGClient.downloadBackground(backgroundPath: backgroundPath) { (data, error) in
                guard let data = data else {
                    return
                }
                
                let image = UIImage(data: data)
                self.photoGameDetail.image = image
            }
        }
        titleGameDetail.text = game.name
        ratingGameDetail.text = String(format: "%.2f", game.rating)
        
        var genres = [String]()
        for genre in game.genres {
            let genreName = genre.name
            genres.append(genreName)
        }
        
        let metacritic = game.metacritic ?? 0
        
        genreGameDetail.text = genres.joined(separator: ", ")
        releaseGameDetail.text = game.released
        metacriticGameDetail.text = String(metacritic)
    }
}
