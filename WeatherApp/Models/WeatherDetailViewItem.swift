//
//  WeatherDetailViewItem.swift
//  WeatherApp
//
//  Created by Saravanakumar Balasubramanian on 26/05/23.
//

import Foundation

struct WeatherDetailViewItem {
    let timeStamp: String
    let locationName: String
    let temp: String
    let additionalInfo: String
    let humidity: String
    let dewPoint: String
    let pressure: String
    let visibility: String
    let weatherIconUrl: String
    var windSpeed: String
    
    init(weatherDetailItem: WeatherDetail) {
        let date = Date(timeIntervalSince1970: TimeInterval(weatherDetailItem.dt))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        dateFormatter.pmSymbol = "pm"
        dateFormatter.amSymbol = "am"
        let localDate = dateFormatter.string(from: date)
        
        timeStamp = localDate
        locationName = "\(weatherDetailItem.name), \(weatherDetailItem.sys.country)"
        temp = String(format: "%.0f °C", weatherDetailItem.main.temp - 273.15)
        let feelsLikeTemp = String(format: "%.0f °C", weatherDetailItem.main.feelsLike - 273.15)
        var additionalInfoStr = ""
        var weatherIconUrlStr = ""
        if let firstWeatherDetail = weatherDetailItem.weather.first {
            additionalInfoStr = firstWeatherDetail.description
            weatherIconUrlStr = "https://openweathermap.org/img/wn/\(firstWeatherDetail.icon)@2x.png"
        }
        additionalInfo = "Feels like \(feelsLikeTemp). \(additionalInfoStr.capitalized)."
        weatherIconUrl = weatherIconUrlStr
        humidity = "Humidity: \(weatherDetailItem.main.humidity)%"
        let temp = weatherDetailItem.main.temp - 273.15
        let humidity = Double(weatherDetailItem.main.humidity)
        let dewPointStr =  (temp - (14.55 + 0.114 * temp) * (1 - (0.01 * humidity)) - pow(((2.5 + 0.007 * temp) * (1 - (0.01 * humidity))),3) - (15.9 + 0.117 * temp) * pow((1 - (0.01 * humidity)), 14))
        dewPoint = "Dew point: \(String(format: "%.0f", dewPointStr)) °C"
        pressure = "Pressure: \(weatherDetailItem.main.pressure)hPa"
        let visibilityStr = String(format: "%.1f", Double(weatherDetailItem.visibility)/1000)
        visibility = "Visibility: \(visibilityStr)km"
        
        windSpeed = ""
        let windSpeedStr = String(format: "%.1f", weatherDetailItem.wind.speed)
        let directionText = getDirectionTxt(value: "\(weatherDetailItem.wind.deg)")
        windSpeed = "Wind speed: \(windSpeedStr)m/s \(directionText)"

    }
    
    private func getDirectionTxt(value: String) -> String {
        var strDirection = ""
        let intValue = Int(value) ?? 0
        if intValue > 23 && intValue <= 67 {
            strDirection = "North East"
        } else if intValue > 68 && intValue <= 112 {
            strDirection = "East"
        } else if intValue > 113 && intValue <= 167 {
            strDirection = "South East"
        } else if intValue > 168 && intValue <= 202 {
            strDirection = "South"
        } else if intValue > 203 && intValue <= 247 {
            strDirection = "South West"
        } else if intValue > 248 && intValue <= 293 {
            strDirection = "West"
        } else if intValue > 294 && intValue <= 337 {
            strDirection = "North West"
        } else if intValue >= 338 || intValue <= 22 {
            strDirection = "North"
        }
        return strDirection
    }
}
