//
//  MessageTableViewCell.swift
//  VeeDaters
//
//  Created by Rishabh Wadhwa on 31/10/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: BorderImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userMessage: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nextArrow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
        
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) min ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 min ago"
            } else {
                return "A min ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) sec ago"
        } else {
            return "Just now"
        }
    }
    
    func configureCell(messageDetail:MessageModel) {
        
        userImage.image = App.Placeholders.profile
        userMessage.text = ""
        
        let timeAgo:String = timeAgoSinceDate(messageDetail.chatFullDate()!, currentDate: NSDate() as Date, numericDates: true)
        timeLabel.text = ""
        timeLabel.text = timeAgo
        
        if messageDetail.senderID  == UserDefaults.getUser()?.id {
            
            if let imagePath = messageDetail.receiverImage {
                userImage.kf.indicatorType = .activity
                userImage.kf.setImage(with: URL(string: imagePath.completePath ?? "" ),placeholder: App.Placeholders.profile)
            }
            userName.text = messageDetail.receiverName ?? ""
            userMessage.text = messageDetail.message ?? ""


        } else {
            
            if let imagePath = messageDetail.senderImage {
                userImage.kf.indicatorType = .activity
                userImage.kf.setImage(with: URL(string: imagePath.completePath ?? "" ),placeholder: App.Placeholders.profile)
            }
            
            userName.text = messageDetail.senderName ?? ""
            userMessage.text = messageDetail.message ?? ""
        }
    }
}
