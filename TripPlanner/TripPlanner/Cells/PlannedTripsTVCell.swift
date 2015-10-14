//
//  PlannedTripsTVCell.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/14/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import UIKit

class PlannedTripsTVCell: UITableViewCell {
    
    @IBOutlet weak var tripNameLabel: UILabel!
//    func configureCell(tripName: String, destinationName: String, travelDate: String) {
//        
//    }
    func configureCell(item: String) {
        tripNameLabel.text = item
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        contentView.backgroundColor = UIColor.blueColor()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PlannedTripsTVCell", bundle: nil)
    }
}
