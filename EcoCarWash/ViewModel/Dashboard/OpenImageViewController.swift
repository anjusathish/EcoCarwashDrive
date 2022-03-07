//
//  OpenImageViewController.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 03/12/21.
//

import UIKit

class OpenImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let selectedImage = selectedImage {
            imageView.image = selectedImage
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
