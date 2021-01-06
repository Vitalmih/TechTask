//
//  CurrencyNetworkManager.swift
//  TechTask
//
//  Created by Виталий on 05.01.2021.
//

import Foundation

protocol CurrencyNetworkManagerProtocol {
    var dataTask: URLSessionDataTask? { get set }
    func fetchCurrency(currency: String)
}

protocol CurrencyNetworkManagerDelegate {
    func didGetCurrency(currencies: [CurrencyDataModel])
    func didFailWithError(error: Error)
}

class CurrencyNetworkManager: CurrencyNetworkManagerProtocol {
    var dataTask: URLSessionDataTask?
    var delegate: CurrencyNetworkManagerDelegate?
    let dispatchGroup = DispatchGroup()
    
    func fetchCurrency(currency: String) {
        dispatchGroup.enter()
        let urlString = ("\(ConstansValue.currencyByValidCode)\(currency)")
        performRequest(urlString: urlString)
        dispatchGroup.leave()
        print(urlString)
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
        
        print("Enter")
        let decoder = JSONDecoder()

        do {
            let decodedData = try decoder.decode([CurrencyDataModel].self, from: data)
            var currencyArray: [CurrencyDataModel] = []
            for currency in decodedData {
                currencyArray.append(currency)
                print("NETWORK ====== \(currency.validCode)")
                print("Leave")
            }
                self.delegate?.didGetCurrency(currencies: currencyArray)
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
}
