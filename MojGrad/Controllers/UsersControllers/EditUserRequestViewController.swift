//
//  EditUserRequestViewController.swift
//  MojGrad
//
//  Created by Ja on 28/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit
import MapKit

class EditUserRequestViewController: UIViewController {

    var requestId : Int?
    var address : String?
    var message: String?
    var titleRequest : String?
    var requestType : String?
    
    let listOfItems = ["Sve", "Kvar", "Prijedlog"]
    
    let locationManager = CLLocationManager()
    let regionInMeters = 50000
    var previousLocation : CLLocation?
    
    var editRequest = UserEditRequestService()
    
    @IBOutlet weak var titleOfRequest: UITextView!
    @IBOutlet weak var typeOfRequest: UITextField!
    @IBOutlet weak var messageOfRequest: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fillRequest()
        createRequestPicker()
        createToolbar()
        showAddressOnMap()
        
        checkLocationServices()
    }
    
    @IBAction func sendRequestButtonClicked(_ sender: UIButton) {
        
        let title = titleOfRequest.text ?? ""
        let address = addressLabel.text ?? ""
        let typeRequest = typeOfRequest.text ?? ""
        let message = messageOfRequest.text ?? ""
        
        let id = requestId
        
        getLongLat(address: address) { array in
             
            let latitude = array[0]
            let longitude = array[1]
            
            let param : [String : Any] = ["Title" : title, "Request_type" : typeRequest, "location_latitude" : latitude, "location_longitude" : longitude, "message" : message]
            print(param)
            self.editRequest.sendData(parameters: param, requestID: id) { jsonData in
                guard let _ = jsonData else {
                    self.showAlert(withTitle: "Error", withMessage: "Server down!")
                    return
                }
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                    NotificationCenter.default.post(name: Notification.Name(NewUserController.CONSTANT_REFRESH_USERS), object: nil)
                    let storyboard = UIStoryboard.init(name: "UserRequests", bundle: nil)
                    let destination = storyboard.instantiateViewController(withIdentifier: "UserRequests")
                    self.navigationController?.pushViewController(destination, animated: true)
                    
                })
                self.showAlert(withTitle: "Super", withMessage: "Izmjena uspješno kreirana", okAction: ok)
            }
        }
    }
    
    
    func fillRequest() {
        addressLabel.text = address
        titleOfRequest.text = titleRequest
        typeOfRequest.text = requestType
        messageOfRequest.text = message
    }
    
    func createRequestPicker() {
        let requestPicker = UIPickerView()
        requestPicker.delegate = self
        typeOfRequest.inputView = requestPicker
        requestPicker.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1)
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        toolBar.tintColor = #colorLiteral(red: 0, green: 0.462745098, blue: 1, alpha: 1)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(NewRequestViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        typeOfRequest.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAddressOnMap() {
        let geoCoder = CLGeocoder()
        guard let address = address else { return }
        geoCoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            if let placemark = placemarks?.first, let location = placemark.location {
                
                if var region = self?.mapView.region {
                    region.center = location.coordinate
                    region.span.longitudeDelta /= 500.0
                    region.span.latitudeDelta /= 500.0
                    self?.mapView.setRegion(region, animated: true)
                }
            }
        }
    }
    
    typealias GetLatLong = ([Double]) -> Void
    
    func getLongLat(address: String, completion: @escaping GetLatLong) {
        let geoCoder = CLGeocoder()
        var array = [Double]()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemark = placemarks?.first?.location?.coordinate else {return}
            
            let latitude = placemark.latitude
            array.append(latitude)
            
            let longitude = placemark.longitude
            array.append(longitude)
            
            completion(array)
        }
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: CLLocationDistance(regionInMeters), longitudinalMeters: CLLocationDistance(regionInMeters))
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAuthorization()
        } else {
            showAlert(withTitle: "Info", withMessage: "Location service disabled.")
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTackingUserLocation()
        case .denied:
            showAlert(withTitle: "Info", withMessage: "Set up permissions")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }
    
    func startTackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension EditUserRequestViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        typeOfRequest.text = listOfItems[row]
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

extension EditUserRequestViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension EditUserRequestViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                self.showAlert(withTitle: "Location problems", withMessage: "Can not find place")
                return
            }
            
            guard let placemark = placemarks?.first else {
                self.showAlert(withTitle: "Location problems", withMessage: "Can not find placemark")
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let cityName = placemark.country ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumber) \(streetName), \(cityName)"
            }
        }
    }
}
