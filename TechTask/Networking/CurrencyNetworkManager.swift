//
//  CurrencyNetworkManager.swift
//  TechTask
//
//  Created by Виталий on 05.01.2021.
//

import Foundation

struct CurrencyNetworkManager {
    
    func fetchCurrency(currency: String) {
        
            let urlString = ("\(K.currencyByValidCode)\(currency)")
            performRequest(urlString: urlString)
            print(urlString)
        
    }
    
    func performRequest(urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, respone, error) in
                
                if error != nil {
                    print(error!)
                }
                if let safeData = data {
                    self.parseJSON(data: safeData)
                }
            }
            task.resume() 
        }
    }
    
    func parseJSON(data: Data) {
        let decoder = JSONDecoder()
        
        do {
           let decodedData = try decoder.decode([CurrencyDataModel].self, from: data)
            print(decodedData)
        } catch {
            print(error)
        }
        
    }
}
