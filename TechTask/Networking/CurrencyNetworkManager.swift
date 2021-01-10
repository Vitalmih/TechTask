//
//  CurrencyNetworkManager.swift
//  TechTask
//
//  Created by Виталий on 05.01.2021.
//

import Foundation

protocol CurrencyNetworkManagerProtocol {
    var dataTask: URLSessionDataTask? { get }
    var delegate: CurrencyNetworkManagerDelegate? { get set }
    
    func fetchCurrency()
}

protocol CurrencyNetworkManagerDelegate {
    func didGetCurrency(currencies: [CurrencyDataModel])
    func didFailWithError(error: Error)
}

class CurrencyNetworkManager: CurrencyNetworkManagerProtocol {
    var dataTask: URLSessionDataTask?
    var delegate: CurrencyNetworkManagerDelegate?
    private let allCurrenciesLink = "https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?json"
    
    func fetchCurrency() {
        performRequest(urlString: allCurrenciesLink)
    }
    
    private func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            dataTask = session.dataTask(with: url) { (data, respone, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                if let safeData = data {
                    self.parseJSON(data: safeData)
                }
            }
            dataTask?.resume()
        }
    }
    
    private func parseJSON(data: Data) {
        let decoder = JSONDecoder()
        do {
            var currencyArray: [CurrencyDataModel] = []
            let decodedData = try decoder.decode([CurrencyDataModel].self, from: data)
            for currency in decodedData {
                currencyArray.append(currency)
                print("NETWORK ====== \(currency.validCode)")
            }
            DispatchQueue.main.async {
                self.delegate?.didGetCurrency(currencies: currencyArray)
            }
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
}
