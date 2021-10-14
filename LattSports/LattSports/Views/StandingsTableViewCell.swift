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
    
    lazy var backView: UIView = {
        let view = UIView(frame: CGRect(x: 10, y: 6, width: self.frame.width, height: 50))
        //view.backgroundColor = UIColor(r: 20, g: 39, b: 77)
        
        //view.backgroundColor = .green
        return view
    }()
    
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

    private let teamRank : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        lbl.textAlignment = .left

        return lbl
    }()
    
    private let teamImage : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let teamNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let teamPlayed : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let teamWin : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let teamDraw : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let teamLose : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let goalsDiff : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let points : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        addSubview(teamRank)
        addSubview(teamImage)
        addSubview(teamNameLabel)
        addSubview(teamPlayed)
        addSubview(teamWin)
        addSubview(teamDraw)
        addSubview(teamLose)
        addSubview(goalsDiff)
        addSubview(points)
        
        teamRank.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 20, height: 0, enableInsets: false)
        teamImage.anchor(top: topAnchor, left: teamRank.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 20, height: 0, enableInsets: false)
        teamNameLabel.anchor(top: topAnchor, left: teamImage.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 130, height: 0, enableInsets: false)
        teamPlayed.anchor(top: topAnchor, left: teamNameLabel.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 20, height: 0, enableInsets: false)
        teamWin.anchor(top: topAnchor, left: teamPlayed.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 20, height: 0, enableInsets: false)
        teamDraw.anchor(top: topAnchor, left: teamWin.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 20, height: 0, enableInsets: false)
        teamLose.anchor(top: topAnchor, left: teamDraw.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 20, height: 0, enableInsets: false)
        goalsDiff.anchor(top: topAnchor, left: teamLose.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 20, height: 0, enableInsets: false)
        points.anchor(top: topAnchor, left: goalsDiff.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 25, height: 0, enableInsets: false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
