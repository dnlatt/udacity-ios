//
//  ArticleTableViewCell.swift
//  LattSports
//
//  Created by dnlatt on 29/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit
import CoreData


protocol ArticleTableViewCellDelegate: class {
    func didTapButton(cell: ArticleTableViewCell)
}

class ArticleTableViewCell: UITableViewCell {
    
    weak var cellDelegate: ArticleTableViewCellDelegate?

    static let identifer = "ArticleTableViewCell"
    
    
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
    
    
    

    
    
    var article : ArticleCD? {
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
    
    @objc private func bookmarkArticle() {
        
        if(article?.title != nil)
        {
            addDataToCoreData(bookmarkAricle: article!)
        }
        cellDelegate?.didTapButton(cell: self)
        //print("Tapped")
        
    }
    
    func setupView() {
        
        addSubview(articleImage)
        addSubview(articleCellStackView)
        articleCellStackView.addArrangedSubview(articleLabel)
        
        setupConstraints()
    }
    
    func setupConstraints()
    {
        // Article Image
 
        NSLayoutConstraint.activate([
            articleImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            articleImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            articleImage.topAnchor.constraint(equalTo: topAnchor),
            articleImage.heightAnchor.constraint(equalToConstant: 250)
            
        ])
        
        // Article Title
        
        NSLayoutConstraint.activate([
            articleCellStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            articleCellStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            articleCellStackView.topAnchor.constraint(equalTo: articleImage.bottomAnchor, constant: 8 ),
            articleCellStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)

        ])
        
     
        
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addDataToCoreData(bookmarkAricle: ArticleCD) {
    
        
        let bookmarkToInsert = BookmarkArticles(context: DataController.shared.viewContext)
        bookmarkToInsert.title = article?.title
        bookmarkToInsert.url = article?.url
        bookmarkToInsert.urlToImage = article?.urlToImage
        
        do
        {
            try DataController.shared.viewContext.save()
            
            
        } catch {
            print(error)
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
    
}
