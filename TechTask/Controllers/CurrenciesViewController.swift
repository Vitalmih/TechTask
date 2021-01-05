//
//  CurrenciesViewController.swift
//  TechTask
//
//  Created by Виталий on 05.01.2021.
//

import UIKit

class CurrenciesViewController: UIViewController {
    
    @IBOutlet weak var currencyTableView: UITableView!
    
let networkManager = CurrencyNetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
    }
    
    @IBAction func converterButtonPressed(_ sender: UIButton) {
    }
    
   

    func getData() {
        for i in K.typeOfCurrency {
            networkManager.fetchCurrency(currency: i)
        }
        
    }
}
