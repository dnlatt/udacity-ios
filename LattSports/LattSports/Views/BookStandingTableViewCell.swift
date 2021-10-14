//
//  BookStandingTableViewCell.swift
//  LattSports
//
//  Created by dnlatt on 9/10/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit

class BookStandingTableViewCell: UITableViewCell {
    
    static let identifer = "BookStandingTableViewCell"
    
    lazy var articleCellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var articleLabel: UILabel = {
       let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        return title
    }()
    
    private lazy var articleImage: ArticleImageView = {
        let imageView = ArticleImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    
    var article : BookmarkArticles? {
        didSet {
            
            if (article?.urlToImage != nil )
            {
                articleImage.image = UIImage(data: (article?.urlToImage)!)
            }
            else {
                 articleImage.image = UIImage(named: "placeholder")
            }
            articleLabel.text = article?.title
        
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()

        
        
    }
    
    func setupView() {
           
           addSubview(articleCellStackView)
        
            articleCellStackView.addArrangedSubview(articleImage)
            articleCellStackView.addArrangedSubview(articleLabel)
           

           
           setupConstraints()
       }
       
       func setupConstraints()
       {
           
           
           // Article Title
           
           NSLayoutConstraint.activate([
               articleCellStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
               articleCellStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
               articleCellStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8 ),
               articleCellStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)

           ])
           
        
           // Article Image
           NSLayoutConstraint.activate([
               articleImage.widthAnchor.constraint(equalToConstant: 100),
               articleImage.heightAnchor.constraint(equalToConstant: 100),
               
           ])
           

           
       }
    
    
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
}
