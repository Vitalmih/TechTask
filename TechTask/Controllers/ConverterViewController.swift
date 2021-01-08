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
    var currenciesArray: [CurrencyDataModel] = []
    private var leftComponentRate: Double = 0.0
    private var rightComponentRate: Double = 0.0
    
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
        let name = currenciesArray[row]
        switch component {
        case 0:
            if pickerView.selectedRow(inComponent: 0) == pickerView.selectedRow(inComponent: 1) {
                if currenciesArray[row].validCode == currenciesArray[row].validCode && row == 0 {
                    pickerView.selectRow(row + 1, inComponent: 0, animated: true)
                } else {
                    pickerView.selectRow(row - 1, inComponent: 0, animated: true)
                }
            } else {
                self.currencyType.text = name.validCode
                calculateCurrencyRate()
            }
        case 1:
            if pickerView.selectedRow(inComponent: 0) == pickerView.selectedRow(inComponent: 1) {
                if currenciesArray[row].validCode == currenciesArray[row].validCode && row == 0 {
                    pickerView.selectRow(row + 1, inComponent: 1, animated: true)
                } else {
                    pickerView.selectRow(row - 1, inComponent: 1, animated: true)
                }
            } else {
                self.convertedCurrencyType.text = name.validCode
                calculateCurrencyRate()
            }
        default:
            break
        }
    }
    
    func calculateCurrencyRate() {
        if multiplicityCurrencyTF.text != "" && currencyType.text != convertedCurrencyType.text {
            guard let numberString = multiplicityCurrencyTF.text else { return }
            let convertNumberStringToDouble = Double(numberString) ?? 0.0
            let buffer = convertNumberStringToDouble * self.leftComponentRate
            let totalNumber = buffer / rightComponentRate
            var formatedTotalNumberString: String {
                return String(format: "%.2f", totalNumber)
            }
            resultCurrencyTF.text = formatedTotalNumberString
        }
    }
}

//MARK: - UITextFieldDelegate
extension ConverterViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        calculateCurrencyRate()
    }
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        resultCurrencyTF.text = textField.text
    //        return true
    //    }
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
