//
//  ViewController.swift
//  Playlist_json_parsing
//
//  Created by Maxim Mitin on 2.12.21.
//

import UIKit

class ViewController: UIViewController {
    
    let networkDataFetcher = NetworkDataFetcher()
    var searchResponce: SearchResponse? = nil
    private var timer: Timer?
    let seacrhController = UISearchController(searchResultsController: nil)
    
    
    @IBOutlet weak var table: UITableView!
    
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

//MARK: - Extensions

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
            networkDataFetcher.fetchTracks(urlString: urlString) { searchResponse in
                guard let searchResponce = searchResponse else {return}
                self.searchResponce = searchResponce
                self.table.reloadData()
            }
        })
    }
}
