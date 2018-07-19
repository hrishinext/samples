//
//  PhotoViewController.swift
//  Affirm
//
//  Created by Hrishi Amravatkar on 7/17/18.
//  Copyright © 2018 Hrishi Amravatkar. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet var fullScreenImageView: UIImageView!
    @IBOutlet var closeButton: UIButton!
    var fullScreenImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.closeButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        self.fullScreenImageView.image = fullScreenImage
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
