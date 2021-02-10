//
//  ItemCell.swift
//  GridViewExampleApp
//
//  Created by Chandimal, Sameera on 12/22/17.
//  Copyright © 2017 Pearson. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCell(device: Device) {
        self.nameLabel.text = device.name
        //self.roomLabel.text = device.room
        
        // Cell UI
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
    
}

