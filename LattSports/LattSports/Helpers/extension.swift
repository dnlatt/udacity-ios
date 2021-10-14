//
//  extension.swift
//  LattSports
//
//  Created by dnlatt on 2/10/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit



extension UIView {
 
 func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
 var topInset = CGFloat(0)
 var bottomInset = CGFloat(0)
 
 if #available(iOS 11, *), enableInsets {
 let insets = self.safeAreaInsets
 topInset = insets.top
 bottomInset = insets.bottom
 
 }
 
 translatesAutoresizingMaskIntoConstraints = false
 
 if let top = top {
 self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
 }
 if let left = left {
 self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
 }
 if let right = right {
 rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
 }
 if let bottom = bottom {
 bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
 }
 if height != 0 {
 heightAnchor.constraint(equalToConstant: height).isActive = true
 }
 if width != 0 {
 widthAnchor.constraint(equalToConstant: width).isActive = true
 }
 
 }
 
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension UIViewController {
    
    
    
//    func showActivityIndicator() {
//        activityView = UIActivityIndicatorView(style: .large)
//        activityView?.color = .gray
//        activityView?.center = self.view.center
//        self.view.addSubview(activityView!)
//        activityView?.startAnimating()
//    }
//
//    func hideActivityIndicator(){
//        if (activityView != nil){
//            activityView?.stopAnimating()
//        }
//    }
    
}


extension UITableView {
func setEmptyView(title: String, message: String) {
let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
let titleLabel = UILabel()
let messageLabel = UILabel()
titleLabel.translatesAutoresizingMaskIntoConstraints = false
messageLabel.translatesAutoresizingMaskIntoConstraints = false
titleLabel.textColor = UIColor.black
titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
messageLabel.textColor = UIColor.lightGray
messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
emptyView.addSubview(titleLabel)
emptyView.addSubview(messageLabel)
titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
titleLabel.text = title
messageLabel.text = message
messageLabel.numberOfLines = 0
messageLabel.textAlignment = .center
// The only tricky part is here:
self.backgroundView = emptyView
self.separatorStyle = .none
}
func restore() {
self.backgroundView = nil
self.separatorStyle = .singleLine
}
}
