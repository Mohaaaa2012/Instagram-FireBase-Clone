//
//  UserProfileCell.swift
//  InstagramFirebase
//
//  Created by Mohamed Mostafa on 11/16/20.
//

import UIKit

class UserProfileCell: UICollectionViewCell {
    
    var post: Post? {
        didSet{
            guard let imageUrl = URL(string: post?.imageUrl ?? "") else { return }
            photoImageView.kf.setImage(with: imageUrl)
        }
    }

    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .red
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUIComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func configureUIComponents() {
        addSubview(photoImageView)
        photoImageView.setAnchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
}
