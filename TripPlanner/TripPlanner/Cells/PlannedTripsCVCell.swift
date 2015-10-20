//
//  PlannedTripsCVCell.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/14/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import UIKit
import QuartzCore

class PlannedTripsCVCell: UICollectionViewCell {

    @IBOutlet weak var tripCoverImage: UIImageView!
    @IBOutlet weak var tripNameLabel: UILabel!
    
    func configureCell(item: String) {
        tripNameLabel.text = item
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

//        layer.shadowColor = UIColor.blackColor().CGColor
//        layer.shadowOffset = CGSize(width: 0, height: 1.5)
//        layer.shadowRadius = 2
//        layer.shadowOpacity = 0.4
//        self.layer.masksToBounds = false
//        self.layer.shouldRasterize = false
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSize(width: 2, height: 2)).CGPath

    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PlannedTripsCVCell", bundle: nil)
    }
}
