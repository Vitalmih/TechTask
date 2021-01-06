//
//  CurrencyNetworkManager.swift
//  TechTask
//
//  Created by Виталий on 05.01.2021.
//

import Foundation

struct CurrencyDataModel: Codable{
    let currencyName: String
    let rate: Double
    let validCode: String
    
    private enum CodingKeys: String,CodingKey {
        case currencyName = "txt"
        case rate
        case validCode = "cc"
    }
}
