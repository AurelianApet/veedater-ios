//
//  TestingCollectionViewCell.swift
//  VeeDaters
//
//  Created by Rishabh Wadhwa on 11/12/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//


protocol UserDetailCollectionViewCellDelegate:NSObjectProtocol {
    func didTapFavorite(cell:UserDetailCollectionViewCell)

}

import UIKit

class UserDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ageImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: BorderImageView!

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userageLabel: UILabel!
    @IBOutlet weak var userDistanceButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    var delegate:UserDetailCollectionViewCellDelegate?


    override func awakeFromNib() {
        super.awakeFromNib()
        createGradientLayer()
    }
    
    func configureCell(userDetail:UserModel) {
        
        usernameLabel.text = userDetail.username?.capitalized ?? ""
        userageLabel.text = userDetail.age ?? ""
        
        if userDetail.favourite == 1 {
            favButton.setImage(UIImage(named:"bigFilledHeart"), for: .normal)
            
        } else {
            favButton.setImage(UIImage(named:"bigEmptyHeart"), for: .normal)
        }
        
        userDistanceButton.setTitle("\(userDetail.distance ?? "") mi", for: .normal)
        
        
        if userDetail.gender == "Men" {
            ageImageView.image = UIImage(named:"maleBig")
        } else {
            ageImageView.image = UIImage(named:"femaleBig")
        }
        
        userImageView.image = App.Placeholders.profile
        userProfileImageView.image = App.Placeholders.profile
        
        if let thumbnail = userDetail.videoThumbnail?.completePath {
            
            userImageView.kf.indicatorType = .activity
            userImageView.kf.setImage(with: URL(string: thumbnail),placeholder: App.Placeholders.profile)
        } else {
                        
            if let images = userDetail.profileImages, images.count > 0 {
                
                userImageView.kf.indicatorType = .activity
                userImageView.kf.setImage(with: URL(string: images[0].completePath ?? ""),placeholder: App.Placeholders.profile)
            }
        }
        
        if let images = userDetail.profileImages, images.count > 0 {
            
            userProfileImageView.kf.indicatorType = .activity
            userProfileImageView.kf.setImage(with: URL(string: images[0].completePath ?? ""),placeholder: App.Placeholders.profile)
        }
    }

    func createGradientLayer() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(0.9).cgColor]
        gradientView.layer.addSublayer(gradientLayer)
    }

    
    @IBAction func favoriteTapped(_ sender: UIButton) {
        delegate?.didTapFavorite(cell: self)
    }
}
