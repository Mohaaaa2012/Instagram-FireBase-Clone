//
//  Post.swift
//  InstagramFirebase
//
//  Created by Mohamed Mostafa on 11/16/20.
//

import Foundation

struct Post {
    
    let user: User
    let caption: String
    let creationDate: String
    let imageHeight: String
    let imageUrl: String
    let imageWidth: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        caption = dictionary["caption"] as? String ?? ""
        creationDate = dictionary["creationDate"] as? String ?? ""
        imageHeight = dictionary["imageHeight"] as? String ?? ""
        imageUrl = dictionary["imageUrl"] as? String ?? ""
        imageWidth = dictionary["imageWidth"] as? String ?? ""
    }
}
