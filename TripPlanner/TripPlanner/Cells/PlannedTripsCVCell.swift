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
    
    func configureCell(item: Trip) {
        tripNameLabel.text = item.tripName
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

//        layer.shadowColor = UIColor.blackColor().CGColor
//        layer.shadowOffset = CGSize(width: -5.0, height: 5.0)
//        layer.shadowRadius = 2
//        layer.shadowOpacity = 0.4
//        self.layer.masksToBounds = false
//        self.layer.shouldRasterize = false
//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).CGPath
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSize(width: 2, height: 2)).CGPath

    }
    
    override func drawRect(rect: CGRect) {
        let currentContext = UIGraphicsGetCurrentContext()
        CGContextSaveGState(currentContext)
        CGContextSetShadow(currentContext, CGSize(width: -15, height: 2), 2)
        super.drawRect(rect)
        CGContextRestoreGState(currentContext)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PlannedTripsCVCell", bundle: nil)
    }
}
