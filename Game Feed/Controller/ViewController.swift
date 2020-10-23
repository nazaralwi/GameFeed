import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var errorLabel: UILabel!
    var selectedIndex = 0
    var gameList = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
        activityIndicator.startAnimating()
        
        setupView()
    }
    
    @IBAction func profileButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if !ProfileModel.stateLogin {
            let createViewController = storyboard.instantiateViewController(withIdentifier: "CreateScene") as! CreateViewController
            self.navigationController?.pushViewController(createViewController, animated: true)
//            self.present(createViewController, animated: true, completion: nil)
        } else {
            let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileScene") as! MyProfileViewController
            self.navigationController?.pushViewController(profileViewController, animated: true)
//            self.present(profileViewController, animated: true, completion: nil)
        }
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
            let detail = segue.destination as? DetailGameViewController
            detail?.gameId = gameList[selectedIndex].idGame
        }
    }
    
    func setupView() {
        self.gameTableView.contentInset.bottom = 10
        
        gameTableView.dataSource = self
        gameTableView.delegate = self
        
        RAWGClient.getGameList(completion: { (games, error) in
            if !games.isEmpty {
                self.gameList = games
                DispatchQueue.main.async {
                    self.gameTableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
                print("GameModel: \(self.gameList)")
            } else {
                self.errorLabel.isHidden = false
                self.activityIndicator.stopAnimating()
            }
        })
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {

            let game = gameList[indexPath.row]
            
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

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
