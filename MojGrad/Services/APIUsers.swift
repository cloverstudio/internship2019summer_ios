//
//  APIUsers.swift
//  MojGrad
//
//  Created by Ja on 17/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIUsers {
    typealias usersDataService = (JSON?) -> Void
    
    let token : [String:String] = ["token" : UserDefaults.standard.string(forKey: Keys.jasonWebToken) ?? ""]
    
    func fetchUsersData(searchWord: String? = nil , completion: @escaping usersDataService) {
        let searchString = searchWord != nil ? "?findBy=" + searchWord! : ""
        guard let newUserUrl = URL(string: "https://intern2019dev.clover.studio/users/allUsers" + searchString) else {
            completion(nil)
            return
        }
        Alamofire.request(newUserUrl, method: .get, parameters: nil, headers: token).responseJSON {
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
