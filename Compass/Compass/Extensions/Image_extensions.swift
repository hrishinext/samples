//
//  Image_extensions.swift
//  Compass
//
//  Created by Hrishi Amravatkar on 7/1/20.
//  Copyright © 2020 Hrishi Amravatkar. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
