import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var gameSearchBar: UISearchBar!
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gameTableView.contentInset.bottom = 10
        
        gameSearchBar.isHidden = true
        
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameSearchBar.delegate = self
        RAWGClient.getGameList(completion: { (games, error) in
            GameModel.gameList = games
            DispatchQueue.main.async {
                self.gameTableView.reloadData()
            }
        })
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
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
    
    @IBAction func search(_ sender: Any) {
        gameSearchBar.isHidden = false
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        RAWGClient.search(query: searchText) { (games, error) in
            GameModel.searchGameList = games
            self.gameTableView.reloadData()
            print("Search: \(GameModel.searchGameList)")
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        gameSearchBar.isHidden = true
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameModel.gameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {

            let game = GameModel.gameList[indexPath.row]
            
            var genres = [String]()
            for genre in game.genres {
                let genreName = genre.name
                genres.append(genreName)
            }
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"

            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd, yyyy"

            if let date = dateFormatterGet.date(from: game.released) {
                cell.releaseGame.text = dateFormatterPrint.string(from: date)
            } else {
               print("There was an error decoding the string")
            }
            
            cell.genreGame.text = genres.joined(separator: ", ")
            
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

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
