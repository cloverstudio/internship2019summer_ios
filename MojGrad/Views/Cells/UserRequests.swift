//
//  UserRequests.swift
//  MojGrad
//
//  Created by Ja on 23/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//
import UIKit
import MapKit

class UserRequests: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageRequest: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var typeOfRequest: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
