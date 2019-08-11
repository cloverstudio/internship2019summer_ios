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
    
    var regData = SignUpDataModel()
    
    func sendData(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Yeah")
                let registerJSON : JSON = JSON(response.result.value!)
                self.updateData(json: registerJSON)
            } else {
                print("Error")
            }
            
        }
    }
    
    func updateData(json: JSON) {
        if let tmpEmail = json["data"]["user"]["email"].string {
            regData.email = tmpEmail
            regData.oib = json["data"]["user"]["oib"].stringValue
            regData.id = json["data"]["user"]["id"].intValue
            regData.personRoleId = json["data"]["user"]["personsRoleId"].intValue
            regData.password = json["data"]["user"]["password"].stringValue
            regData.jwt = json["data"]["user"]["jwt"].stringValue
        }
        print(regData.email)
        print(regData.oib)
        print(regData.id)
        print(regData.personRoleId)
        print(regData.jwt)
        print(regData.password)
    }
}
