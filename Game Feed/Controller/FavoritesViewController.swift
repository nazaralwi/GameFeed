//
//  FavoritesViewController.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 17/10/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
}
