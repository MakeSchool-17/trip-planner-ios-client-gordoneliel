//
//  PlannedTripsCVCell.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/14/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import UIKit

class PlannedTripsCVCell: UICollectionViewCell {

    @IBOutlet weak var tripNameLabel: UILabel!
    
    func configureCell(item: String) {
        tripNameLabel.text = item
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PlannedTripsCVCell", bundle: nil)
    }
}
