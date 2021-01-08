//
//  CurrenciesViewController.swift
//  TechTask
//
//  Created by Виталий on 05.01.2021.
//

import UIKit

class CurrenciesViewController: UIViewController {
    
    @IBOutlet weak var currencyTableView: UITableView!
    var networkManager = CurrencyNetworkManager()
    var currenciesArrayForCurrenciesScreen: [CurrencyDataModel] = []
    var currenciesArray: [CurrencyDataModel] = []
    
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
                        self.currenciesArrayForCurrenciesScreen.append(currencyType)
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
        currenciesArrayForCurrenciesScreen.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConstansValue.cellIdentifier, for: indexPath) as! CurrencyTableViewCell
        let currency = currenciesArrayForCurrenciesScreen[indexPath.row]
        var formatedTotalNumberString: String {
            return String(format: "%.2f", currency.rate)
        }
        cell.configureCell(currency.currencyName, formatedTotalNumberString)
        return cell
    }
}
