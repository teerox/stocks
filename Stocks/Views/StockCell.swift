//
//  StockCell.swift
//  Stocks
//
//  Created by Anthony Odu on 30/04/2021.
//

import UIKit

class StockCell: UITableViewCell {
    
    @IBOutlet weak var symbol: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var percentageChange: UILabel!
    
    public var stocks: SingleStockDataResponse! {
        didSet {
            self.symbol.text = stocks.chart?.result?[0].meta?.symbol
            if stocks.name!.isEmpty{
                self.name.text = "No Name Found"
            }else{
                self.name.text = stocks.name
            }
            
            if let chart = stocks.chart?.result?[0].meta{
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                if let closingPrice = chart.regularMarketPrice{
                    if let price = Double(String(format: "%.2f", closingPrice)){
                        let fineAmount = numberFormatter.string(from:  NSNumber(value:price))
                        if let currency = chart.currency{
                            self.price.text = fineAmount! + currency
                        }
                    }
                }
                    
                guard let chartPreviousClose = chart.chartPreviousClose else {return}
                guard let close = chart.regularMarketPrice else {return}
                
               let percentageChange = ((close - chartPreviousClose) / chartPreviousClose) * 100

                self.percentageChange.text = "\(String(format: "%.2f",percentageChange))%"
            }
           
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
