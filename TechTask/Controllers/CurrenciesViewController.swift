//
//  CurrenciesViewController.swift
//  TechTask
//
//  Created by Виталий on 05.01.2021.
//

import UIKit

class CurrenciesViewController: UIViewController {
    
    
    var networkManager = CurrencyNetworkManager()
    var currenciesArray: [CurrencyDataModel] = []
    @IBOutlet weak var currencyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
        getData()
        networkManager.dispatchGroup.notify(queue: .main) {
            print("done")
        }
    }
    
    @IBAction func converterButtonPressed(_ sender: UIButton) {
    }
    
    func getData() {
        for type in ConstansValue.typeOfCurrency {
            self.networkManager.fetchCurrency(currency: type)
        }
    }
}

//MARK: - CurrencyNetworkManagerDelegate
extension CurrenciesViewController: CurrencyNetworkManagerDelegate {
    func didGetCurrency(currencies: [CurrencyDataModel]) {
        print("PROTOCOL ===== \(currencies)")
        DispatchQueue.main.async {
            self.currenciesArray = currencies
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
        currenciesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConstansValue.cellIdentifier, for: indexPath) as! CurrencyTableViewCell
        let currency = currenciesArray[indexPath.row]
        cell.currencyType.text = currency.currencyName
        cell.currencyValue.text = String(currency.rate)
        
        return cell
    }
}

