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
    
    var listOfItems : [String] = ["Sve", "Kvar", "Prijedlog"]
    
    var allRequests = [JSON]()
    var requestData = UserRequestService()
    let regionInMeters : Double = 500
    var request = UserRequests()
    var requestType : String?
    
    @IBOutlet weak var typeOfRequestTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createRequestPicker()
        createToolbar()
        
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
    
    func createRequestPicker() {
        let requestPicker = UIPickerView()
        requestPicker.delegate = self
        typeOfRequestTextField.inputView = requestPicker
        requestPicker.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1)
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        toolBar.tintColor = #colorLiteral(red: 0, green: 0.462745098, blue: 1, alpha: 1)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(NewRequestViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        typeOfRequestTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        downloadRequests(searchWord: requestType)
    }
    
    @objc func downloadRequests() {
        downloadRequests(searchWord: nil)
    }
    
    @objc func downloadRequests(searchWord: String? = nil) {
        requestData.fetchData(searchWord: requestType) { dataJSON in
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
        cell.requestId = request["ID"].int
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        cell.mapView.setRegion(region, animated: true)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserRequests else {
            return
        }
        
        let storyboard = UIStoryboard(name: "UserRequests", bundle: nil)
        let destination = storyboard.instantiateViewController(withIdentifier: "EditUserRequest") as! EditUserRequestViewController
        destination.requestId = cell.requestId
        destination.address = cell.addressLabel.text
        destination.titleRequest = cell.titleLabel.text
        destination.message = cell.messageRequest.text
        navigationController?.pushViewController(destination, animated: true)
    }
}

extension UserRequestViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listOfItems.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listOfItems[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeOfRequestTextField.text = listOfItems[row]
        
        if typeOfRequestTextField.text != "Sve" {
            requestType = typeOfRequestTextField.text
        } else {
            requestType = nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = #colorLiteral(red: 0, green: 0.5558522344, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir", size: 17)
        
        label.text = listOfItems[row]
        
        return label
    }
}

