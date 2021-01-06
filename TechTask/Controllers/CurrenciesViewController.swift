//
//  CurrenciesViewController.swift
//  TechTask
//
//  Created by Виталий on 05.01.2021.
//

import UIKit

class CurrenciesViewController: UIViewController, CurrencyNetworkManagerProtocol, CurrencyNetworkManagerDelegate {
    
    var dataTask: URLSessionDataTask?
    var networkManager = CurrencyNetworkManager()
    var currenciesArray: [CurrencyDataModel] = []
    @IBOutlet weak var currencyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
        getData()
    }
    
    @IBAction func converterButtonPressed(_ sender: UIButton) {
    }
    
    func fetchCurrency(currency: String) {
        
    }
    
    func getData() {
        for currencyType in currenciesArray {
            fetchCurrency(currency: currencyType.validCode)
        }
    }
    
    func didGetCurrency(currencies: [CurrencyDataModel]) {
        DispatchQueue.main.async {
            self.currenciesArray = currencies
            self.currencyTableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
