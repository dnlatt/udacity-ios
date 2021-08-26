//
//  SentMemeCollectionView.swift
//  MemeMe
//
//  Created by D Naung Latt on 25/08/2021.
//

import UIKit

class SentMemeCollectionView: UICollectionViewController {
    
    // MARK: IB Outlets
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    // MARK: Properties
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Flow Layout
        let space: CGFloat = 4.0
        let dimension = (view.frame.size.width - (3 * space)) / 4.0
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        //Add Button to Navigation Bar
        let addMeme = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addMeme(_:)) )
            self.navigationBar.rightBarButtonItem  = addMeme
        
    }
    
    @objc func addMeme(_ sender: AnyObject) {
        let addMeme = self.storyboard!.instantiateViewController(withIdentifier: "GenerateMeme") as! MemeEditorViewController
        present(addMeme, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Collection View
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (self.memes.count == 0) {
            self.collectionView.setEmptyMessage("No Meme Data!")
        } else {
            self.collectionView.restore()
        }

        return self.memes.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionCell", for: indexPath) as! SentMemeCollectionCellView
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.memeCellImage!.image = meme.memeImage
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {

        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailsViewController") as! MemeDetailsViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)

    }
}

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}
