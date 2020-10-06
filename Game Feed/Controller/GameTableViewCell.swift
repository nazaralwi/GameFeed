//
//  GameTableViewCell.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 01/08/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet var titleGame: UILabel!
    @IBOutlet var photoGame: UIImageView!
    @IBOutlet var releaseGame: UILabel!
    @IBOutlet var ratingGame: UILabel!
    @IBOutlet var genreGame: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
