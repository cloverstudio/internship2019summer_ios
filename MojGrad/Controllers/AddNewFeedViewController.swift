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
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var placeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.isHidden = true
        pickerView.delegate = self

        titleText.addBottomBorderWithColor(color: #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1), height: 3.0)
        messageTextView.addBottomBorderWithColor(color: #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1), height: 3.0)
        
        checkLocationServices()
    }
    @IBAction func sendRequestButtonTapped(_ sender: UIButton) {
        
        guard let title = titleText.text else {return}
        guard let address = placeLabel.text else {return}
        guard let typeRequest = dropDownBtn.titleLabel?.text else {return}
        guard let message = messageTextView.text else {return}
        
        getLongLat(address: address) { array in
            
            let latitude = array[0]
            let longitude = array[1]
            
            let param : [String : Any] = ["Title" : title, "Request_type" : typeRequest, "location_latitude" : latitude, "location_longitude" : longitude, "message" : message]
            
            self.newRequest.sendData(parameters: param)
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
    
    @IBAction func dropDownBtnClicked(_ sender: UIButton) {
        if pickerView.isHidden {
            animateToogle(toogle: true)
        } else {
            animateToogle(toogle: false)
        }
    }
    
    
    func animateToogle(toogle: Bool) {
        if toogle {
            UIView.animate(withDuration: 0.3) {
                self.pickerView.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.pickerView.isHidden = true
            }
        }
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
        dropDownBtn.setTitle(listOfItems[row], for: .normal)
        animateToogle(toogle: false)
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
