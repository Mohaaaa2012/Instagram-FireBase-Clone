//
//  User.swift
//  InstagramFirebase
//
//  Created by Mohamed Mostafa on 22/02/2021.
//

import Foundation

struct User {
    let userName: String
    let imageURL: String
    
    init(dictionary: [String: Any]) {
        userName = dictionary["userName"] as? String ?? ""
        imageURL = dictionary["profileImageURL"] as? String ?? ""
    }
}
