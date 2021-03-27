//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Mohamed Mostafa on 11/9/20.
//

import UIKit

enum tabbarType: Int {
    case Home
    case search
    case addPhoto
    case favorites
    case userProfile
}

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .black
        self.delegate = self
        
        let homeNC = configureTabBarScreens(image: "house", selectedImage: "house.fill", tabbarType: .Home)
        let searchNC = configureTabBarScreens(image: "magnifyingglass", selectedImage: "magnifyingglass.fill", tabbarType: .search)
        let addPhotoNC = configureTabBarScreens(image: "plus.square", selectedImage: "plus.square", tabbarType: .addPhoto)
        let favouriteNC = configureTabBarScreens(image: "suit.heart", selectedImage: "suit.heart.fill", tabbarType: .favorites)
        let userProfileNC = configureTabBarScreens(image: "person", selectedImage: "person.fill", tabbarType: .userProfile)
        
        viewControllers = [homeNC, searchNC, addPhotoNC, favouriteNC, userProfileNC]
        
        #warning("modify tabBar items insets must be after initiate viewcontrollers #####")
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func configureTabBarScreens(image: String, selectedImage: String, tabbarType: tabbarType) -> UINavigationController {
        var vc = UIViewController()
        switch tabbarType {
        case .Home:
            vc = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
        case .search:
            vc = UIViewController()
        case .addPhoto:
            vc = UIViewController()
        case .favorites:
            vc = UIViewController()
        case .userProfile:
            vc = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        }
        vc.view.backgroundColor = .systemBackground
        vc.tabBarItem.image = UIImage(systemName: image)
        vc.tabBarItem.selectedImage = UIImage(systemName: selectedImage)
        return UINavigationController(rootViewController: vc)
    }
//    fileprivate func configureTabBarScreens(image: String, selectedImage: String, isCollectionView: Bool = false) -> UINavigationController {
//
//        let vc = isCollectionView ? UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()) : UIViewController()
//        vc.view.backgroundColor = .systemBackground
//        vc.tabBarItem.image = UIImage(systemName: image)
//        vc.tabBarItem.selectedImage = UIImage(systemName: selectedImage)
//
//        return UINavigationController(rootViewController: vc)
//    }
}


extension MainTabBarController {
    
    // make tabBar icons selectable or not
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.lastIndex(of: viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorVC = PhotoSelectorVC(collectionViewLayout: layout)
            let photoNav = UINavigationController(rootViewController: photoSelectorVC)
            photoNav.modalPresentationStyle = .fullScreen
            present(photoNav, animated: true, completion: nil)
            return false
        }
        return true
    }
}
