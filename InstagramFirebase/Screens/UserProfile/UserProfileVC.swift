//
//  UserProfileViewController.swift
//  InstagramFirebase
//
//  Created by Mohamed Mostafa on 11/9/20.
//

import UIKit
import Firebase

class UserProfileVC: UICollectionViewController {
    
    //MARK:- Properties
    
    let cellId = "cellId"
    let headerId = "headerId"
    var postsArray = [Post]()
    var user: User?
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        fetchOrderPosts()
        configureLogoutButton()
        configureCollectionView()
    }
    
    
    //MARK: - API
    
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            self.user = User(dictionary: userDictionary)
            self.navigationItem.title = self.user?.userName
            DispatchQueue.main.async { self.collectionView.reloadData() }
        } withCancel: { (error) in
            print("Failed to fetch user:", error)
            return
        }
    }
    
    func fetchOrderPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        #warning("Perhaps later on we'll implement some pagination of data")
        
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let user = self.user else { return }
            let post = Post(user: user, dictionary: dictionary)
            self.postsArray.append(post)
            self.collectionView.reloadData()
        } withCancel: { (error) in
            print("Failed to fetch orderd posts from DB", error.localizedDescription)
            return
        }
    }
    
    
    //MARK: - Selectors

    @objc func handleLogout() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)

            }catch let error {
                print("failed to signout", error.localizedDescription)
            }
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("Cancel")
        }))
        present(alertController, animated: true, completion: nil)
    }

    
    //MARK: - Helper Functions

    func configureLogoutButton() {
        let logout = UIBarButtonItem(image: UIImage(systemName: "gearshape")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = logout
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(UserProfileHeaderCell.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(UserProfileCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    
    //MARK: - UICollectionViewDelegate / UICollectionViewDataSource

    // gives a Supplementary header
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeaderCell
        header.user = self.user
        return header
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfileCell
        cell.post = postsArray[indexPath.row]
        return cell
    }
}


//MARK:- UICollectionViewDelegateFlowLayout

extension UserProfileVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
