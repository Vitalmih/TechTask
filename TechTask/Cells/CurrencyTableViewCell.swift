//
//  CurrencyTableViewCell.swift
//  TechTask
//
//  Created by Виталий on 05.01.2021.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currencyType: UILabel!
    @IBOutlet weak var currencyValue: UILabel!
    static let cellIdentifier = "CurrencyTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currencyType.text = nil
        currencyValue.text = nil
    }
    
    func configureCell(_ currencyType: String, _ currencyValue: String) {
        self.currencyType.text = currencyType
        self.currencyValue.text = currencyValue
    }
}
