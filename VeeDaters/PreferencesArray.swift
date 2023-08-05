//
//  PreferencesArray.swift
//  Veedater
//
//  Created by Sachin Khosla on 05/01/18.
//  Copyright © 2018 DigiMantra. All rights reserved.
//

import Foundation


var genderArray: [String] = [
    
    "Man",
    "Woman",
    "Other"
]

var showMeGenderArray: [String] = [
    
    "Men",
    "Women",
    "All"
]

var martialArray: [String] = [

    "Single",
    "Married",
    "Remarried",
    "Separated",
    "Divorced",
    "Widowed"
]

var religionArray: [String] = [
    
    "Christians",
    "Muslims",
    "Irreligious and atheist",
    "Hindus",
    "Buddhists",
    "Taoists",
    "Confucianists",
    "Ethnic and indigenous",
    "Sikhism",
    "Judaism",
    "Spiritism",
    "Bahá'ís",
    "Jainism",
    "Shinto",
    "Cao Dai",
    "Tenrikyo",
    "Neo-Paganism",
    "Unitarian Universalism",
    "Rastafari",
    "Other",
]

var incomeArray: [String] = [
    
    "$3000 - $5000",
    "$5000 - $10000",
    "$10000 - $20000",
    "Above $20000"
]

var sportsArray: [String] = [
    
    "Archery",
    "Badminton",
    "Basketball",
    "Softball",
    "Beach Volleyball",
    "Boxing",
    "Cycling",
    "Diving",
    "Golf",
    "Baseball",
    "Gymnastics",
    "Ludo",
    "Karate",
    "Soccer",
    "Swimming",
    "Surfing",
    "Table Tennis",
    "Tennis",
    "Taekwondo",
    "Wrestling",
    "Cricket",
    "Other"
]

var fashionArray: [String] = [
    
    "Trendy",
    "Casual",
    "Exotic",
    "Vibrant",
    "Sexy",
    "Preppy",
    "Elegant",
    "Bohemian",
    "Punk",
    "Artsy",
    "Gothic",
    "Rocker",
    "50s",
    "70s",
    "Sporty",
    "Other",
]

func countries() -> [String] {
    
    var countryArray = [String]()
    
    for code in NSLocale.isoCountryCodes as [String] {
        let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
        let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
        countryArray.append(name)
    }
    
    return countryArray
}
