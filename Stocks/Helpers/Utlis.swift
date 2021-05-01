//
//  Utlis.swift
//  Stocks
//
//  Created by Anthony Odu on 30/04/2021.
//

import Foundation

class Utlis{
    
    static func stringToDate(isoDate:String)->Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from:isoDate)
    }
}
