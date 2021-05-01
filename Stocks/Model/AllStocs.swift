//
//  AllStocs.swift
//  Stocks
//
//  Created by Anthony Odu on 30/04/2021.
//

import Foundation
import UIKit

struct ChartPoint {
    var date: String?
    var close: Double?
}

//struct AllStock: Codable {
//    let symbol, name, date: String
//    let isEnabled: Bool?
//    let type: String?
//
//    enum CodingKeys: String, CodingKey {
//        case symbol, name, date, isEnabled, type
//    }
//}

struct AllStockResponse: Codable {
    let data: [AllStock]
}

// MARK: - Datum
struct AllStock: Codable {
    let symbol, name, currency, exchange: String
    let country, type: String
}


//typealias AllStockResponse = [AllStock]



struct SingleStockDataResponse: Codable {
    let chart: Chart?
    var name:String?
}

// MARK: - Chart
struct Chart: Codable {
    let result: [Result]?
}

// MARK: - Result
struct Result: Codable {
    let meta: SingleStockData?
}

struct AllSingleStockData: Codable {
    let currency, symbol, name: String?
    let regularMarketPrice, chartPreviousClose: Double?
}
struct SingleStockData: Codable {
    let currency: String?
    let symbol, exchangeName, instrumentType: String?
    let firstTradeDate, regularMarketTime, gmtoffset: Int?
    let timezone, exchangeTimezoneName: String?
    let regularMarketPrice, chartPreviousClose: Double?
    let priceHint: Int?
}


struct SingleStock: Codable {
    let symbol, name, exchange, currency: String
    let datetime, welcomeOpen, high, low: String
    let close, volume, previousClose, change: String
    let percentChange, averageVolume: String
    let fiftyTwoWeek: FiftyTwoWeek

    enum CodingKeys: String, CodingKey {
        case symbol, name, exchange, currency, datetime
        case welcomeOpen = "open"
        case high, low, close, volume
        case previousClose = "previous_close"
        case change
        case percentChange = "percent_change"
        case averageVolume = "average_volume"
        case fiftyTwoWeek = "fifty_two_week"
    }
}

// MARK: - FiftyTwoWeek
struct FiftyTwoWeek: Codable {
    let low, high, lowChange, highChange: String
    let lowChangePercent, highChangePercent, range: String

    enum CodingKeys: String, CodingKey {
        case low, high
        case lowChange = "low_change"
        case highChange = "high_change"
        case lowChangePercent = "low_change_percent"
        case highChangePercent = "high_change_percent"
        case range
    }
}


struct SingleStockValueResponse: Codable {
    let meta: Meta?
    let values: [Value]?
    let status: String?
}

// MARK: - Meta
struct Meta: Codable {
    let symbol, interval, currency, exchangeTimezone: String?
    let exchange, type: String?

    enum CodingKeys: String, CodingKey {
        case symbol, interval, currency
        case exchangeTimezone = "exchange_timezone"
        case exchange, type
    }
}

// MARK: - Value
struct Value: Codable {
    let datetime, valueOpen, high, low: String?
    let close, volume: String?

    enum CodingKeys: String, CodingKey {
        case datetime
        case valueOpen = "open"
        case high, low, close, volume
    }
}



struct MetaData: Codable {
    let the1Information, the2Symbol, the3LastRefreshed, the4OutputSize: String
    let the5TimeZone: String

    enum CodingKeys: String, CodingKey {
        case the1Information = "1. Information"
        case the2Symbol = "2. Symbol"
        case the3LastRefreshed = "3. Last Refreshed"
        case the4OutputSize = "4. Output Size"
        case the5TimeZone = "5. Time Zone"
    }
}

// MARK: - TimeSeriesDaily
struct TimeSeriesDaily: Codable {
    let the1Open, the2High, the3Low, the4Close: String
    let the5Volume: String

    enum CodingKeys: String, CodingKey {
        case the1Open = "1. open"
        case the2High = "2. high"
        case the3Low = "3. low"
        case the4Close = "4. close"
        case the5Volume = "5. volume"
    }
}
