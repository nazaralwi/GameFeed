//
//  GameTableViewCell.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 01/08/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var imageGame: UIImageView!
    @IBOutlet weak var titleGame: UILabel!
    @IBOutlet weak var rateGame: UILabel!
    @IBOutlet weak var descriptionGame: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
