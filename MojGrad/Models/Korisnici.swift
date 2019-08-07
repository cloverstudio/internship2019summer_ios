//
//  Korisnici.swift
//  MojGrad
//
//  Created by Ja on 07/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import Foundation
import UIKit

class Korisnici {
    
    var korisnikImage: UIImage
    var korisnikIme: String
    var korisnikEmail: String
    
    init(korisnikImage: UIImage, korisnikIme: String, korisnikEmail: String){
    
        self.korisnikImage = korisnikImage
        self.korisnikIme = korisnikIme
        self.korisnikEmail = korisnikEmail
    }
}
