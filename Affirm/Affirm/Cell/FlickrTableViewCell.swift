//
//  FlickrTableViewCell.swift
//  Affirm
//
//  Created by Hrishi Amravatkar on 7/17/18.
//  Copyright © 2018 Hrishi Amravatkar. All rights reserved.
//

import UIKit

class FlickrTableViewCell: UITableViewCell {

    @IBOutlet weak var flickrPhoto: UIImageView!
    @IBOutlet weak var flickrPhotoTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
