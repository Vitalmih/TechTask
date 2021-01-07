//
//  ConverterViewController.swift
//  TechTask
//
//  Created by Виталий on 05.01.2021.
//

import UIKit

class ConverterViewController: UIViewController {
    var networkManager = CurrencyNetworkManager()
    var currenciesArray: [CurrencyDataModel] = []
    @IBOutlet weak var currencyType: UILabel!
    @IBOutlet weak var convertedCurrencyType: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var multiplicityCurrencyTF: UITextField!
    @IBOutlet weak var resultCurrencyTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
}

//MARK: - UIPickerViewDataSource
extension ConverterViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currenciesArray.count
    }
}

//MARK: - UIPickerViewDelegate
extension ConverterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let code = currenciesArray[row]
        return code.validCode
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let name = currenciesArray[row]
        
        switch component {
        case 0:
            if pickerView.selectedRow(inComponent: 0) == pickerView.selectedRow(inComponent: 1) {
                pickerView.selectRow(0, inComponent: 0, animated: true)
            }
            self.currencyType.text = name.validCode
            
        case 1:
            if pickerView.selectedRow(inComponent: 1) == pickerView.selectedRow(inComponent: 0) {
                pickerView.selectRow(0, inComponent: 1, animated: true)
            }
            self.convertedCurrencyType.text = name.validCode
        default:
            break
        }
    }
}

//MARK: - UITextFieldDelegate
extension ConverterViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let numberString = multiplicityCurrencyTF.text else { return }
        let myNumber = Int(numberString) ?? 0
        
//        resultCurrencyTF.text = multiplicityCount
    }
}

//MARK: - Hide keyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
