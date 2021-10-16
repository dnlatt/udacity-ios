//
//  StandingsViewController.swift
//  LattSports
//
//  Created by dnlatt on 27/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit
import CoreData
import Network

class StandingsViewController: UIViewController, NetworkCheckObserver {
    
    var activityView: UIActivityIndicatorView?
    
    // MARK: - Properties
    
    var coreDataStandings: [FootballLeagueStandings] = []
    var networkCheck = NetworkCheck.sharedInstance()
    
    // MARK: UI
    
    private let refreshControl = UIRefreshControl()
    
    let spinner = UIActivityIndicatorView(style: .large)
    
    lazy var standingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var tableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(StandingsTableViewCell.self, forCellReuseIdentifier: StandingsTableViewCell.identifer)
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 50
        table.separatorStyle = .none
        table.headerView(forSection: 0)
        
        if #available(iOS 10.0, *) {
            table.refreshControl = refreshControl
        } else {
            table.addSubview(refreshControl)
            
        }
        
        return table
    }()
    
    private var header: StandingsHeaderView = {
        
        let header = StandingsHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    private lazy var refreshButton: UIButton = {
        let buttonWidth = CGFloat(30)
        let buttonHeight = CGFloat(30)
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.up.arrow.down.circle"), for: .normal)
        button.addTarget(self, action: #selector(refreshData), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Standings"
        view.backgroundColor = .white
        
        setupView()
        
        if networkCheck.currentStatus == .unsatisfied {
            Utilites.showMessage(title: "Error", message: "No Internet Connection", view: self)
            disableRefreshControl()
        }
        
        // Getting Data from Core Data
        guard let loadStandings = loadStandingsFromCoreData() else {
            return
        }
        if loadStandings.count > 0 {
            coreDataStandings = loadStandings
        }
    
        else
        {
            if networkCheck.currentStatus == .satisfied {
                // Get Data from API
                getDataFromAPI()
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
    
    @objc private func refreshData(_ sender: Any) {
        getDataFromAPI()
    }
    
    func showActivityIndicator() {
        spinner.startAnimating()
        tableView.backgroundView = spinner
    }
    
    @objc func onRefreshButtonClicked(_ sender: Any){
       getDataFromAPI()
    }
    
    func setupView() {
        
        view.addSubview(standingStackView)
        standingStackView.addArrangedSubview(header)
        standingStackView.addArrangedSubview(tableView)
        let spinner = UIActivityIndicatorView(style: .medium)

        spinner.startAnimating()
        tableView.backgroundView = spinner
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: refreshButton)
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)

    }
    
    func setupLayout() {
        
        NSLayoutConstraint.activate([
            standingStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            standingStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            standingStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            standingStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8),
            header.heightAnchor.constraint(equalToConstant: 15  )

        ])
        
    }

    // Refresh the Table
    func refreshUITable() {
        self.coreDataStandings = loadStandingsFromCoreData()!
        Utilites.performUIUpdatesOnMain {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        
    }
    
    
    
    func getDataFromAPI() {
        
        if networkCheck.currentStatus == .satisfied {
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
                        
                            
                            Utilites.showMessage(title: "Error", message: "Something went wrong! Try again later", view: self)
                        }
                    }
            
        }
        
        else {
            Utilites.showMessage(title: "Error", message: "No internet connection!", view: self)
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
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//            return header
//    }
    
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
