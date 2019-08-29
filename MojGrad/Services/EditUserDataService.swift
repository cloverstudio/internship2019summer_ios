//
//  EditUserDataService.swift
//  MojGrad
//
//  Created by Ja on 29/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class EditUserDataService {
    typealias newRequest = (JSON?) -> Void
    
    let token : [String:String] = ["token" : UserDefaults.standard.string(forKey: Keys.jasonWebToken) ?? ""]
    
    func sendData(parameters: [String : Any], requestID : Int? = nil, completion: @escaping newRequest) {
        guard let id = requestID else {
            return
        }
        
        guard let newRequestURL = URL(string: "https://intern2019dev.clover.studio/users/newUser/\(id)") else {
            completion(nil)
            return
        }
        
        Alamofire.request(newRequestURL, method: .put, parameters: parameters, headers: token).responseJSON {
            response in
            if response.result.isSuccess {
                let json = JSON(response.result.value as Any)
                completion(json)
                print(json)
            } else if response.result.isFailure {
                print(response.result.error as Any)
                completion(nil)
            }
        }
    }
}
