//
//  KorisnikCell.swift
//  MojGrad
//
//  Created by Ja on 07/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var korisnikImage: UIImageView!
    @IBOutlet weak var imeKorisnika: UILabel!
    @IBOutlet weak var emailKorisnika: UILabel!
    
    var userId : Int?
    var userName : String?
    var userLastName : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
