//
//  LocationHandler.swift
//  WeatherApp
//
//  Created by Saravanakumar Balasubramanian on 24/05/23.
//

import Foundation
import CoreLocation

class LocationHandler: NSObject {
    
    static let shared = LocationHandler()
    
    var locationManager: CLLocationManager?
    typealias completionHandler = (_ location: CLLocation?,_ error: String?) -> Void
    var completion: completionHandler?
    
    private override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
    }
    
    func getCurrentLocation(completionHandler: completionHandler?) {
        completion = completionHandler
        
        if let validLocationMngr = locationManager, validLocationMngr.authorizationStatus == .denied || validLocationMngr.authorizationStatus == .restricted {
            completion?(nil, "Please provide location access to this app in your device settings")
        } else if locationManager?.authorizationStatus == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        } else {
            locationManager?.requestLocation()
        }
    }
}

// MARK: - Location Manager Delegate
extension LocationHandler: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }
        completion?(userLocation, nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            locationManager?.requestLocation()
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .restricted:
            completion?(nil, "Please allow access to location to enable this furture")
        case .denied:
            completion?(nil, "Please allow access to location to enable this furture")
        case .authorizedWhenInUse:
            locationManager?.requestLocation()
        @unknown default:
            ()
        }
    }
}

