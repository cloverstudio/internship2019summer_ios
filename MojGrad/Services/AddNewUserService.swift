//
//  AddNewUser.swift
//  MojGrad
//
//  Created by Ja on 16/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AddNewUserService {
    typealias newUserService = (JSON?) -> Void
    
    let token : [String:String] = ["token" : UserDefaults.standard.string(forKey: Keys.jasonWebToken) ?? ""] 
    
    func sendUserData (parameters: [String : Any], completion: @escaping newUserService) {
        guard let newUserUrl = URL(string: "https://intern2019dev.clover.studio/users/newUser") else {
            completion(nil)
            return
        }
        Alamofire.request(newUserUrl, method: .post, parameters: parameters, headers: token).responseJSON {
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
