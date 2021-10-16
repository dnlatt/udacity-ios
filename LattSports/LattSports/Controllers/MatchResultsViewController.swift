//
//  MatchesViewController.swift
//  LattSports
//
//  Created by dnlatt on 27/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit
import CoreData
import Network

class MatchResultsViewController: UIViewController, NetworkCheckObserver  {
    
    // MARK: Properties
    var coreDataMatchResults: [MatchResults] = []
    var networkCheck = NetworkCheck.sharedInstance()

    // MARK: UI
    private let refreshControl = UIRefreshControl()
    let spinner = UIActivityIndicatorView(style: .large)
    
    lazy var tableView : UITableView = {
        let table = UITableView()
        table.register(MatchResultTableViewCell.self, forCellReuseIdentifier: MatchResultTableViewCell.identifer)
        table.delegate = self
        table.dataSource = self
        if #available(iOS 10.0, *) {
            table.refreshControl = refreshControl
        } else {
            table.addSubview(refreshControl)
            
        }
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
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        title = "Results"

        setupView()
        
        // Check for Internet Connection
        
        if networkCheck.currentStatus == .satisfied {
            // Get Fresh Data
            getDataFromAPI()
        }
        else {
            
            Utilites.showMessage(title: "Error", message: "No Internet Connection", view: self)
            disableRefreshControl()
            
            guard let loadReults = loadMatchResultsFromCoreData() else {
                return
            }
            
            if loadReults.count > 0 {
                coreDataMatchResults = loadReults
                coreDataMatchResults.reverse()
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
    
    
    func setupView() {
        
        view.addSubview(tableView)
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: refreshButton)
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        getDataFromAPI()
        
    }
    
    func showActivityIndicator() {
        spinner.startAnimating()
        tableView.backgroundView = spinner
    }
    
    func setupLayout() {
        tableView.frame = view.bounds
    }
    

    @objc func onRefreshButtonClicked(_ sender: Any){
       getDataFromAPI()
    }

    // MARK: Set up


    func getAllMatchResults (completion: @escaping (MatchResponse?, Error?, Bool) -> Void) {
       
       MatchAPI.shared.taskForGETRequest(url: MatchAPI.Endpoints.getResults.url, responseType: MatchResponse.self) { (response, error) in
           if let response = response {
               completion(response.self, nil, true)
               
           } else {
               completion(nil, error, false)
               
           }
       }
    }


    func getDataFromAPI() {
        
        showActivityIndicator()
        
       getAllMatchResults { (response, error, success) in
           guard response != nil else {
               return
           }
           
           if success {
               
               if let matches = response?.matches {
                   for match in matches {
                       self.addDataToCoreData(match: match)
                   }
               }
               
               
           }
           else {
               guard Utilites.connectedToNetwork() == true else {
                   Utilites.showMessage(title: "Error", message: "No Internet Connection", view: self)
                   return
               }
               
               Utilites.showMessage(title: "Error", message: "Something went wrong! Try again later", view: self)
           }
       }
       
     
       
    }

    func addDataToCoreData(match: Match) {

       let matchToInsert = MatchResults(context: DataController.shared.viewContext)

       matchToInsert.awayTeam = match.awayTeam.name
       matchToInsert.homeTeam = match.homeTeam.name
       matchToInsert.matchDateTime = match.utcDate
       
       if let homeScore = match.score.fullTime.homeTeam {
           matchToInsert.homeTeamScore = Int16(homeScore)
       }
       
       if let awayScore = match.score.fullTime.homeTeam {
           matchToInsert.awayTeamScore = Int16(awayScore)
       }

       
       coreDataMatchResults.append(matchToInsert)
       
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
        self.coreDataMatchResults = loadMatchResultsFromCoreData()!
        self.coreDataMatchResults.reverse()
        Utilites.performUIUpdatesOnMain {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        
    }
}


// MARK: Table

extension MatchResultsViewController: UITableViewDelegate, UITableViewDataSource {
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataMatchResults.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchResultTableViewCell.identifer, for: indexPath) as! MatchResultTableViewCell
        let match = self.coreDataMatchResults[indexPath.row]
        
        cell.match = match
        return cell
        
    }

}

// MARK: Fetched Results

extension MatchResultsViewController : NSFetchedResultsControllerDelegate {
    
    func loadMatchResultsFromCoreData() -> [MatchResults]? {
        do {
            var coreDataMatchResults: [MatchResults] = []

            let matchResultsFetchResultController = self.matchResultsFetchedResultsController()
            
            try matchResultsFetchResultController.performFetch()
            
            let matches = try matchResultsFetchResultController.managedObjectContext.count(for: matchResultsFetchResultController.fetchRequest)
            for index in 0..<matches {
                coreDataMatchResults.append(matchResultsFetchResultController.object(at: IndexPath(row: index, section: 0)) as! MatchResults)
            }
            return coreDataMatchResults
        } catch {
            return nil
        }
    }
    
    func matchResultsFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        let matchResultsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MatchResults")
        let sortDescriptor = NSSortDescriptor(key: "resultID", ascending: true)
        matchResultsFetchRequest.sortDescriptors = [sortDescriptor]
        let matchResultsFetchResultController = NSFetchedResultsController(fetchRequest: matchResultsFetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        matchResultsFetchResultController.delegate = self
        return matchResultsFetchResultController
    }
    
}
