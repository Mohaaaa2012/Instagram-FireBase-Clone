//
//  UIView + Ext.swift
//  InstagramFirebase
//
//  Created by Mohamed Mostafa on 11/11/20.
//

import UIKit

extension UIView {
     func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    func setAnchor(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil,
                   bottom: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil,
                   paddingTop: CGFloat = 0, paddingLeading: CGFloat = 0, paddingBottom: CGFloat = 0,
                   paddingTrailing: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing).isActive = true
        }
    }
    
    func setCenter( centerX: NSLayoutXAxisAnchor? = nil,
                   centerY: NSLayoutYAxisAnchor? = nil,
                   paddingX: CGFloat = 0,
                   paddingY: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX, constant: paddingX).isActive = true
        }
        
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY, constant: paddingY).isActive = true
        }
    }
    
    func setDimensions(width: CGFloat = 0, height: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
