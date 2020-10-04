//
//  DetailGameViewController.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 03/08/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit

class DetailGameViewController: UIViewController {

    @IBOutlet weak var photoGameDetail: UIImageView!
    @IBOutlet weak var titleGameDetail: UILabel!
    @IBOutlet weak var rateGameDetail: UILabel!
    @IBOutlet weak var descriptionGameDetail: UILabel!
    
    var game: Game!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
