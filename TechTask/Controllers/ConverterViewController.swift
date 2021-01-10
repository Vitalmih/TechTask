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
    @IBOutlet weak var upperCurrencyTF: UITextField!
    @IBOutlet weak var lowerCurrencyTF: UITextField!
    
    var currenciesArray: [CurrencyDataModel] = []
    
    private var leftComponentRate: Double = 0.0
    private var rightComponentRate: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currencyPicker.selectRow(1, inComponent: 1, animated: true)
        self.currencyPicker.delegate?.pickerView?(self.currencyPicker, didSelectRow: 1, inComponent: 1)
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
        let CurrencyCode = currenciesArray[row]
        switch component {
        case 0:
            self.leftComponentRate = CurrencyCode.rate
        case 1:
            self.rightComponentRate = CurrencyCode.rate
        default:
            break
        }
        return CurrencyCode.validCode
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedInputField = component == 0 ? currencyType : convertedCurrencyType
        let requiredTextField: UITextField = component == 0 ? upperCurrencyTF : lowerCurrencyTF
        
        if pickerView.selectedRow(inComponent: 0) == pickerView.selectedRow(inComponent: 1) {
            if currenciesArray[row].validCode == currenciesArray[row].validCode && row == 0 {
                pickerView.selectRow(row + 1, inComponent: component, animated: true)
            } else {
                pickerView.selectRow(row - 1, inComponent: component, animated: true)
            }
            return
        }
        selectedInputField?.text = currenciesArray[row].validCode
        calculateCurrencyRate(textField: requiredTextField)
    }
    
    func calculateCurrencyRate(textField: UITextField) {
        if textField == upperCurrencyTF {
            if upperCurrencyTF.text != "" && currencyType.text != convertedCurrencyType.text {
                guard let numberString = upperCurrencyTF.text else { return }
                let convertNumberStringToDouble = Double(numberString) ?? 0.0
                let buffer = convertNumberStringToDouble * self.leftComponentRate
                let totalNumber = buffer / rightComponentRate
                let formatedTotalNumberString = String(format: "%.2f", totalNumber)
                lowerCurrencyTF.text = formatedTotalNumberString
            }
        } else if textField == lowerCurrencyTF {
            if lowerCurrencyTF.text != "" && currencyType.text != convertedCurrencyType.text {
                guard let numberString = lowerCurrencyTF.text else { return }
                let convertNumberStringToDouble = Double(numberString) ?? 0.0
                let buffer = convertNumberStringToDouble * self.rightComponentRate
                let totalNumber = buffer / leftComponentRate
                let formatedTotalNumberString = String(format: "%.2f", totalNumber)
                upperCurrencyTF.text = formatedTotalNumberString
            }
        }
    }
}

//MARK: - UITextFieldDelegate
extension ConverterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let count = textField.text?.count {
            if count >= 10 {
                return false
            }
        }
        calculateCurrencyRate(textField: textField)
        return true
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
