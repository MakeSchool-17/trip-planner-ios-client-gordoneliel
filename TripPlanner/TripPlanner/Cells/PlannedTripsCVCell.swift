//
//  PlannedTripsCVCell.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/14/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import UIKit

class PlannedTripsCVCell: UICollectionViewCell {

    @IBOutlet weak var tripCoverImage: UIImageView!
    @IBOutlet weak var tripNameLabel: UILabel!
    
    func configureCell(item: String) {
        tripNameLabel.text = item
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        layer.shadowColor = UIColor.blackColor().CGColor
//        layer.shadowOffset = CGSize(width: 0, height: 2)
//        layer.shadowRadius = 2
//        layer.shadowOpacity = 0.8
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PlannedTripsCVCell", bundle: nil)
    }
}
