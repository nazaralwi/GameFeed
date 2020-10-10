import UIKit

class NewGameViewController: UIViewController {
    @IBOutlet var newGameTableView: UITableView!
    var selectedIndex = 0
    var newGame = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RAWGClient.getEntireGame { (games, error) in
            for game in games {
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd"
                
                let now = Date()
                let releasedDate = dateFormatterGet.date(from: game.released ?? "")
                
                let oneMonthBefore = Calendar.current.date(byAdding: .year, value: -2, to: now)
                
                if (releasedDate! <= now) && (releasedDate! >= oneMonthBefore!) {
                    self.newGame.append(game)
                }
                
                print("now: \(now)")
                print("oneMonthBefore: \(oneMonthBefore)")
                print("released: \(releasedDate)")
                
//                let dateFormatterGet = DateFormatter()
//                dateFormatterGet.dateFormat = "yyyy-MM-dd"
//
//                let dateFormatterPrint = DateFormatter()
//                dateFormatterPrint.dateFormat = "MM-yyyy"
//
//                if let date = dateFormatterGet.date(from: game.released ?? "") {
//                    gameReleased = date
//                } else {
//                    print("Something error")
//                }
//
//                let dateFormatterGet1 = DateFormatter()
//                dateFormatterGet.dateFormat = "yyyy-MM-dd"
//
//                let dateFormatterPrint1 = DateFormatter()
//                dateFormatterPrint.dateFormat = "MM-yyyy"
//
//                if (gameReleased == ) {
//                    self.newGame.append(game)
//                }
//                var dayComp = DateComponents(year: 2020, month: -3)
//                let date = Calendar.current.date(byAdding: dayComp, to: Date())
//                Calendar.current.component(.month, from: date!)
            }
            print("Game:\(self.newGame)")
            DispatchQueue.main.async {
                self.newGameTableView.reloadData()
            }
        }
        
        newGameTableView.dataSource = self
        newGameTableView.delegate = self
        
        newGameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
}

extension NewGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newGame.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {
            let game = newGame[indexPath.row]
            
            cell.releaseGame.text = Formatter.formatDate(from: game.released ?? "")
            cell.genreGame.text = Formatter.formatGenre(from: game.genres ?? [])
            cell.titleGame.text = game.name
            cell.ratingGame.text = String(format: "%.2f", game.rating)
            
            if let backgroundPath = game.backgroundImage {
                RAWGClient.downloadBackground(backgroundPath: backgroundPath) { (data, error) in
                    guard let data = data else {
                        return
                    }
                    
                    let image = UIImage(data: data)
                    cell.photoGame.image = image
                    cell.setNeedsLayout()
                    
                    cell.photoGame.roundCorners(corners: [.topRight, .topLeft], radius: 10)
                }
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension NewGameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
