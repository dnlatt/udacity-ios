//
//  StandingsTableViewCell.swift
//  LattSports
//
//  Created by dnlatt on 2/10/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit

class StandingsTableViewCell: UITableViewCell {
    
    static let identifer = "StandingsTableViewCell"
    
    
    var standing : FootballLeagueStandings? {
        didSet {
            
            
            teamRank.text = standing?.rank ?? ""
            
            if (standing?.teamLogo != nil )
            {
                teamImage.image = UIImage(data: (standing?.teamLogo!)!)
            }
            else {
                 teamImage.image = UIImage(named: "flag")
            }
            teamNameLabel.text = standing?.teamName ?? ""
            teamPlayed.text = standing?.played
            teamWin.text = standing?.win
            teamDraw.text = standing?.draw
            teamLose.text = standing?.lose
            goalsDiff.text = standing?.goalsDiff
            points.text = standing?.points
            
        }
    }
    
    lazy var teamStandingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 6
        stackView.axis = .horizontal
        return stackView
    }()

    private let teamRank : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left

        return lbl
    }()
    
    private let teamImage : UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let teamNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let teamPlayed : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let teamWin : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let teamDraw : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let teamLose : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let goalsDiff : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let points : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    func setupView() {
        addSubview(teamStandingStackView)
        teamStandingStackView.addArrangedSubview(teamRank)
        teamStandingStackView.addArrangedSubview(teamImage)
        teamStandingStackView.addArrangedSubview(teamNameLabel)
        teamStandingStackView.addArrangedSubview(teamPlayed)
        teamStandingStackView.addArrangedSubview(teamWin)
        teamStandingStackView.addArrangedSubview(teamDraw)
        teamStandingStackView.addArrangedSubview(teamLose)
        teamStandingStackView.addArrangedSubview(goalsDiff)
        teamStandingStackView.addArrangedSubview(points)
        setupConstraints()
    }
    
    func setupConstraints()
    {
        
        NSLayoutConstraint.activate([
            teamStandingStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            teamStandingStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            teamStandingStackView.topAnchor.constraint(equalTo: topAnchor),
            teamStandingStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            teamRank.widthAnchor.constraint(equalTo: self.widthAnchor , multiplier: 0.05),
            teamImage.widthAnchor.constraint(equalTo: self.widthAnchor , multiplier: 0.05),
            teamNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor , multiplier: 0.3),
            teamPlayed.widthAnchor.constraint(equalTo: self.widthAnchor , multiplier: 0.05),
            teamWin.widthAnchor.constraint(equalTo: self.widthAnchor , multiplier: 0.05),
            teamDraw.widthAnchor.constraint(equalTo: self.widthAnchor , multiplier: 0.05),
            teamLose.widthAnchor.constraint(equalTo: self.widthAnchor , multiplier: 0.05),
            goalsDiff.widthAnchor.constraint(equalTo: self.widthAnchor , multiplier: 0.07),
            //goalsDiff.widthAnchor.constraint(equalTo: self.widthAnchor , multiplier: 0.05),
            
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
