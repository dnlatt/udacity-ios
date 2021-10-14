//
//  HomeViewController.swift
//  LattSports
//
//  Created by dnlatt on 27/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit
import CoreData
import SafariServices

class NewsViewController: UIViewController, UINavigationBarDelegate {
    
    
    // MARK: - Properties
    var coreDataArticles: [ArticleCD] = []
    
    // MARK: - UI
    
    let spinner = UIActivityIndicatorView(style: .large)
    
    
    lazy var tableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.identifer)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        return table
    }()
    
    private lazy var refreshButton: UIButton = {
        let buttonWidth = CGFloat(30)
        let buttonHeight = CGFloat(30)
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.up.arrow.down.circle"), for: .normal)
        button.addTarget(self, action: #selector(onRefreshButtonClicked), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        return button
    }()
    
   
    // MARK: - System Life Cycle
    
   override func viewDidLoad() {
    
        setupView()
    
        view.backgroundColor = .white
        super.viewDidLoad()
        title = "Home"
    
        // Check for Internet Connection
    
        if Utilites.connectedToNetwork() == false {
            Utilites.showMessage(title: "Error", message: "No Internet Connection", view: self)
            
            // Get Fresh Data
            getDataFromAPI()
            
        }
            
        else {
            
            // Get Data from Core Data
            guard let loadArticles = loadArticlesFromCoreData() else {
                return
            }
            
            if loadArticles.count > 0 {
                coreDataArticles = loadArticles
            }
            else
            {
                getDataFromAPI()
            }
            
        }
        
        
        setupLayout()

    }
    
    @objc func onRefreshButtonClicked(_ sender: Any){
        getDataFromAPI()
    }
  
    
    // Set up
    
    func setupView() {
        
        view.addSubview(tableView)        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: refreshButton)
        
         
    }
    
    func showActivityIndicator() {
        spinner.startAnimating()
        tableView.backgroundView = spinner
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // Refresh the Table
    
    func refreshUITable() {
        self.coreDataArticles = loadArticlesFromCoreData()!
        Utilites.performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
    }

}

// MARK: Table

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataArticles.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifer, for: indexPath) as! ArticleTableViewCell
        let articleData = self.coreDataArticles[indexPath.row]
        
        cell.article = articleData
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleData = self.coreDataArticles[indexPath.row]
        guard let url = URL(string: articleData.url!)  else {
            return
        }
        
        func didTapButton(cell: ArticleTableViewCell) {
            if let indexPath = tableView.indexPath(for: cell) {
                print(indexPath)
                print("tapped from cell")
            }
        }   
        
        let config = SFSafariViewController.Configuration()
        let safariViewController = SFSafariViewController(url: url, configuration: config)
        safariViewController.modalPresentationStyle = .fullScreen
        present(safariViewController, animated: true)
    }

}
extension NewsViewController {
    func completeGetData(response: ArticlesResponses?, error: Error?, success: Bool) {
        
        guard response != nil else {
            return
        }
        
        if success {
            //print(response?.articles)
            
            removeDataFromCoreData(articles: self.coreDataArticles)
            coreDataArticles.removeAll()
            
            if let records = response?.articles {
                for record in records {
                    addDataToCoreData(article: record)
                }
            }
            
        }
        else {
            
            
            Utilites.showMessage(title: "Error", message: "Something went wrong! Try again later", view: self)
            
        }
        
        refreshUITable()
        
    }
    
    func getDataFromAPI() {
        showActivityIndicator()
        NewsAPIClient.shared.getData(completion: completeGetData(response:error:success:), url: NewsAPIClient.Endpoints.getAllNews.url)
    }
    
    func addDataToCoreData(article: Article) {
    
        let articleToInsert = ArticleCD(context: DataController.shared.viewContext)
        articleToInsert.title = article.title
        articleToInsert.articleDescription = article.articleDescription ?? ""
        articleToInsert.url = article.url ?? ""
        articleToInsert.urlToImage = setPhotoImage(from: article.urlToImage ?? "")
        coreDataArticles.append(articleToInsert)
        do {
            try DataController.shared.viewContext.save()
        } catch {
            Utilites.showMessage(title: "Error", message: "Can't save data to device.", view: self)
        }

    }
    
    func setPhotoImage(from url: String) -> Data? {
        guard let imageURL = URL(string: url) else { return nil }
        guard let imageData = try? Data(contentsOf: imageURL) else { return nil }

        if let image = UIImage(data: imageData) {
            return image.jpegData(compressionQuality: 1.0)
        } else {
            return nil
        }
    }
    
    func removeDataFromCoreData(articles: [ArticleCD]) {
        for article in articles {
            DataController.shared.viewContext.delete(article)
        }
    }
}


// MARK: Fetched Results

extension NewsViewController : NSFetchedResultsControllerDelegate {
    
    func loadArticlesFromCoreData() -> [ArticleCD]? {
        do {
            var coreDataArticles: [ArticleCD] = []
            let articleFetchResultController = self.articleFetchedResultsController()
            
            try articleFetchResultController.performFetch()
            
            let totalArticles = try articleFetchResultController.managedObjectContext.count(for: articleFetchResultController.fetchRequest)
            for index in 0..<totalArticles {
                coreDataArticles.append(articleFetchResultController.object(at: IndexPath(row: index, section: 0)) as! ArticleCD)
            }
            return coreDataArticles
        } catch {
            return nil
        }
    }
    
    func articleFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        let articleFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticleCD")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        articleFetchRequest.sortDescriptors = [sortDescriptor]
        let articleFetchResultController = NSFetchedResultsController(fetchRequest: articleFetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        articleFetchResultController.delegate = self
        return articleFetchResultController
    }
    
}
