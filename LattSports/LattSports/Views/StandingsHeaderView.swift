//
//  StandingsHeaderView.swift
//  LattSports
//
//  Created by dnlatt on 15/10/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit

class StandingsHeaderView: UIView {

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
        lbl.text = "#"
        return lbl
    }()
    
    private let teamImage : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "flag")
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
        lbl.text = "Club"
        return lbl
    }()
    
    private let teamPlayed : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left
        lbl.text = "MP"
        return lbl
    }()
    
    private let teamWin : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left
        lbl.text = "W"
        return lbl
    }()
    
    private let teamDraw : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left
        lbl.text = "D"
        return lbl
    }()
    
    private let teamLose : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left
        lbl.text = "L"
        return lbl
    }()
    
    private let goalsDiff : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left
        lbl.text = "GD"
        return lbl
    }()
    
    private let points : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textAlignment = .left
        lbl.text = "PTS"
        return lbl
    }()
    
    
    
    init() {
        super.init(frame: .zero)
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
               teamPlayed.widthAnchor.constraint(equalTo: self.widthAnchor , multiplier: 0.06),
               teamWin.widthAnchor.constraint(equalTo: self.widthAnchor , multiplier: 0.05),
               teamDraw.widthAnchor.constraint(equalTo: self.widthAnchor , multiplier: 0.05),
               teamLose.widthAnchor.constraint(equalTo: self.widthAnchor , multiplier: 0.05),
               goalsDiff.widthAnchor.constraint(equalTo: self.widthAnchor , multiplier: 0.06),
               
           ])
           

           
       }
    
    
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

}
