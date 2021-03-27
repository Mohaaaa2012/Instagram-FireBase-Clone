//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Mohamed Mostafa on 11/1/20.
//

import UIKit
import Firebase


class SignupVC: UIViewController {
    
    // MARK:- Properties
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "addPhoto").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let userNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailTextField, userNameTextField, passwordTextField, signupButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    let signinLabel: UILabel = {
        let label = UILabel()
        label.text = "Have an account?"
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let signinButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitle("Sign In", for: .normal)
        button.addTarget(self, action: #selector(flipToSignin), for: .touchUpInside)
        return button
    }()
    
    
    lazy var bottomStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [signinLabel, signinButton])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 0
        return stack
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIElements()
    }

    
    
    //MARK: - Selectors
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && userNameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        if isFormValid {
            signupButton.isEnabled = true
            signupButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }else {
            signupButton.isEnabled = false
            signupButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    @objc func handleSignup() {
        
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let userName = userNameTextField.text, userName.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Failed to create user", error.localizedDescription)
                return
            }
            print("Successfully created user:", user?.user.uid ?? "")
            guard let uid = user?.user.uid else { return }
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
  
            let filename = UUID().uuidString
            Storage.storage().reference().child("profile_images").child(filename).putData(uploadData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Failed to upload profile image:", error)
                    return
                }
                Storage.storage().reference().child("profile_images").child(filename).downloadURL { (url, error) in
                    if let error = error {
                        print("Failed to fetch image URL", error)
                        return
                    }
                    guard let url = url else { return }
                    print("Successfully uploaded profile image", url.absoluteURL)
                    let value = ["email": email,
                                 "userName": userName,
                    "profileImageURL": url.absoluteString]

                    Database.database().reference().child("users").child(uid).updateChildValues(value) { (error, ref) in
                        if let error = error {
                            print("Failed to save user info to db", error.localizedDescription)
                            return
                        }
                        print("successfully save user info to db")
                    }
                }
            }
        }
    }
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func flipToSignin() {
        let signin = SigninVC()
        signin.modalPresentationStyle = .fullScreen
        signin.modalTransitionStyle = .crossDissolve
        present(signin, animated: true, completion: nil)
    }
    
    
    //MARK: - Helper Functions
    
    func configureUIElements() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        view.addSubviews(plusPhotoButton, stackView, bottomStack)

        plusPhotoButton.setCenter(centerX: view.centerXAnchor)
        plusPhotoButton.setAnchor(top: view.topAnchor, paddingTop: 40)
        plusPhotoButton.setDimensions(width: 140, height: 140)
        
        stackView.setAnchor(top: plusPhotoButton.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 20, paddingLeading: 40, paddingTrailing: 40)
        stackView.setDimensions(height: 200)
        
        bottomStack.setAnchor(leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingLeading: 92.5, paddingBottom: 20, paddingTrailing: 92.5)
        bottomStack.setDimensions(height: 40)
    }
}

//MARK:- UIImagePickerControllerDelegate / UINavigationControllerDelegate

extension SignupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
        if let editedImage = info[.editedImage] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }else if let originalImage = info[.originalImage] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }else {
            plusPhotoButton.setImage(#imageLiteral(resourceName: "imageAvatar").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        dismiss(animated: true, completion: nil)
    }
}


