//
//  PhotoTableViewController.swift
//  Compass
//
//  Created by Hrishi Amravatkar on 7/1/20.
//  Copyright © 2020 Hrishi Amravatkar. All rights reserved.
//

import UIKit

class PhotoTableViewController: UITableViewController {

    var photosList: [Photo] = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //api call
        let photoApi = PhotosApi()
        
        photoApi.fetchPhotos(success: { (photos: [Photo]) in
            
            self.photosList = photos
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }) { (error) in
            //Todo: handle error
            print(error)
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.photosList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        cell.tag = indexPath.row
        let photo = self.photosList[indexPath.row]
        let url = URL(string: photo.thumbnailUrl)
        guard let urlValue = url else {
            return cell
        }
        cell.photoImage.image = nil
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: urlValue) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        //get cell based on tag
                        cell.photoImage.image = image
                        cell.setNeedsLayout()
                    }
                }
            }
        }
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
