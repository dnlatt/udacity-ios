//
//  ViewController.swift
//  LattSports
//
//  Created by dnlatt on 27/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit
import CoreData

class LattSportsHomeViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        style()
        
    }

}

extension LattSportsHomeViewController {
    
    func setUp() {
      
        let homeVC = UINavigationController(rootViewController: NewsViewController())
        let fixturesVC = UINavigationController(rootViewController: MatchFixturesViewController())
        let matchesVC = UINavigationController(rootViewController: MatchResultsViewController())
        let standingsVC = UINavigationController(rootViewController: StandingsViewController())
        
        
        homeVC.title = "Home"
        fixturesVC.title = "Fixtures"
        matchesVC.title = "Results"
        standingsVC.title = "Standings"
        
        self.setViewControllers([homeVC, fixturesVC, matchesVC, standingsVC], animated: false)
        
    }
    
    func style() {
        
        guard let items = self.tabBar.items else { return }
        
        let images = ["house", "square.and.pencil", "square.grid.2x2", "list.dash"]
        for x in 0..<images.count {
            items[x].image = UIImage(systemName: images[x])
        }
        self.tabBar.tintColor = .black
        
    }
}


