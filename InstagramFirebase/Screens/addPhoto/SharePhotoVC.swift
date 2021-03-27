//
//  SharePhotoVC.swift
//  InstagramFirebase
//
//  Created by Mohamed Mostafa on 11/15/20.
//

import UIKit
import Firebase

class SharePhotoVC: UIViewController {
    
    //MARK:- Properties
    
    let fileName = NSUUID().uuidString
    let userID = Auth.auth().currentUser?.uid
    
    let containerView = UIView()
    let photoImageView = UIImageView()
    let textView = UITextView()
    var selectedImage: UIImage? {
        didSet {
            photoImageView.image = selectedImage
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUIComponents()
        configureUIElements()
    }
    
    fileprivate func configureViewController() {
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleSharing))
    }
    
    //MARK:- Sharing, Uploading & Saving
    @objc func handleSharing() {
        guard let caption = textView.text, caption.count > 0 else { return }
        navigationItem.rightBarButtonItem?.isEnabled = false
        uploadData()
    }
    
    // upload data to firebase storage
    func uploadData() {
        guard let userID = userID else { return }
        guard let uploadedData = selectedImage?.jpegData(compressionQuality: 0.5) else { return }
        
        
        let storageReference = Storage.storage().reference().child("posts").child(userID)
        storageReference.child(fileName).putData(uploadedData, metadata: nil) { (metaData, error) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload post image to firebase storage:", error.localizedDescription)
                return
            }
            storageReference.child(self.fileName).downloadURL(completion: { (url, error) in
                if let error = error {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to download posted image URL from firebase storage:", error.localizedDescription)
                    return
                }
                if let imageURL = url?.absoluteString {
                    self.savingPost(from: imageURL)
                }
            })
            print("Successfully upload posted image to firebase storage")
        }
    }
    
    // saving post data to firebase
    func savingPost(from url: String) {
        guard let postImage = selectedImage else { return }
        guard let uid = userID else { return }
        guard let caption = textView.text else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        
        let values = ["imageUrl": url,
                        "caption": caption,
                        "imageWidth": postImage.size.width,
                        "imageHeight": postImage.size.height,
                        "creationDate" : Date().timeIntervalSince1970] as [String : Any]
        
        let ref = userPostRef.childByAutoId()
        
        ref.updateChildValues(values) { (error, ref) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to firebase DB:", error.localizedDescription)
                return
            }
            print("Successfully save post to firebase DB")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK:- UI Configuration
    func configureUIComponents() {
        view.addSubviews(containerView)
        containerView.addSubviews(photoImageView, textView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.image = selectedImage
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleToFill
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 14)
        
    }
    
    func configureUIElements() {
        
        containerView.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        containerView.setDimensions(height: 100)
        
        photoImageView.setAnchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, paddingTop: 8, paddingLeading: 8, paddingBottom: 8)
        photoImageView.setDimensions(width: 84)
        
        textView.setAnchor(top: containerView.topAnchor, leading: photoImageView.trailingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, paddingLeading: 4)
    }
    
}
