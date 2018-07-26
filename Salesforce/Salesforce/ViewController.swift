//
//  ViewController.swift
//  Salesforce
//
//  Created by Hrishi Amravatkar on 7/24/18.
//  Copyright © 2018 Hrishi Amravatkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResults: UITableView!
    
    var resultFilms :Array<Film> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchResults.dataSource = self
        searchResults.delegate = self
        searchResults.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultFilms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FilmCell
        cell.filmPosterImage.image = nil
        let film = self.resultFilms[indexPath.row] 
        cell.filmTitle.text = film.title
        cell.filmDirector.text = film.director
        cell.filmPlot.text = film.plot
        cell.filmPosterImage.downloadFrom(link: film.poster, contentMode: .scaleAspectFit)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func searchItems() {
        guard let searchtext = searchBar.text, searchBar.text!.count > 2 else {
            return
        }
        let filmApi: FilmApi = FilmApi()
        filmApi.fetchFilms(searchText: searchtext, success: { (films) in
            self.resultFilms = films
            print(self.resultFilms)
            self.searchResults.reloadData()
        }) { (error) in
            print(error)
        }
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            resultFilms.removeAll()
            searchResults.reloadData()
        } else {
            searchItems()
        }
    }
}

