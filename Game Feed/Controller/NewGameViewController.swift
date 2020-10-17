import UIKit

class NewGameViewController: UIViewController {
    @IBOutlet var newGameTableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var errorLabel: UILabel!
   
    var selectedIndex = 0
    var newGame = [Game]()
    
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
            self.present(createViewController, animated: true, completion: nil)
        } else {
            let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileScene") as! MyProfileViewController
            self.present(profileViewController, animated: true, completion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detail = segue.destination as? DetailGameViewController
            detail?.gameId = newGame[selectedIndex].idGame
        }
    }
    
    func setupView() {
        let now = Date()
        let oneMonthBefore = Calendar.current.date(byAdding: .month, value: -1, to: now)
        
        RAWGClient.getNewGameLastMonts(lastMonth: Formatter.formatDateToString(from: oneMonthBefore ?? Date()), now: Formatter.formatDateToString(from: now)) { (games, error) in
            if !games.isEmpty {
                self.newGame = games
                self.newGameTableView.reloadData()
                self.activityIndicator.stopAnimating()
            } else {
                self.errorLabel.isHidden = false
                self.activityIndicator.stopAnimating()
            }
        }
        
        newGameTableView.dataSource = self
        newGameTableView.delegate = self

        newGameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
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
