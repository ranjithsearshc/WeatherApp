//
//  DataViewController.swift
//  WeatherApp
//
//  Created by Ranjith on 1/17/18.
//  Copyright (c) . All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON

let kMainURL: String = "http://openweathermap.org"

protocol ReceiveData :class {
    func dataReceive(_ cityName:String)
}

class DataViewController: UIViewController {

    var cityName: String!

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchReloadWeatherForCity(cityName)
    }

    //MARK: FeatchData
    func fetchReloadWeatherForCity(_ city: String) {
        let urlStr = kBaseURL + "/data/2.5/weather?q=" + city.formateCity() + "&APPID=" + kWeatherApiKey
        guard let url = URL(string: urlStr) else { return }
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default)
            .responseJSON(completionHandler: { (responseData) in
                if responseData.error != nil || responseData.result.value == nil {
                    WAAlertView.cityAlertView.show()
                    return
                }
                guard let json = responseData.result.value else {
                    WAAlertView.cityAlertView.show()
                    return
                }
                let response = WeatherResponse(object: json)
                self.configureWithWeather(response)
            })
    }
    
    //MARK: load data into UI
    func configureWithWeather(_ weatherResponse: WeatherResponse) {
        guard let weather = weatherResponse.weather?.first else { return }
        
        if let iconFileName = weather.icon {
            let urlStr = kMainURL + "/img/w/" + iconFileName + ".png"
            if let url = URL(string: urlStr) {
                iconImageView.af_setImage(withURL: url)
            }
        }
        
        cityLabel?.text = cityName + ", " + (weatherResponse.sys?.country ?? "")
        weatherConditionLabel?.text = weather.descriptionValue?.capitalized
        highTempLabel?.text = "H " + convertCelcius(temKelvin: weatherResponse.main?.tempMax ?? 0.0)
        lowTempLabel?.text = "L " + convertCelcius(temKelvin: weatherResponse.main?.tempMin ?? 0.0)
        currentTempLabel?.text = convertCelcius(temKelvin: weatherResponse.main?.temp ?? 0.0) + "°"
    }

    func convertCelcius(temKelvin: Float) -> String {
        let celsiusTemp = temKelvin - 273.15
        return String(format: "%.0f", celsiusTemp)
    }
    
    
    //MARK: Seguable methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seachSegue" {
            let searchTableViewController = segue.destination as! searchTableViewController
            searchTableViewController.delegate = self
        }
    }
}

//MARK: Protocol Methods
extension DataViewController:ReceiveData {
    func dataReceive(_ cityName: String) {
        self.cityName = cityName
    }
}
