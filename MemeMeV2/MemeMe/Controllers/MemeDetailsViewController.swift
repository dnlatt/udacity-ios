//
//  MemeDetailsViewController.swift
//  MemeMe
//
//  Created by D Naung Latt on 26/08/2021.
//

import UIKit

class MemeDetailsViewController: UIViewController {
    
    // MARK: Properties

    var meme: Meme!
    
    // MARK: Outlets
    
    @IBOutlet weak var memeImage: UIImageView!

    // MARK: Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.memeImage!.image = meme.memeImage
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
