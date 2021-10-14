//
//  MatchTableViewCell.swift
//  LattSports
//
//  Created by dnlatt on 6/10/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit

class MatchFixtureTableViewCell: UITableViewCell {
    static let identifer = "MatchTableViewCell"
    
    private lazy var awayTeamImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var awayTeam: UILabel = {
       let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var homeTeamImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let homeTeam : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0

        return lbl
    }()
    
    private let matchDateTime : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0

        return lbl
    }()
    
    var match : MatchFixtures? {
        didSet {
            
            
            if (match?.awayTeam != nil )
            {
                
                awayTeamImage.image = UIImage(named: (match?.awayTeam)!)
            }
            else {
                 awayTeamImage.image = UIImage(named: "flag")
            }
            
            if (match?.homeTeam != nil )
            {
                
                homeTeamImage.image = UIImage(named: (match?.homeTeam)!)
            }
            else {
                 homeTeamImage.image = UIImage(named: "flag")
            }
            
            awayTeam.text = match?.awayTeam ?? ""
            homeTeam.text = match?.homeTeam ?? ""
            
            let localISOFormatter = ISO8601DateFormatter()
            localISOFormatter.timeZone = TimeZone.current
            
            
            if (match?.matchDateTime != nil )
            {
                
                let dateString = (match?.matchDateTime!)!
                let localDate = localISOFormatter.date(from: dateString)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MMM-y HH:mm"
                matchDateTime.text = String(dateFormatter.string(from: localDate!))
    
            }
            
    
    
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()

        
    }
    
    func setupView() {
        addSubview(matchDateTime)
        addSubview(homeTeamImage)
        addSubview(homeTeam)
        addSubview(awayTeamImage)
        addSubview(awayTeam)
        
        setupConstraints()
    }
    
    func setupConstraints()
    {
        // Match Date / Time
        NSLayoutConstraint.activate([
            matchDateTime.leadingAnchor.constraint(equalTo: leadingAnchor),
            matchDateTime.trailingAnchor.constraint(equalTo: trailingAnchor),
            matchDateTime.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            matchDateTime.heightAnchor.constraint(equalToConstant: 20)
            
        ])
        
        // Home Image
        
        NSLayoutConstraint.activate([
            homeTeamImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            homeTeamImage.topAnchor.constraint(equalTo: matchDateTime.bottomAnchor, constant: 8 ),
            homeTeamImage.heightAnchor.constraint(equalToConstant: 25),
            homeTeamImage.widthAnchor.constraint(equalToConstant: 25)
        ])
    
        // Home Team
        
        NSLayoutConstraint.activate([
            homeTeam.leadingAnchor.constraint(equalTo: homeTeamImage.leadingAnchor, constant: 40),
            homeTeam.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            homeTeam.topAnchor.constraint(equalTo: matchDateTime.bottomAnchor, constant: 8 ),
        ])
        
        // Away Image
        
        NSLayoutConstraint.activate([
            awayTeamImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            awayTeamImage.topAnchor.constraint(equalTo: homeTeam.bottomAnchor, constant: 16 ),
            awayTeamImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            awayTeamImage.heightAnchor.constraint(equalToConstant: 25),
            awayTeamImage.widthAnchor.constraint(equalToConstant: 25)
            
        ])
        
        // Away Team
        
        NSLayoutConstraint.activate([
            awayTeam.leadingAnchor.constraint(equalTo: awayTeamImage.leadingAnchor, constant: 40),
            awayTeam.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            awayTeam.topAnchor.constraint(equalTo: homeTeam.bottomAnchor, constant: 16 ),
            awayTeam.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
            
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
