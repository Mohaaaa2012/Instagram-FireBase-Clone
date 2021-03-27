//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Mohamed Mostafa on 11/10/20.
//

import UIKit

class UserProfileHeaderCell: UICollectionReusableView {
    
    //MARK: - Properties
    
    var user: User? {
        didSet{
            usernameLabel.text = user?.userName
            guard let imageURL = URL(string: user?.imageURL ?? "") else { return }
            profileImageView.kf.setImage(with: imageURL)
        }
    }

    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.layer.cornerRadius = 80 / 2
        iv.backgroundColor = .blue
        iv.clipsToBounds = true
        return iv
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    let postsLabel = UILabel()
    let followersLabel = UILabel()
    let followingLabel = UILabel()

    let gridButton = UIButton(type: .system)
    let listButton = UIButton(type: .system)
    let bookmarkButton = UIButton(type: .system)

    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        return button
    }()

    lazy var statusStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [postsLabel,followersLabel,followingLabel])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()

    lazy var controlStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [gridButton,listButton,bookmarkButton])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()

    let upperDivider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()

    let lowerDivider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureControlbuttons()
        configureStatusButtons()
        configureUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helper Functions
    
    func configureStatusButtons() {
        let statusArray = [postsLabel,followersLabel,followingLabel]
        for label in statusArray {
            label.textAlignment = .center
            label.numberOfLines = 0
        }
        postsLabel.attributedText = attributeFont(number: "0\n", text: "posts")
        followersLabel.attributedText = attributeFont(number: "0\n", text: "followers")
        followingLabel.attributedText = attributeFont(number: "0\n", text: "following")
    }


    func attributeFont(number: String, text: String) -> NSMutableAttributedString {

        let attributedText = NSMutableAttributedString(string: number, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))

        return attributedText
    }


    func configureControlbuttons() {
        let buttonsArray = [gridButton,listButton,bookmarkButton]
        for button in buttonsArray {
            button.tintColor = UIColor(white: 0, alpha: 0.2)
        }
        gridButton.setImage(UIImage(systemName: "square.grid.3x3.fill"), for: .normal)
        listButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
    }

    func configureUIElements() {

        addSubviews(profileImageView, statusStackView, editProfileButton, controlStackView, upperDivider, lowerDivider, usernameLabel)
        
        profileImageView.setAnchor(top: topAnchor, leading: leadingAnchor, paddingTop: 12, paddingLeading: 12)
        profileImageView.setDimensions(width: 80, height: 80)
        
        
        statusStackView.setDimensions(height: 50)
        #warning("statusStackView leading anchor problem")
        statusStackView.setAnchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 12, paddingLeading: 120, paddingTrailing: 12)

        editProfileButton.setAnchor(top: statusStackView.bottomAnchor, leading: statusStackView.leadingAnchor, trailing: statusStackView.trailingAnchor, paddingTop: 2)
        editProfileButton.setDimensions(height: 34)

        upperDivider.setAnchor(top: controlStackView.topAnchor, leading: leadingAnchor, trailing: trailingAnchor)
        upperDivider.setDimensions(height: 0.5)

        lowerDivider.setAnchor(top: controlStackView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
        lowerDivider.setDimensions(height: 0.5)

        usernameLabel.setAnchor(top: profileImageView.bottomAnchor, leading: leadingAnchor, bottom: controlStackView.topAnchor, trailing: trailingAnchor, paddingTop: 4, paddingLeading: 12, paddingTrailing: 12)

        controlStackView.setAnchor(leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        controlStackView.setDimensions(height: 50)
    }
}
