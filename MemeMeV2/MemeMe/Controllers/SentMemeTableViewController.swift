//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by D Naung Latt on 25/08/2021.
//

import UIKit

class SentMemeTableViewController: UITableViewController {
    
    
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var memes: [Meme]! {
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            return appDelegate.memes
        }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
       
    override func viewDidLoad() {
    
        super.viewDidLoad()
        tableView.rowHeight = 120
        let addMeme = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addMeme(_:)) )
            self.navigationBar.rightBarButtonItem  = addMeme
       
    }
    
    @objc func addMeme(_ sender: AnyObject) {
        let addMeme = self.storyboard!.instantiateViewController(withIdentifier: "GenerateMeme") as! MemeEditorViewController
        present(addMeme, animated: true, completion: nil)
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.memes.count>0)
        {
            tableView.backgroundView = nil
        }
        else {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No Meme Data!"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            
        }
        
        return self.memes.count
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.imageView?.image = meme.memeImage
        cell.textLabel?.text = "\(meme.topText) \(meme.bottomText)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailsViewController") as! MemeDetailsViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}


