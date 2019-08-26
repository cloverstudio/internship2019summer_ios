//
//  Data.swift
//  MojGrad
//
//  Created by Ja on 13/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import Foundation

struct UserData {
    let data : User
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

extension UserData: Decodable {
    
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try values.decode(User.self, forKey: .data)
    }
}
