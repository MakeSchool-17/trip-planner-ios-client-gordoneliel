//
//  PlannedTripHeaderView.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/29/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import UIKit

class PlannedTripHeaderView: UICollectionReusableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PlannedTripHeaderView", bundle: nil)
    }
}
