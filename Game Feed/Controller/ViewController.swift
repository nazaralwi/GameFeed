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
    
    var selectedIndex = 0
//    var searchGame = [String]()
//    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        _ = RAWGClient.getGameList(completion: { (games, error) in
            GameModel.gameList = games
            DispatchQueue.main.async {
                self.gameTableView.reloadData()
            }
        })
        
//        gameTableView.dataSource = self
//        gameTableView.delegate = self
//        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gameTableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameModel.gameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {

            let game = GameModel.gameList[indexPath.row]
            cell.titleGame.text = game.name

            cell.photoGame.layer.cornerRadius = cell.photoGame.frame.height / 2
            cell.photoGame.clipsToBounds = true
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

//extension ViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return GameModel.gameList.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {
//
//            let game = GameModel.gameList[indexPath.row]
//            cell.titleGame.text = game.name
//
//            cell.photoGame.layer.cornerRadius = cell.photoGame.frame.height / 2
//            cell.photoGame.clipsToBounds = true
//            return cell
//        } else {
//            return UITableViewCell()
//        }
//    }
//}
//
//extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
////        let detail = DetailViewController(nibName: "DetailViewController", bundle: nil)
//        let detail = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailGameViewControllerScene") as! DetailGameViewController
//
////        detail.game = games[indexPath.row]
//
//        self.navigationController?.pushViewController(detail, animated: true)
//    }
//}

//extension ViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchGame = games.filter({$0.prefix(searchText.count) == searchText})
//    }
//}
