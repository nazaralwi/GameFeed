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
    var gameList = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameTableView.dataSource = self
        RAWGClient.getGameList(completion: { (games, error) in
            self.gameList = games
            DispatchQueue.main.async {
                self.gameTableView.reloadData()
                print("Call \(self.gameList)")
            }
        })
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gameTableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(gameList.count)")
        return gameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {

            let game = gameList[indexPath.row]
            cell.titleGame.text = game.name

//            cell.photoGame.layer.cornerRadius = cell.photoGame.frame.height / 2
//            cell.photoGame.clipsToBounds = true
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
