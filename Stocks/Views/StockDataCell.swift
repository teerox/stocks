//
//  StockDataCell.swift
//  Stocks
//
//  Created by Anthony Odu on 30/04/2021.
//

import UIKit

class StockDataCell: UICollectionViewCell {
    @IBOutlet weak var fieldNameLbl: UILabel!
    @IBOutlet weak var fieldValueLbl: UILabel!
    
    func setData(data: [String : String]) {
        fieldNameLbl.text = data.keys.first
        fieldValueLbl.text = data.values.first

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
