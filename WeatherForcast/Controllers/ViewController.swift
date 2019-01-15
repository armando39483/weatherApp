//
//  ViewController.swift
//  WeatherForcast
//
//  Created by Armando D Gonzalez on 9/18/18.
//  Copyright © 2018 Armando D Gonzalez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var collectionView: UICollectionView!

    // MARK: - Properties
    
    private let columnLayout = MainFlowLayout(cellsPerRow: 1, minimumInteritemSpacing: 1, minimumLineSpacing: 1, sectionInset: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
    private let locations = ["Gothenburg","Stockholm","Mountain View","London","New York", "Berlin"]
    private var locationInfo = [Location]()
    private var weatherInfo = [String:Weather]()

    // MARK: - Lifecyle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    // MARK: - Setup Methods
    
    private func setUpView() {
        collectionView.collectionViewLayout = columnLayout
        collectionView.contentInsetAdjustmentBehavior = .always
        
        let nib = UINib(nibName: "WeatherCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "weatherCell")
        
        NetworkManager.shared.getLocationInfoFor(index: 0,  locations: self.locations, locationInfo: self.locationInfo, completion: { [unowned self]
            (locationInfo) in
            
            self.locationInfo = locationInfo
            
            NetworkManager.shared.getWeatherFor(index: 0, locations: locationInfo, weatherInfo: [String:Weather](), completion: { [unowned self]
                (weatherInfo) in
                self.weatherInfo = weatherInfo
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            })
        })
    }
}

extension ViewController {
    
    // MARK: -  Helper Methods
    
    func getDegreesFehrenheitFrom(celsius: Float) -> Float {
        return round((celsius * (9/5)) + 32)
    }
    
    func getMinMaxTempLabelFor(_ weather: Weather) -> String {
        let min = Int(round(weather.minTemp))
        let max = Int(round(weather.maxTemp))
        let degreeSymbol = "°"
        return "Low \(min)" + degreeSymbol + " | Hi \(max)" + degreeSymbol
    }
    
    func getWindLabelFor(_ weather: Weather) -> String {
        let speed = Int(round(weather.windSpeed))
        return weather.windDirectionCompass + " \(speed) mph"
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - CollectionView Delegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return weatherInfo.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let degreeSymbol = "°"
        let identifier = "weatherCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? WeatherCell else {
            return UICollectionViewCell()
        }
        if weatherInfo.count > 0 {
            if let currentWeather = weatherInfo[locationInfo[indexPath[0]].title] {
                NetworkManager.shared.getImage(weatherStateAbbreviatin: currentWeather.weatherStateAbbr) { (data) in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.imageV.image = image
                        }
                    } else {
                        logError("There was an error converting imageData to an image.")
                    }
                }
                cell.temperatureLabel.text = "\(currentWeather.theTemp)" + degreeSymbol + "C"
                cell.descriptionLabel.text = currentWeather.weatherStateName
                let minMaxTempLabel = getMinMaxTempLabelFor(currentWeather)
                cell.minMaxTempLabel.text = minMaxTempLabel
                let windLabel = getWindLabelFor(currentWeather)
                cell.windLabel.text = windLabel
                cell.humidityLabel.text = "\(currentWeather.humidity)%"
                cell.pressureLabel.text = "\(Int(round(currentWeather.airPressure))) in"
                cell.visibilityLabel.text = "\(Int(round(currentWeather.visibility))) mi"
            }
        }
        return cell
    }

    @objc func collectionView(_ collectionView: UICollectionView, layout  collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: 400, height: 50)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as? SectionHeaderView else {
            return UICollectionReusableView()
        }
        if locationInfo.count > 0 {
            sectionHeaderView.cityNameLabel.text = locationInfo[indexPath[0]].title

            sectionHeaderView.dateLabel.text = Date.tomorrowDateString()
        }
        return sectionHeaderView
    }
}
