//
//  ViewController.swift
//  Affirm
//
//  Created by Hrishi Amravatkar on 7/16/18.
//  Copyright © 2018 Hrishi Amravatkar. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResults: UITableView!
    var flickrData: Array = [Photo]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchResults.tableFooterView = UIView()
        searchResults.delegate = self
        searchResults.dataSource = self
        searchBar.delegate = self
    }
    
    func searchItems() {
        guard let searchtext = searchBar.text, searchBar.text!.count > 2 else {
            return
        }
        let flickrApi: FlickrApi = FlickrApi()
        flickrApi.searchFlickr(searchText: searchtext, success: { (photos) in
            print(photos)
            self.flickrData = photos
            DispatchQueue.main.async {
                self.searchResults.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ViewController: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.flickrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FlickrTableViewCell.self), for: indexPath) as! FlickrTableViewCell
        cell.flickrPhotoTitle.text = self.flickrData[indexPath.row].title
        print(self.flickrData[indexPath.row].url!)
        cell.flickrPhoto.sd_setImage(with: URL(string: self.flickrData[indexPath.row].url!), placeholderImage: UIImage(named: "placeholder.png"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FlickrTableViewCell
        // Safe Present
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoViewController") as? PhotoViewController
        {
            print(self.flickrData[indexPath.row].url!)
            vc.fullScreenImage = cell.flickrPhoto.image
            present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            flickrData.removeAll()
            searchResults.reloadData()
        } else {
            searchItems()
        }
    }
    
}
