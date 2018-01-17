//
//  PersistentUserData.swift
//  WeatherApp
//
//  Created by Ranjith on 1/17/18.
//  Copyright (c) . All rights reserved.
//

import Foundation
let kUserSavedCity: String = "UserSavedCity"
let kUserDefaultSavedCity: String = "UserDefaultSavedCity"

class WAUser {
    static let shared = WAUser()
    var cityList:[String]!
    private var _defaultCity = ""
    var defaultCity: String {
        set {
            _defaultCity = newValue
            UserDefaults.standard.setValue(newValue, forKey: kUserDefaultSavedCity)
        }
        get {
            if let city = UserDefaults.standard.value(forKey: kUserDefaultSavedCity) as? String {
                return city
            } else {
                return ""
            }
        }
    }

    init() {
        if let cityL = UserDefaults.standard.value(forKey: kUserSavedCity) as? [String] {
            cityList = cityL
        }
    }
}
