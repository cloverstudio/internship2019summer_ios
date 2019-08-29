//
//  AddNewFeedViewController.swift
//  MojGrad
//
//  Created by Ja on 19/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation


class NewRequestViewController: UIViewController {
    
    var listOfItems : [String] = ["Kvar", "Prijedlog"]
    
    let locationManager = CLLocationManager()
    let regionInMeters : Double = 10000
    var previousLocation : CLLocation?
    
    var newRequest = UserSendNewRequestService()
    
    @IBOutlet weak var titleText: UITextView!
    @IBOutlet weak var typeOfRequestTextField: UITextField!
    
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var placeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createRequestPicker()
        createToolbar()
        
        titleText.addBottomBorderWithColor(color: #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1), height: 3.0)
        messageTextView.addBottomBorderWithColor(color: #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1), height: 3.0)
        
        checkLocationServices()
    }
    @IBAction func sendRequestButtonTapped(_ sender: UIButton) {
        
        guard let title = titleText.text else {return}
        guard let address = placeLabel.text else {return}
        guard let typeRequest = typeOfRequestTextField.text else {return}
        guard let message = messageTextView.text else {return}
        
        getLongLat(address: address) { array in
            
            let latitude = array[0]
            let longitude = array[1]
            
            let param : [String : Any] = ["Title" : title, "Request_type" : typeRequest, "location_latitude" : latitude, "location_longitude" : longitude, "message" : message]
            
            self.newRequest.sendData(parameters: param) { jsonData in
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
                self.showAlert(withTitle: "Super", withMessage: "Zahtjev uspješno kreiran", okAction: ok)
            }
        }
        UserDefaults.standard.set(true, forKey: Keys.requestSent)
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
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
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

extension NewRequestViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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

extension NewRequestViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension NewRequestViewController: MKMapViewDelegate {
    
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
                self.placeLabel.text = "\(streetNumber) \(streetName), \(cityName)"
            }
        }
    }
}

