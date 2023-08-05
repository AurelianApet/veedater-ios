//
//  AsyncPhotoMediaItem.swift
//  Chibha
//
//  Created by Sachin Khosla on 30/11/17.
//  Copyright © 2017 DigiMantra. All rights reserved.
//

import Foundation
import JSQMessagesViewController
import Kingfisher


class AsyncPhotoMediaItem: JSQPhotoMediaItem {
    var asyncImageView: UIImageView!
    
    override init!(maskAsOutgoing: Bool) {
        super.init(maskAsOutgoing: maskAsOutgoing)
    }
    
    init(withURL url: NSURL) {
        super.init()
        asyncImageView = UIImageView()
        asyncImageView.frame = CGRect(x: 0, y: 0, width: 170, height: 130)
        asyncImageView.contentMode = .scaleAspectFill
        asyncImageView.clipsToBounds = true
        asyncImageView.layer.cornerRadius = 20
        asyncImageView.backgroundColor = UIColor.jsq_messageBubbleLightGray()
        
        let activityIndicator = JSQMessagesMediaPlaceholderView.withActivityIndicator()
        activityIndicator?.frame = asyncImageView.frame
        asyncImageView.addSubview(activityIndicator!)
        
        KingfisherManager.shared.cache.retrieveImage(forKey: url.absoluteString!, options: nil) { (image, cacheType) in
            if let image = image {
                self.asyncImageView.image = image
                activityIndicator?.removeFromSuperview()
            } else {
                
                KingfisherManager.shared.downloader.downloadImage(with: url as URL, progressBlock: nil, completionHandler: { (image, error, imageURL, originalData) in
                    
                    if let image = image {
                        self.asyncImageView.image = image
                        activityIndicator?.removeFromSuperview()
                        
                        KingfisherManager.shared.cache.store(image, original: originalData, forKey: url.absoluteString!, toDisk: true, completionHandler: nil)
                    }
                })
            }
        }
    }
    
    override func mediaView() -> UIView! {
        return asyncImageView
    }
    
    override func mediaViewDisplaySize() -> CGSize {
        return asyncImageView.frame.size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
