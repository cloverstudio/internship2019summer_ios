//
//  LoginService.swift
//  MojGrad
//
//  Created by Ja on 12/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON

class LoginService {
    
    typealias WebServiceRepsonse = (JSON?) -> Void
    
    func fetchData(parameters: [String : String], completion: @escaping WebServiceRepsonse) {
        guard let registrationURL = URL(string : "https://intern2019dev.clover.studio/users/login") else {
            completion(nil)
            return
        }
        Alamofire.request(registrationURL, method: .post, parameters: parameters).responseJSON {
            response in

        }
    }
}
