//
//  PhotoSelectorHeader.swift
//  InstagramFirebase
//
//  Created by Mohamed Mostafa on 11/12/20.
//

import UIKit

class PhotoSelectorHeader: UICollectionViewCell {
    
    let photoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImageView() {
        addSubview(photoImageView)
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.backgroundColor = .lightGray
        
        photoImageView.setAnchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)

    }
}
