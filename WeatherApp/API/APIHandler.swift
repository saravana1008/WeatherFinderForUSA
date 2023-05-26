//
//  APIHandler.swift
//  WeatherApp
//
//  Created by Saravanakumar Balasubramanian on 24/05/23.
//

import Foundation

class APIHandler: NSObject {
    
    private let apiKey = "886705b4c1182eb1c69f28eb8c520e20"
    
    private let baseUrl = "https://api.openweathermap.org"
    
    private let locationFinderUrl = "/data/2.5/weather"
    
    private let coordinateFinderUrl = "/geo/1.0/reverse"
    
    func getLocationUrl(LocString: String) -> String {
        return baseUrl + locationFinderUrl + "?q=\(LocString)" + "&appid=\(apiKey)"
    }
    
    func getweatherReportUrl(lat: String, long: String) -> String {
        return baseUrl + locationFinderUrl + "?lat=\(lat)&lon=\(long)" + "&appid=\(apiKey)"
//    http://api.openweathermap.org/geo/1.0/reverse?lat=51.5098&lon=-0.1180&limit=5&appid={API key}
    }
    
    func getWeatherReport(locStr: String, completionHandler: @escaping ((WeatherDetail?, String?) -> Void)) {
        let destUrl = getLocationUrl(LocString: locStr)
        guard let validUrl = URL(string: destUrl) else {
            completionHandler(nil, "Invalid Url")
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: validUrl)) { (data, urlResp, err) in
            guard let validData = data else {
                completionHandler(nil, "Invalid Data received")
                return
            }
            let jsonDecoder = JSONDecoder()
            if let weatherDetail = try? jsonDecoder.decode(WeatherDetail.self, from: validData) {
                completionHandler(weatherDetail, nil)
            } else {
                completionHandler(nil, "City not found. Please enter valid region")
            }
        }.resume()
    }
    
    func getWeatherReport(lat: String, long: String, completionHandler: @escaping ((WeatherDetail?, String?) -> Void)) {
        let destUrl = getweatherReportUrl(lat: lat, long: long)
        guard let validUrl = URL(string: destUrl) else {
            completionHandler(nil, "Invalid Url")
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: validUrl)) { (data, urlResp, err) in
            guard let validData = data else {
                completionHandler(nil, "Invalid date received")
                return
            }
            let jsonDecoder = JSONDecoder()
             if let weatherDetail = try? jsonDecoder.decode(WeatherDetail.self, from: validData) {
                 completionHandler(weatherDetail, nil)
            } else {
                completionHandler(nil, "City not found. Please enter valid region")
            }
        }.resume()
    }
    
}
