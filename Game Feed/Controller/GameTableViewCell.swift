import UIKit

class GameTableViewCell: UITableViewCell {
    @IBOutlet var titleGame: UILabel!
    @IBOutlet var photoGame: UIImageView!
    @IBOutlet var releaseGame: UILabel!
    @IBOutlet var ratingGame: UILabel!
    @IBOutlet var genreGame: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
