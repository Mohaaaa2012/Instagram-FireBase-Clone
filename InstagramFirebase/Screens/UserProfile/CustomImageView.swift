//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by Mohamed Mostafa on 11/16/20.
//

import UIKit

import Kingfisher

var imageCash = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func downloadImage(from imageUrl: String) {
        lastURLUsedToLoadImage = imageUrl
        
        if let cashImage = imageCash[imageUrl] {
            self.image = cashImage
            return
        }
        
        
        guard let url = URL(string: imageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let error = err {
                print("Failed to download image", error.localizedDescription)
                return
            }
            
            if let responseInfo = response as? HTTPURLResponse, responseInfo.statusCode != 200 {
                print("Error in server", responseInfo.statusCode)
                return
            }
            
            #warning("Used to prevent duplicate images in CollectionView at loading")
            if url.absoluteString != self.lastURLUsedToLoadImage{
                return
            }
            
            guard let imagedata = data else { return }
            let photoImage = UIImage(data: imagedata)
            imageCash[url.absoluteString] = photoImage
            DispatchQueue.main.async { self.image = photoImage }
        }.resume()
    }
}



