//
//  PrefernceSelectedTableViewCell.swift
//  Veedater
//
//  Created by Sachin Khosla on 05/01/18.
//  Copyright © 2018 DigiMantra. All rights reserved.
//

import UIKit

class PrefernceSelectedTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tickImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
