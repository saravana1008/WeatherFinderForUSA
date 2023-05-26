//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Saravanakumar Balasubramanian on 24/05/23.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var weatherStatusImgView: UIImageView!
    @IBOutlet weak var additionalInfoLbl: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var dewPointLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var parentView: UIView!
    
    
    var viewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        performBaseSetup()
        let lastLocation = UserDefaults.standard.value(forKey: "lastLocation") as? String ?? ""
        if !lastLocation.isEmpty {
            viewModel?.loadData(searchText: lastLocation)
        } else {
            viewModel?.loadCurrentLocation()
        }
    }
    
    private func performBaseSetup() {
        title = "Weather Finder"
        viewModel = HomeViewModel(vc: self, delegate: self)
    }
    
    // MARK: - Action Handling
    @IBAction func mapDetailAction(_ sender: Any) {
        viewModel?.navigateMapDetail()
    }
    
    @IBAction func currentLocationBtnAction(_ sender: Any) {
        viewModel?.loadCurrentLocation()
    }
}

// MARK: - Home View Delgate
extension HomeViewController: HomeViewDelegate {
    func updateUI(weatherDetail: WeatherDetailViewItem) {
        DispatchQueue.main.async {
            self.parentView.isHidden = false
            self.timeStampLabel.text = weatherDetail.timeStamp
            self.locationNameLabel.text = weatherDetail.locationName
            self.degreeLabel.text = weatherDetail.temp
            self.additionalInfoLbl.text = weatherDetail.additionalInfo
            self.windSpeedLabel.text = weatherDetail.windSpeed
            self.humidityLabel.text = weatherDetail.humidity
            self.dewPointLabel.text = weatherDetail.dewPoint
            self.pressureLabel.text = weatherDetail.pressure
            self.visibilityLabel.text = weatherDetail.visibility
            
            guard let validImageUrl = URL(string: weatherDetail.weatherIconUrl) else { return }
            let imageDownloader = ImageDownloader()
            Task {
                do {
                    let image = try await imageDownloader.downloadImage(from: validImageUrl)
                    self.weatherStatusImgView.image = image
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func presentAlert(msg: String) {
        let alertPrompt = UIAlertController(title: "Message", message: msg, preferredStyle: .alert)
        let okBtnAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertPrompt.addAction(okBtnAction)
        DispatchQueue.main.async {
            self.parentView.isHidden = true
            self.present(alertPrompt, animated: true, completion: nil)
        }
    }
}

//MARK: - SearchBar Delegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        viewModel?.loadData(searchText: searchText)
    }
}
