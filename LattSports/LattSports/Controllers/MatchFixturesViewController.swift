//
//  NewsViewController.swift
//  LattSports
//
//  Created by dnlatt on 27/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit
import CoreData
import Network

class MatchFixturesViewController: UIViewController, NetworkCheckObserver  {
    
    // MARK: - Properties
    var coreDataMatchFixtures: [MatchFixtures] = []
    var networkCheck = NetworkCheck.sharedInstance()
    
    // MARK: UI
    private let refreshControl = UIRefreshControl()
    let spinner = UIActivityIndicatorView(style: .large)
    
    lazy var tableView : UITableView = {
        let table = UITableView()
        table.register(MatchFixtureTableViewCell.self, forCellReuseIdentifier: MatchFixtureTableViewCell.identifer)
        table.delegate = self
        table.dataSource = self
        if #available(iOS 10.0, *) {
            table.refreshControl = refreshControl
        } else {
            table.addSubview(refreshControl)
            
        }
        return table
    }()
    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Fixtures"
        
        setupView()
        
        
        if networkCheck.currentStatus == .satisfied  {
            // Get Fresh Data
            getDataFromAPI()
        }
        else {
            
            Utilites.showMessage(title: "Error", message: "No Internet Connection", view: self)
            disableRefreshControl()
            
            // Get Data from Core Data
            guard let loadFixtures = loadMatchFixturesFromCoreData() else {
                return
            }
            
            if loadFixtures.count > 0 {
                coreDataMatchFixtures = loadFixtures
            }
    
        }
        
        setupLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkCheck.addObserver(observer: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        networkCheck.removeObserver(observer: self)
    }
    
    func statusDidChange(status: NWPath.Status) {
        print(status)
        if(status == .unsatisfied) {
            Utilites.showMessage(title: "Error", message: "No Internet Connection", view: self)
            disableRefreshControl()
        }
        
        if(status == .satisfied) {
            enableRefreshControl()
        }
        
    }
    
    func disableRefreshControl() {
        self.tableView.refreshControl = nil
        self.refreshControl.endRefreshing()
    }
    
    func enableRefreshControl() {
        self.tableView.refreshControl = refreshControl
    }
        
    // MARK: Set up
    
    func setupView() {
        
        view.addSubview(tableView)
        
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: refreshButton)
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
    }
    
    func showActivityIndicator() {
        spinner.startAnimating()
        tableView.backgroundView = spinner
    }
    
    func setupLayout() {
        tableView.frame = view.bounds
    }
    
    
    @objc private func refreshData(_ sender: Any) {
        getDataFromAPI()
        
        
    }
    
    func getAllMatchFixtures (completion: @escaping (MatchResponse?, Error?, Bool) -> Void) {
        
        MatchAPI.shared.taskForGETRequest(url: MatchAPI.Endpoints.getFixtures.url, responseType: MatchResponse.self) { (response, error) in
            if let response = response {
                completion(response.self, nil, true)
                
            } else {
                completion(nil, error, false)
                
            }
        }
    }
    
    func addDataToCoreData(match: Match) {
    
        let matchToInsert = MatchFixtures(context: DataController.shared.viewContext)

        matchToInsert.awayTeam = match.awayTeam.name
        matchToInsert.homeTeam = match.homeTeam.name
        matchToInsert.matchDateTime = match.utcDate
        coreDataMatchFixtures.append(matchToInsert)
        
        do {
            try DataController.shared.viewContext.save()
            //print("Saving to Core Data")
        } catch {
            Utilites.showMessage(title: "Error", message: "Can't save data to device.", view: self)
        }
        
        refreshUITable()

        
    }
    
    
    func removeDataFromCoreData(matchFixtures: [MatchFixtures]) {
        for matchFixture in matchFixtures {
            DataController.shared.viewContext.delete(matchFixture)
        }
    }
    
    func refreshUITable() {
        self.coreDataMatchFixtures = loadMatchFixturesFromCoreData()!
        Utilites.performUIUpdatesOnMain {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        
    }
    
    func getDataFromAPI() {
        
        showActivityIndicator()
        
        getAllMatchFixtures { (response, error, success) in
            guard response != nil else {
                return
            }
            
            if success {
                // Delete from Core Data
                self.removeDataFromCoreData(matchFixtures: self.coreDataMatchFixtures)
                self.coreDataMatchFixtures.removeAll()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
                // Add Data to Core Data
                if let matches = response?.matches {
                    for match in matches {
                        self.addDataToCoreData(match: match)
                    }
                }
                
                
            }
            else {
            
                guard Utilites.connectedToNetwork() == false else {
                    Utilites.showMessage(title: "Error", message: "No Internet Connection", view: self)
                    return
                }
                
                Utilites.showMessage(title: "Error", message: "Something went wrong! Try again later", view: self)
                 
            }
        }
        
        
    }

}

// MARK: Table

extension MatchFixturesViewController: UITableViewDelegate, UITableViewDataSource {
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataMatchFixtures.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchFixtureTableViewCell.identifer, for: indexPath) as! MatchFixtureTableViewCell
        let match = self.coreDataMatchFixtures[indexPath.row]
        
        cell.match = match
        return cell
        
    }

}

// MARK: Fetched Results

extension MatchFixturesViewController : NSFetchedResultsControllerDelegate {
    
    func loadMatchFixturesFromCoreData() -> [MatchFixtures]? {
        do {
            var coreDataMatchFixtures: [MatchFixtures] = []

            let matchFixturesFetchResultController = self.matchFixturesFetchedResultsController()
            
            try matchFixturesFetchResultController.performFetch()
            
            let matches = try matchFixturesFetchResultController.managedObjectContext.count(for: matchFixturesFetchResultController.fetchRequest)
            for index in 0..<matches {
                coreDataMatchFixtures.append(matchFixturesFetchResultController.object(at: IndexPath(row: index, section: 0)) as! MatchFixtures)
            }
            return coreDataMatchFixtures
        } catch {
            return nil
        }
    }
    
    func matchFixturesFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        let matchFixturesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MatchFixtures")
        let sortDescriptor = NSSortDescriptor(key: "fixtureID", ascending: true)
        matchFixturesFetchRequest.sortDescriptors = [sortDescriptor]
        let matchFixturesFetchResultController = NSFetchedResultsController(fetchRequest: matchFixturesFetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        matchFixturesFetchResultController.delegate = self
        return matchFixturesFetchResultController
    }
    
}
