//
//  UserRequestsService.swift
//  MojGrad
//
//  Created by Ja on 23/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserRequestService {
    
    typealias userRequestData = (JSON?) -> Void
    
    let token : [String:String] = ["token" : UserDefaults.standard.string(forKey: Keys.jasonWebToken) ?? ""]
    
    func fetchData(searchWord: String? = nil, completion: @escaping userRequestData) {
        let searchString = searchWord != nil ? "?findBy=" + searchWord! : ""
        guard let requestURL = URL(string: "https://intern2019dev.clover.studio/requests/myRequests" + searchString) else {
            completion(nil)
            return
        }
        Alamofire.request(requestURL, method: .get, parameters: nil, headers: token).responseJSON {
            response in
            if response.result.isSuccess {
                let json = JSON(response.result.value as Any)
                print(json)
                completion(json)
            } else if response.result.isFailure {
                print(response.result.error)
                completion(nil)
            }
        }
    }
}
