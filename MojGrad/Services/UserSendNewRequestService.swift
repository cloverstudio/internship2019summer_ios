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
    
    typealias newRequest = (JSON?) -> Void
    
    let token : [String:String] = ["token" : UserDefaults.standard.string(forKey: Keys.jasonWebToken) ?? ""]
    
    func sendData(parameters: [String : Any], completion: @escaping newRequest) {
        guard let newRequestURL = URL(string: "https://intern2019dev.clover.studio/requests/new") else {
            completion(nil)
            return
        }
        Alamofire.request(newRequestURL, method: .post, parameters: parameters, headers: token).responseJSON {
            response in
            if response.result.isSuccess {
                let json = JSON(response.result.value as Any)
                completion(json)
            } else if response.result.isFailure {
                print(response.result.error as Any)
                completion(nil)
            }
        }
    }
}
