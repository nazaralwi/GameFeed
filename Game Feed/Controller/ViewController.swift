//
//  ViewController.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 01/08/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var gameSearchBar: UISearchBar!
    @IBOutlet var searchBarButtonItem: UIBarButtonItem!
    
    
//    var searchGame = [String]()
//    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {
            
            let game = games[indexPath.row]
            cell.titleGame.text = game.title
            cell.descriptionGame.text = game.description
            cell.rateGame.text = game.rate
            cell.photoGame.image = game.photo
            
            cell.photoGame.layer.cornerRadius = cell.photoGame.frame.height / 2
            cell.photoGame.clipsToBounds = true
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
//        let detail = DetailViewController(nibName: "DetailViewController", bundle: nil)
        let detail = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailGameViewControllerScene") as! DetailGameViewController
        
        detail.game = games[indexPath.row]
        
        self.navigationController?.pushViewController(detail, animated: true)
    }
}

//extension ViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchGame = games.filter({$0.prefix(searchText.count) == searchText})
//    }
//}
