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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameTableView.dataSource = self
        gameTableView.delegate = self
        RAWGClient.getGameList(completion: { (games, error) in
            GameModel.gameList = games
            DispatchQueue.main.async {
                self.gameTableView.reloadData()
            }
        })
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gameTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detail = segue.destination as! DetailGameViewController
            detail.game = GameModel.gameList[selectedIndex]
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameModel.gameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {

            let game = GameModel.gameList[indexPath.row]
            cell.titleGame.text = game.name
            
            if let backgroundPath = game.backgroundImage {
                RAWGClient.downloadBackground(backgroundPath: backgroundPath) { (data, error) in
                    guard let data = data else {
                        return
                    }
                    
                    let image = UIImage(data: data)
                    cell.photoGame.image = image
                    cell.setNeedsLayout()
                }
            }
//            cell.photoGame.layer.cornerRadius = cell.photoGame.frame.height / 2
//            cell.photoGame.clipsToBounds = true
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
//        let detail = DetailGameViewController(nibName: "DetailGameViewController", bundle: nil)
//        detail.game = GameModel.gameList[indexPath.row]
//        self.navigationController?.pushViewController(detail, animated: true)
    }
}
