//
//  CurrenciesViewController.swift
//  TechTask
//
//  Created by Виталий on 05.01.2021.
//

import UIKit

enum Currency: String {
    case usd
    case eur
}

class CurrenciesViewController: UIViewController {
    
    @IBOutlet weak var currencyTableView: UITableView!
    @IBOutlet weak var converterButton: UIButton!
    
    var networkManager: CurrencyNetworkManagerProtocol?
    var currenciesArrayForCurrenciesScreen: [CurrencyDataModel] = []
    var currenciesArray: [CurrencyDataModel] = []
    let requiredCurrencies: [Currency] = [.eur, .usd]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager?.delegate = self
        networkManager?.fetchCurrency()
    }
    
    @IBAction func converterButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Converter", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Converter") as! ConverterViewController
        vc.currenciesArray = currenciesArray
        show(vc, sender: nil)
    }
}

//MARK: - CurrencyNetworkManagerDelegate
extension CurrenciesViewController: CurrencyNetworkManagerDelegate {
   
    func didGetCurrency(currencies: [CurrencyDataModel]) {
        self.currenciesArray = currencies
        let requiredCur = self.requiredCurrencies.map { $0.rawValue.uppercased() }
        let filteredArray = currencies.filter { requiredCur.contains($0.validCode) }
        self.currenciesArrayForCurrenciesScreen.append(contentsOf: filteredArray)
        self.currencyTableView.reloadData()
    }
    
    func didFailWithError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
            self.converterButton.isHighlighted = true
            self.converterButton.isEnabled = false
        }
    }
}

//MARK: - TableViewDataSource and Delegate
extension CurrenciesViewController: UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currenciesArrayForCurrenciesScreen.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.cellIdentifier, for: indexPath) as! CurrencyTableViewCell
        let currency = currenciesArrayForCurrenciesScreen[indexPath.row]
        let formatedTotalNumberString = String(format: "%.2f", currency.rate)
        cell.configureCell(currency.currencyName, formatedTotalNumberString)
        return cell
    }
}
