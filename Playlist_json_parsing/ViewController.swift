//
//  ViewController.swift
//  Playlist_json_parsing
//
//  Created by Maxim Mitin on 2.12.21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    let seacrhController = UISearchController(searchResultsController: nil)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        
        let urlString = "https://itunes.apple.com/search?term=jack+johnson&limit=25"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    return
                }
                
                guard let data = data else {return}
                let someString = String(data: data, encoding: .utf8)
                print(someString ?? "no data")
            }
        }.resume()
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = "123"
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
