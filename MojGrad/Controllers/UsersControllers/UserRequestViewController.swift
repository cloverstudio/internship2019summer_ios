//
//  UserRequestViewController.swift
//  MojGrad
//
//  Created by Ja on 23/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit
import CoreLocation

class UserRequestViewController: UIViewController {
    
    var allRequests = [JSON]()
    var requestData = UserRequestService()
    let regionInMeters : Double = 500
    var request = UserRequests()

    @IBOutlet weak var choseRequest: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadRequests()
        
        self.navigationController!.navigationBar.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.downloadRequests), name: Notification.Name(NewUserController.CONSTANT_REFRESH_USERS), object: nil)
        
    }
    @IBAction func newRequestButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "UserRequests", bundle: nil)
        let destination = storyboard.instantiateViewController(withIdentifier: "CreateUserRequest")
        navigationController?.pushViewController(destination, animated: true)
    }
    
    
    @objc func downloadRequests() {
        downloadRequests(searchWord: nil)
    }
    
    @objc func downloadRequests(searchWord: String? = nil) {
        requestData.fetchData(searchWord: searchWord) { dataJSON in
            guard let data = dataJSON else {
                return
            }
            if let users = data["data"]["requests"].array {
                self.allRequests = users
                self.tableView.reloadData()
            }
            
        }
    }
    
    typealias getLocation = ([String]) -> Void
    
    func getAddress(longitude: Double, latitude: Double, completion: @escaping getLocation) {
        var array = [String]()
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(CLLocation.init(latitude: latitude, longitude:longitude)) { (placemarks,error) in
            if let _ = error {
                self.showAlert(withTitle: "Location problems", withMessage: "Can not find place")
                return
            }
            
            guard let placemark = placemarks?.first else {
                self.showAlert(withTitle: "Location problems", withMessage: "Can not find placemark")
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            array.append(streetNumber)
            
            let streetName = placemark.thoroughfare ?? ""
            array.append(streetName)
            
            let cityName = placemark.country ?? ""
            array.append(cityName)
            
            completion(array)
        }
    }
}

extension UserRequestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRequests.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let request = allRequests[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "userRequests") as! UserRequests
        
        let longitude = request["location_longitude"].double
        let latitude = request["location_latitude"].double
        
        let location = CLLocationCoordinate2DMake(latitude!, longitude!)
        
        getAddress(longitude: longitude!, latitude: latitude!) { array in
            
            let streetNumber = array[0]
            let streetName = array[1]
            let cityName = array[2]
            
            DispatchQueue.main.async {
                cell.addressLabel.text = "\(streetNumber) \(streetName), \(cityName)"
            }
        }
        
        let requestType = request["Request_type"].string
        
        cell.titleLabel.text = request["Title"].string
        cell.typeOfRequest.text = "Tip: \(requestType!)"
        cell.messageRequest.text = request["message"].string
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        //cell.mapView.setCenter(location, animated: true)
        cell.mapView.setRegion(region, animated: true)
        
        return cell
    }
}
