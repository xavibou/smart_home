//
//  ItemCell.swift
//  GridViewExampleApp
//
//  Created by Chandimal, Sameera on 12/22/17.
//  Copyright © 2017 Pearson. All rights reserved.
//

import UIKit

class ChartCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCell(actions: [Action]) {
        //self.nameLabel.text = action.deviceType
        //self.roomLabel.text = device.room
        
        // Cell Design
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
    
}

