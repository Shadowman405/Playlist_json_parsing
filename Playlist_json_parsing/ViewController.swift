//
//  ViewController.swift
//  Playlist_json_parsing
//
//  Created by Maxim Mitin on 2.12.21.
//

import UIKit

class ViewController: UIViewController {
    
    let networkService = NetworkService()
    var searchResponce: SearchResponse? = nil
    private var timer: Timer?
    
    @IBOutlet weak var table: UITableView!
    let seacrhController = UISearchController(searchResultsController: nil)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = seacrhController
        seacrhController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        seacrhController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setupTableView() {
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponce?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        if let track = searchResponce?.results[indexPath.row] {
        cell.textLabel?.text = ("\(track.artistName)  \(track.trackName)")
        }
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let urlString = "https://itunes.apple.com/search?term=\(searchText)&limit=10"
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [self] _ in
            networkService.request(urlString: urlString) { [weak self] result in
                switch result {
                case .success(let searchResponse):
                    self?.searchResponce = searchResponse
                    self?.table.reloadData()
                    
                case .failure(let error):
                    print(error)
                }
            }
        })
    }
}
