//
//  PhotoSelectorVC.swift
//  InstagramFirebase
//
//  Created by Mohamed Mostafa on 11/11/20.
//

import UIKit
import Photos

class PhotoSelectorVC: UICollectionViewController {
    
    private let reuseCellIdentifier = "Cell"
    private let reuseHeaderIdentifier = "header"
    
    
    var imagesArray = [UIImage]()
    var selectedImage: UIImage?
    var assetsArray = [PHAsset]()
    var header: PhotoSelectorHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBarButtonItems()
        configureCollectionView()
        fetchPhotos()
    }
    
    fileprivate func fetchPhotos() {
        let options = assetsFetchOptions()
        let allPhotos = PHAsset.fetchAssets(with: .image, options: options)
        
        DispatchQueue.global(qos: .background).async {
            // seperate each asset from photosResults
            allPhotos.enumerateObjects { (asset, count, stop) in
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                // seperate each photo from asset
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, info) in
                    
                    if let image = image {
                        self.imagesArray.append(image)
                        self.assetsArray.append(asset)
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                    }
                    print(count)
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async { self.collectionView.reloadData() }
                    }
                    
                }
            }
        }
    }
    
    fileprivate func assetsFetchOptions() -> PHFetchOptions{
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 10
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    
    // hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // add navigation bar buttons
    func configureBarButtonItems() {
        navigationController?.navigationBar.tintColor = .black
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handelCancel))
        navigationItem.leftBarButtonItem = cancelButton
        
        let selectButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(handleSelection))
        navigationItem.rightBarButtonItem = selectButton
    }
    
    @objc func handelCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSelection() {
        let sharedPhotoVC = SharePhotoVC()
        sharedPhotoVC.modalPresentationStyle = .overFullScreen
        sharedPhotoVC.selectedImage = header?.photoImageView.image
        navigationController?.pushViewController(sharedPhotoVC, animated: true)
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: reuseCellIdentifier)
        collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! PhotoSelectorHeader
        
        self.header = header
        
        if let selectedImage = selectedImage {
            if let index = imagesArray.firstIndex(of: selectedImage) {
                let selectedAsset = assetsArray[index]
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .aspectFit, options: nil) { (image, info) in
                    header.photoImageView.image = image
                }
            }
        }
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as! PhotoSelectorCell
        
        cell.photoImageView.image = imagesArray[indexPath.row]
        return cell
    }
}

extension PhotoSelectorVC: UICollectionViewDelegateFlowLayout {
    
    //MARK:- UICollectionViewDelegateFlowLayout
    
    // size of the header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    // add margins
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    // the specific cell has selected
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = imagesArray[indexPath.row]
        collectionView.reloadData()
        let index = IndexPath(row: 0, section: 0)
        collectionView.scrollToItem(at: index, at: .bottom, animated: true)
    }
    
    
    // size of the cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    // minimum horizontal spacing for cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // minimum vertical spacing for cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
