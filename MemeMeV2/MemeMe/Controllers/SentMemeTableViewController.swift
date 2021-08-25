//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by D Naung Latt on 25/08/2021.
//

import UIKit

class SentMemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    
    var memes: [Meme]! {
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            return appDelegate.memes
        }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
       
    override func viewDidLoad() {
    
        super.viewDidLoad()
        let addMeme = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addMeme(_:)) )
            self.navigationBar.rightBarButtonItem  = addMeme
       
    }
    
    @objc func addMeme(_ sender: AnyObject) {
        let addMeme = self.storyboard!.instantiateViewController(withIdentifier: "GenerateMeme") as! MemeEditorViewController
        present(addMeme, animated: true, completion: nil)
    }
    
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.imageView?.image = meme.memeImage
        cell.textLabel?.text = meme.topText

        return cell
    }
}
