//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Mohamed Mostafa on 25/02/2021.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController {
    
    let cellId = "cellId"
    var postsArray = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts()
        configureUI()
    }
    
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        
        
        
        ref.observeSingleEvent(of: .value) { (snapshots) in
            guard let dictionaries = snapshots.value as? [String: Any] else { return }
            
            dictionaries.forEach { (dictionary) in
                guard let postData = dictionary.value as? [String: Any] else { return }
                
                let dummyUser = User(dictionary: ["userName": "Mohamed Mostafa"])
                let post = Post(user: dummyUser, dictionary: postData)
                self.postsArray.append(post)
            }
            DispatchQueue.main.async { self.collectionView.reloadData() }
            
        } withCancel: { (error) in
            print("Failed to fetch data from DB", error.localizedDescription)
            return
        }
    }
    
    
    func configureUI() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        let logo = UIImageView(image: #imageLiteral(resourceName: "instaLogo"))
        logo.contentMode = .scaleAspectFit
        navigationItem.titleView = logo
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = postsArray[indexPath.row]
        return cell
    }
    
    
    
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 8 + 40 + 8
        height += view.frame.width
        height += 50
        height += 60
        let width = collectionView.frame.width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

