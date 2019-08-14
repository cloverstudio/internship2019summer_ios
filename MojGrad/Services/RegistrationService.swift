//
//  LoginService.swift
//  MojGrad
//
//  Created by Ja on 09/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RegistrationService {
    
    typealias WebServiceRepsonse = (JSON?) -> Void
    
    func sendData(parameters: [String : String], completion: @escaping WebServiceRepsonse) {
        guard let registrationURL = URL(string : "https://intern2019dev.clover.studio/users/register") else {
            completion(nil)
            return
        }
        Alamofire.request(registrationURL, method: .post, parameters: parameters).responseJSON {
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
