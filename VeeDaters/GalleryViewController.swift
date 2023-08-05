//
//  GalleryViewController.swift
//  VeeDaters
//
//  Created by Rishabh Wadhwa on 27/12/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//

protocol GalleryViewControllerDelegate:NSObjectProtocol {
    func didFinishGalleryViewController(controller:GalleryViewController)
}

import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageCountLabel: UILabel!
    
    var userDetail:UserModel?
    var selectedIndex = Int()
    var delegate:GalleryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        updateImageCount(count: "1")
     }
}

//MARK:- Button Action 
//MARK:-
extension GalleryViewController {
    
    @IBAction func tapCross(_ sender: UIButton) {
        delegate?.didFinishGalleryViewController(controller: self)
    }
}


//MRAK:- Custom Method
//MARK:-
extension GalleryViewController {

    
    func configureCollectionView() {
        
        let userDetailCell = UINib(nibName: GalleryCollectionViewCell.className, bundle: nil)
        collectionView.register(userDetailCell, forCellWithReuseIdentifier: GalleryCollectionViewCell.className)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
//        collectionView.reloadData()
//        self.collectionView.scrollToItem(at:IndexPath(item: selectedIndex, section: 0), at: .right, animated: false)

    }
    
    func updateImageCount(count:String) {
        imageCountLabel.text = "\(count) of \(userDetail?.profileImages?.count ?? 0)"
     }
}


//MARK:- CollectionView DateSource,Delegate & FlowLayoutDelegate
//MARK:-

extension GalleryViewController : UICollectionViewDataSource ,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let profileImages = userDetail?.profileImages {
            return profileImages.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.className, for: indexPath) as! GalleryCollectionViewCell
        
        cell.userImageView.image = App.Placeholders.profile
        
        if let images = userDetail?.profileImages , images.count > 0 {
            cell.userImageView.kf.indicatorType = .activity
            cell.userImageView.kf.setImage(with: URL(string: images[indexPath.item].completePath ?? ""),placeholder: App.Placeholders.profile)
        }
        
         return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let width = self.collectionView.frame.size.width;
        let currentPage =  Int(self.collectionView.contentOffset.x / width) + 1
        
        updateImageCount(count: "\(currentPage)")
    }
}



