//
//  UserSendNewRequestService.swift
//  MojGrad
//
//  Created by Ja on 20/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserSendNewRequestService {
    
    let token : [String:String] = ["token" : UserDefaults.standard.string(forKey: Keys.jasonWebToken) ?? ""]
    
    func sendData(parameters: [String : Any]) {
        guard let newRequestURL = URL(string:  "https://intern2019dev.clover.studio/requests/new") else {
            return
        }
        Alamofire.request(newRequestURL, method: .post, parameters: parameters, headers: token).responseJSON {
            response in
            if response.result.isSuccess {
                let json = JSON(response.result.value as Any)
            } else if response.result.isFailure {
                print(response.result.error as Any)
            }
        }
    }
}
