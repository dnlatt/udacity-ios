//
//  StandingsViewController.swift
//  LattSports
//
//  Created by dnlatt on 27/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit
import CoreData

class StandingsViewController: UIViewController {

    var activityView: UIActivityIndicatorView?
    
    // MARK: - Properties
    
    var coreDataStandings: [FootballLeagueStandings] = []
    
    // MARK: UI
    
    let spinner = UIActivityIndicatorView(style: .large)
    
    lazy var tableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(StandingsTableViewCell.self, forCellReuseIdentifier: StandingsTableViewCell.identifer)
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 50
        table.separatorStyle = .none
        table.headerView(forSection: 0)
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
        title = "Standings"
        view.backgroundColor = .white
        
        setupView()
        
        // Check for Internet Connection
        
        if Utilites.connectedToNetwork() == false {
            Utilites.showMessage(title: "Error", message: "No Internet Connection", view: self)
            // Get Fresh Data
            getDataFromAPI()
            
        }
        else
        {
            // Getting Data from Core Data
            guard let loadStandings = loadStandingsFromCoreData() else {
                return
            }


            if loadStandings.count > 0 {
                coreDataStandings = loadStandings
            }
            else
            {
                getDataFromAPI()
            }
            
        }
        

        
        
        
        setupLayout()
 
    }
    
    

    // MARK: Set up
    
    
    
    func setupView() {
        
        //view.addSubview(headerView)
        view.addSubview(tableView)
        let spinner = UIActivityIndicatorView(style: .medium)

        spinner.startAnimating()
        tableView.backgroundView = spinner
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: refreshButton)

    }
    
    func showActivityIndicator() {
        spinner.startAnimating()
        tableView.backgroundView = spinner
    }
    
    @objc func onRefreshButtonClicked(_ sender: Any){
        print("tap reload")
       getDataFromAPI()
    }
    
    func setupLayout() {
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }

    // Refresh the Table
    func refreshUITable() {
        self.coreDataStandings = loadStandingsFromCoreData()!
        Utilites.performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
    }
    
    
    
    func getDataFromAPI() {
        
        // MatchAPI.shared.getData(completion: completeGetData(response:error:success:), url: MatchAPI.Endpoints.getStandings.url)
        showActivityIndicator()
        
        getStandings { (response, error, success) in
            guard response != nil else {
                        return
                    }
                    
                    if success {
                //print(" Success \(response?.response)")
                
                // Delete from Core Data
                self.removeDataFromCoreData(footballLeagueStandings: self.coreDataStandings)
                self.coreDataStandings.removeAll()
                
                let tableHeader = FootballLeagueStandings(context: DataController.shared.viewContext)
                tableHeader.rank = "#"
                tableHeader.points = "PTS"
                tableHeader.teamLogo = nil
                tableHeader.teamName = "Club"
                tableHeader.played = "MP"
                tableHeader.win = "W"
                tableHeader.draw = "D"
                tableHeader.lose = "L"
                tableHeader.goalsDiff = "GD"
                self.coreDataStandings.append(tableHeader)
                
                // Insert to Core Data
                if let records = response?.response {
                    for record in records {
                        
                        let standings = record.league.standings
                        for teams in standings {
                            for leagueTeam in teams {
                                self.addDataToCoreData(teamStanding: leagueTeam)
                            }
                        }
                    }
                }
                
                self.refreshUITable()
                
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
    
    func getStandings (completion: @escaping (LeagueStandingResponse?, Error?, Bool) -> Void) {
        
        let url = URL(string: "https://raw.githubusercontent.com/dnlatt/test2/master/LeagueStandingsResponse.json")
        
        MatchAPI.shared.taskForGETRequest(url: url!, responseType: LeagueStandingResponse.self) { (response, error) in
            if let response = response {
                completion(response.self, nil, true)
                
            } else {
                completion(nil, error, false)
            }
        }
    }
    
    
    func addDataToCoreData(teamStanding: Standing) {
    
        let teamToInsert = FootballLeagueStandings(context: DataController.shared.viewContext)

        teamToInsert.position = Int16(teamStanding.rank)
        teamToInsert.rank = String(teamStanding.rank)
        teamToInsert.points = String(teamStanding.points)
        teamToInsert.teamLogo = setPhotoImage(from: teamStanding.team.logo ?? "")
        teamToInsert.teamName = teamStanding.team.name
        teamToInsert.played = String(teamStanding.all.played)
        teamToInsert.win = String(teamStanding.all.win)
        teamToInsert.draw = String(teamStanding.all.draw)
        teamToInsert.lose = String(teamStanding.all.lose)
        teamToInsert.goalsDiff = String(teamStanding.goalsDiff)
        coreDataStandings.append(teamToInsert)
        do {
            try DataController.shared.viewContext.save()
            //print("Saving to Core Data")
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
    
    func removeDataFromCoreData(footballLeagueStandings: [FootballLeagueStandings]) {
        for footballLeagueStanding in footballLeagueStandings {
            DataController.shared.viewContext.delete(footballLeagueStanding)
        }
    }
}


// MARK: Table

extension StandingsViewController: UITableViewDelegate, UITableViewDataSource {
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataStandings.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StandingsTableViewCell.identifer, for: indexPath) as! StandingsTableViewCell
        let standing = self.coreDataStandings[indexPath.row]
        cell.standing = standing
        return cell
        
        
    }

}

// MARK: Fetched Results

extension StandingsViewController : NSFetchedResultsControllerDelegate {
    
    func loadStandingsFromCoreData() -> [FootballLeagueStandings]? {
        do {
            var coreDataStandings: [FootballLeagueStandings] = []
            
            
            let standingFetchResultController = self.standingFetchedResultsController()
            
            try standingFetchResultController.performFetch()
            
            let standingTeams = try standingFetchResultController.managedObjectContext.count(for: standingFetchResultController.fetchRequest)
            for index in 0..<standingTeams {
                coreDataStandings.append(standingFetchResultController.object(at: IndexPath(row: index, section: 0)) as! FootballLeagueStandings)
            }
            return coreDataStandings
        } catch {
            return nil
        }
    }
    
    func standingFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        let standingFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FootballLeagueStandings")
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: true)
        standingFetchRequest.sortDescriptors = [sortDescriptor]
        let standingFetchResultController = NSFetchedResultsController(fetchRequest: standingFetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        standingFetchResultController.delegate = self
        return standingFetchResultController
    }
    
}
