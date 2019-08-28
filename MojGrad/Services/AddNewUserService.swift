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
    
    func sendUserData(parameters: [String : Any], imageData: Data? = nil, completion: @escaping newUserService) {
        guard let newUserUrl = URL(string: "https://intern2019dev.clover.studio/users/newUser") else {
            completion(nil)
            return
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData {
                multipartFormData.append(data, withName: "photo", fileName: "image.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: newUserUrl, method: .post, headers: token) { (result) in
            print(result)
            switch result {
            case .success(let upload, _, _):
                print(upload)
                upload.responseJSON { response in
                    print(response)
                    if response.result.isSuccess {
                        let json = JSON(response.result.value as Any)
                        print(json)
                        completion(json)
                    }
                    else if response.result.isFailure {
                        print(response.result.error as Any)
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }

    }
    
    /*func sendUserData (parameters: [String : Any], completion: @escaping newUserService) {
        guard let newUserUrl = URL(string: "https://intern2019dev.clover.studio/users/newUser") else {
            completion(nil)
            return
        }
        Alamofire.request(newUserUrl, method: .post, parameters: parameters, headers: token).responseJSON {
            response in
            if response.result.isSuccess {
                let json = JSON(response.result.value as Any)
                print(json)
                completion(json)
            } else if response.result.isFailure {
                print(response.result.error as Any)
                completion(nil)
            }
        }
    }
    */
}
