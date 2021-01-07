//
//  ConverterViewController.swift
//  TechTask
//
//  Created by Виталий on 05.01.2021.
//

import UIKit

class ConverterViewController: UIViewController {
    
    @IBOutlet weak var currencyType: UILabel!
    @IBOutlet weak var convertedCurrencyType: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var multiplicityCurrencyTF: UITextField!
    @IBOutlet weak var resultCurrencyTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
