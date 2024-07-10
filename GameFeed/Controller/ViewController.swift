import UIKit
import Combine

class ViewController: UIViewController {
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var errorLabel: UILabel!
    var selectedIndex = 0
    var gameList = [Game]()
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
        
        gameTableView.refreshControl = UIRefreshControl()
        gameTableView.refreshControl?.tintColor = UIColor.gray
        gameTableView.refreshControl?.addTarget(self, action: #selector(fetchGameList), for: UIControl.Event.valueChanged)
        
        errorLabel.isHidden = true
        activityIndicator.startAnimating()
                
        RAWGClient.getGameList().sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                self.gameTableView.reloadData()
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                self.errorLabel.isHidden = false
                self.activityIndicator.stopAnimating()
            }
        }, receiveValue: { games in
            self.gameList = games
        })
        .store(in: &cancellables)

                
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
    
    @objc func fetchGameList() {
        var cancellables = Set<AnyCancellable>()
        
        RAWGClient.getGameList().sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                self.gameTableView.reloadData()
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                self.errorLabel.isHidden = false
                self.activityIndicator.stopAnimating()
            }
        }, receiveValue: { games in
            self.gameList = games
        })
        .store(in: &cancellables)

        DispatchQueue.main.async {
           self.gameTableView.refreshControl?.endRefreshing()
        }
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
                RAWGClient.downloadBackground(backgroundPath: backgroundPath)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            print("Image download finished successfully.")
                        case .failure(let error):
                            print("Image download failed with error: \(error)")
                        }
                    }, receiveValue: { data in
                        guard let image = UIImage(data: data) else {
                            return
                        }
                        cell.photoGame.image = image
                        cell.setNeedsLayout()
                        cell.photoGame.roundCorners(corners: [.topRight, .topLeft], radius: 10)
                    })
                    .store(in: &cancellables)
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
