//
//  ArticleImageView.swift
//  LattSports
//
//  Created by dnlatt on 3/10/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit

final class ArticleImageView: UIView {
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var baseView: UIView = {
        let base = UIView()
        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = .clear
        base.layer.shadowColor = UIColor.black.cgColor
        base.layer.shadowOffset = CGSize(width: 5, height: 5)
        base.layer.shadowOpacity = 0.5
        base.layer.shadowRadius = 5.0
        return base
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    func setupView() {
        addSubview(baseView)
        baseView.addSubview(imageView)
        setupConstraints()
    }
    
    func setupConstraints() {
        [baseView, imageView].forEach { (v) in
            NSLayoutConstraint.activate([
                v.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                v.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
                v.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                v.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            ])
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        baseView.layer.shadowPath = UIBezierPath(roundedRect: baseView.bounds, cornerRadius: 10).cgPath
        baseView.layer.shouldRasterize = true
        baseView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented" )
    }
}
