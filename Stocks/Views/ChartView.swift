//
//  ChartView.swift
//  Stocks
//
//  Created by Anthony Odu on 30/04/2021.
//

import Foundation
import UIKit

class ChartView: UIView {
    
    @IBOutlet weak var btnIndicatorView: UIView!

    
    class func create() -> ChartView {
        let chartView = UINib(nibName: "ChartView", bundle:nil).instantiate(withOwner: nil, options: nil)[0] as! ChartView
        chartView.btnIndicatorView.layer.cornerRadius = 15
        
        return chartView
    }

}
