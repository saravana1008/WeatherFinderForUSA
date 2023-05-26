//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Saravanakumar Balasubramanian on 24/05/23.
//

import UIKit
import MapKit
import SwiftUI
import CoreLocation

protocol HomeViewDelegate {
    func updateUI(weatherDetail: WeatherDetailViewItem)
    func presentAlert(msg: String)
}

class HomeViewModel: NSObject {
    
    private let apiHandler = APIHandler()
    private var viewController: UIViewController?
    private var delegate: HomeViewDelegate?
    private var locationCoordinate: CLLocationCoordinate2D?
    
    convenience init(vc: UIViewController, delegate: HomeViewDelegate) {
        self.init()
        self.viewController = vc
        self.delegate = delegate
    }
    
    func loadData(searchText: String) {
        apiHandler.getWeatherReport(locStr: searchText) { [weak self] (weatherDetail, err) in
            guard let `self` = self else { return }
            validateWeatherDetail(detail: weatherDetail, err: err, searchKey: searchText)
        }
    }
    
    func loadCurrentLocation() {
        LocationHandler.shared.getCurrentLocation(completionHandler: { [weak self] (location, error) in
            guard let `self` = self, let validLoc = location else { return }
            self.loadDetailsFromCoordinates(lat: "\(validLoc.coordinate.latitude)", long: "\(validLoc.coordinate.longitude)")
        })
    }
    
    func loadDetailsFromCoordinates(lat: String, long: String) {
        apiHandler.getWeatherReport(lat: lat, long: long) { [weak self] (weatherLocDetail, err) in
            guard let `self` = self else { return }
            validateWeatherDetail(detail: weatherLocDetail, err: err)
        }
    }
    
    func validateWeatherDetail(detail: WeatherDetail?, err: String?, searchKey: String? = nil) {
        if let validDetail = detail {
            let country = validDetail.sys.country.lowercased()
            guard country == "us" || country == "usa" else {
                delegate?.presentAlert(msg: "Please enter valid US region")
                return
            }
            if let validSearchparm = searchKey, !validSearchparm.isEmpty {
                UserDefaults.standard.set(validSearchparm, forKey: "lastLocation")
            }
            locationCoordinate = CLLocationCoordinate2D(latitude: validDetail.coord.lat, longitude: validDetail.coord.lon)
            let viewItem = WeatherDetailViewItem(weatherDetailItem: validDetail)
            delegate?.updateUI(weatherDetail: viewItem)
        } else if let validErr = err {
            delegate?.presentAlert(msg: validErr)
        }
    }
    
    func navigateMapDetail() {
        guard let validCoordinate = locationCoordinate else { return }
        let mapEnvObject = MapViewEnvironmentObject()
        mapEnvObject.coordinateRegion = MKCoordinateRegion(center: validCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        let mapDetailView = UIHostingController(rootView: MapDetailView().environmentObject(mapEnvObject))
        viewController?.navigationController?.pushViewController(mapDetailView, animated: true)
    }
}
