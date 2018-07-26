//
//  UIImage_Extension.swift
//  Salesforce
//
//  Created by Hrishi Amravatkar on 7/24/18.
//  Copyright © 2018 Hrishi Amravatkar. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadFrom(link:String?, contentMode mode: UIViewContentMode) {
        contentMode = mode
        image = UIImage(named: "default")
        if link != nil, let url = NSURL(string: link!) {
            URLSession.shared.dataTask(with: url as URL) { data, response, error in
                guard let data = data,
                    error == nil else {
                    print("\nerror on download \(String(describing: error))")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode != 200 {
                    print("statusCode != 200; \(httpResponse.statusCode)")
                    return
                }
                DispatchQueue.main.async() {
                    print("\ndownload completed \(url.lastPathComponent!)")
                    self.image = UIImage(data: data)
                }
                }.resume()
        } else {
            self.image = UIImage(named: "default")
        }
    }
}
