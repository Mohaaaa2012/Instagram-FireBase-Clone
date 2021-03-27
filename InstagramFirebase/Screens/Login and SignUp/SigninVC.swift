//
//  Login.swift
//  InstagramFirebase
//
//  Created by Mohamed Mostafa on 11/10/20.
//

import UIKit
import Firebase

class SigninVC: UIViewController {
    
    let logoPhoto = UIImageView()
    var stackView = UIStackView()
    var bottomStack = UIStackView()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let signinButton = UIButton(type: .system)
    let signupLabel = UILabel()
    let signupButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogo()
        configureEmailTextField()
        configurePasswordTextField()
        configureSigninButton()
        configureStackView()
        configureBottomView()
        configureUIElements()
    }
    
    // MARK:- Handling Methods
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        if isFormValid {
            signinButton.isEnabled = true
            signinButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }else {
            signinButton.isEnabled = false
            signinButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
    }
    
    
    @objc func handleSignin() {
        
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Failed to login", error.localizedDescription)
                return
            }
            // login success
            print("Successfully login user:", user?.user.uid ?? "")
            let mainUI = MainTabBarController()
            mainUI.modalPresentationStyle = .fullScreen
            self.present(mainUI, animated: true, completion: nil)
        }
    }
    
    @objc func flipToSignup() {
        let signup = SignupVC()
        signup.modalPresentationStyle = .fullScreen
        signup.modalTransitionStyle = .crossDissolve
        present(signup, animated: true, completion: nil)
    }
        
    
    // MARK:- Configure UI Elements
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureLogo() {
        logoPhoto.image = #imageLiteral(resourceName: "sign title").withRenderingMode(.alwaysOriginal)
        logoPhoto.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        logoPhoto.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func configureEmailTextField() {
        emailTextField.placeholder = "Email"
        emailTextField.text = "moha@gmail.com"
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        emailTextField.font = UIFont.systemFont(ofSize: 14)
        emailTextField.borderStyle = .roundedRect
        emailTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    }
    
    
    func configurePasswordTextField() {
        passwordTextField.placeholder = "Password"
        passwordTextField.text = "123456"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        passwordTextField.font = UIFont.systemFont(ofSize: 14)
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    }
    
    
    func configureSigninButton() {
        signinButton.setTitle("Sign In", for: .normal)
        signinButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        signinButton.setTitleColor(.white, for: .normal)
        signinButton.translatesAutoresizingMaskIntoConstraints = false
        signinButton.layer.cornerRadius = 5
        signinButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        signinButton.addTarget(self, action: #selector(handleSignin), for: .touchUpInside)
        signinButton.isEnabled = false
    }
    
    
    func configureStackView() {
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(signinButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 25
    }
    
    
    func configureBottomView() {
        bottomStack = UIStackView(arrangedSubviews: [signupLabel, signupButton])
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.axis = .horizontal
        bottomStack.distribution = .fill
        bottomStack.spacing = 0
        
        signupLabel.translatesAutoresizingMaskIntoConstraints = false
        signupLabel.text = "Don't have an account?"
        signupLabel.textColor = UIColor.lightGray
        
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.setTitleColor(UIColor.systemBlue, for: .normal)
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.addTarget(self, action: #selector(flipToSignup), for: .touchUpInside)
    }
    
    
    func configureUIElements() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        view.addSubviews(logoPhoto, stackView, bottomStack)
        
        NSLayoutConstraint.activate([
            logoPhoto.topAnchor.constraint(equalTo: view.topAnchor),
            logoPhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoPhoto.heightAnchor.constraint(equalToConstant: 120),
            logoPhoto.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: logoPhoto.bottomAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            stackView.heightAnchor.constraint(equalToConstant: 200),
            
            bottomStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            bottomStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65),
            bottomStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            bottomStack.heightAnchor.constraint(equalToConstant: 40),
            
        ])
    }
}
