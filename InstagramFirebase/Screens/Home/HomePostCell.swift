//
//  HomePostCell.swift
//  InstagramFirebase
//
//  Created by Mohamed Mostafa on 26/02/2021.
//

import UIKit
import Kingfisher

class HomePostCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let url = URL(string: post?.imageUrl ?? "") else { return }
            photoImageView.kf.setImage(with: url)
            usernameLabel.text = post?.user.userName
        }
    }
    
    let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .blue
        return iv
    }()
    
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrowshape.turn.up.left")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()

    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bookmark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "Username ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Some caption text that will perhaps wrap into the next line", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        attributedText.append(NSAttributedString(string: "1 week ago", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(userProfileImageView)
        addSubview(photoImageView)
        addSubview(usernameLabel)
        addSubview(optionButton)
        
        userProfileImageView.setAnchor(top: topAnchor, leading: leadingAnchor, paddingTop: 8, paddingLeading: 8)
        userProfileImageView.setDimensions(width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40 / 2
        
        usernameLabel.setAnchor(top: topAnchor, leading: userProfileImageView.trailingAnchor, bottom: photoImageView.topAnchor, trailing: optionButton.leadingAnchor, paddingLeading: 8)
        
        optionButton.setAnchor(top: topAnchor, trailing: trailingAnchor, paddingTop: 8, paddingTrailing: 8)
        optionButton.setDimensions(width: 44, height: 40)
        
        photoImageView.setAnchor(top: userProfileImageView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 8)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        setupActionButtons()
        
        addSubviews(captionLabel)
        captionLabel.setAnchor(top: likeButton.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, paddingLeading: 8, paddingTrailing: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupActionButtons() {
        let stackview = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
        stackview.distribution = .fillEqually
        stackview.axis = .horizontal
        addSubviews(stackview)
        stackview.setAnchor(top: photoImageView.bottomAnchor, leading: leadingAnchor, paddingLeading: 8)
        stackview.setDimensions(width: 120, height: 50)
        
        addSubviews(bookmarkButton)
        bookmarkButton.setAnchor(top: photoImageView.bottomAnchor, trailing: trailingAnchor)
        bookmarkButton.setDimensions(width: 40, height: 50)
    }

    
}
