import UIKit
import Combine

class SearchGameViewController: UIViewController {
    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var cancellables = Set<AnyCancellable>()
    
    var games = [Game]()
    var selectedIndex = 0
    var currentSearchTask: AnyCancellable?
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detail = segue.destination as? DetailGameViewController
            detail?.gameId = games[selectedIndex].idGame
        }
    }
    
    func setupView() {
        searchBar.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        searchTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
}

extension SearchGameViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.activityIndicator.startAnimating()
        currentSearchTask?.cancel()
        currentSearchTask = RAWGClient.search(query: searchText)
            .sink(receiveCompletion: { completion in
                self.activityIndicator.stopAnimating()
                if case .failure(let error) = completion {
                    print("Search failed with error: \(error)")
                }
            }, receiveValue: { games in
                print("games : \(games)")
                if !games.isEmpty {
                    self.games = games
                    self.searchTableView.reloadData()
                } else {
                    // Handle no results case if needed
                }
            })
        
        if currentSearchTask != nil {
            currentSearchTask?.store(in: &cancellables)
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
    }
}

extension SearchGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {
            let game = games[indexPath.row]
            
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

extension SearchGameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: nil)
        searchTableView.deselectRow(at: indexPath, animated: true)
    }
}
