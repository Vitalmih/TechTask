//
//  CurrenciesViewController.swift
//  TechTask
//
//  Created by Виталий on 05.01.2021.
//

import UIKit

class CurrenciesViewController: UIViewController {
    
    var networkManager = CurrencyNetworkManager()
    var currenciesArrayForCurrencies: [CurrencyDataModel] = []
    var currenciesArray: [CurrencyDataModel] = []
    @IBOutlet weak var currencyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
        getData()
    }
    
    @IBAction func converterButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Converter", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Converter") as! ConverterViewController
        vc.currenciesArray = currenciesArray
        show(vc, sender: nil)
    }
    
    func getData() {
        self.networkManager.fetchCurrency(currency: ConstansValue.allCurrenciesJSON)
    }
}

//MARK: - CurrencyNetworkManagerDelegate
extension CurrenciesViewController: CurrencyNetworkManagerDelegate {
    func didGetCurrency(currencies: [CurrencyDataModel]) {
    
        DispatchQueue.main.async {
            self.currenciesArray = currencies
            for i in ConstansValue.typeOfCurrency {
                for currencyType in currencies {
                    if currencyType.validCode == i {
                        self.currenciesArrayForCurrencies.append(currencyType)
                    }
                }
            }
            self.currencyTableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - TableViewDataSource and Delegate
extension CurrenciesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        currenciesArrayForCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConstansValue.cellIdentifier, for: indexPath) as! CurrencyTableViewCell
        let currency = currenciesArrayForCurrencies[indexPath.row]
        cell.currencyType.text = currency.currencyName
        cell.currencyValue.text = String(currency.rate)
        return cell
    }
}

