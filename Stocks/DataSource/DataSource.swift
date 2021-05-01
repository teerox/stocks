//
//  DataSource.swift
//  Stocks
//
//  Created by Anthony Odu on 30/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

//
class DataSource{
    static let shared = DataSource()
    
    let loading: PublishSubject<Bool> = PublishSubject()
    let error : PublishSubject<CustomError> = PublishSubject()
    let success: PublishSubject<Bool> = PublishSubject()
    
    let allStock: PublishSubject<[AllStock]> = PublishSubject()
    let singleStock: PublishSubject<SingleStockDataResponse> = PublishSubject()
    let singleStockValue: PublishSubject<[Value]> = PublishSubject()
    
    var arrayOfSingleResponse = [SingleStockDataResponse]()

    func getAllStockName(){
        arrayOfSingleResponse.removeAll()
        self.loading.onNext(true)
        var newValue = [AllStock]()
        APIManager.requestData(url: "/stocks?exchange=NASDAQ&format=json&type=EQUITY", method: .get, parameters: nil){result in self.loading.onNext(false)
            switch result{
            case .success(let jsonData):
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(AllStockResponse.self, from: jsonData)
                    
                    var count = 0
                    newValue.removeAll()
                    result.data.forEach { (res) in
                        if count > 500{
                            return
                        }else{
                            
                            newValue.append(res)
                        }
                        count += 1
                    }
                    self.allStock.onNext(newValue)
                    self.success.onNext(true)
                   
                } catch {
                    print(error)
                    self.error.onNext(.serverMessage("Error Fetching Stocks"))
                }
                
            case .failure(let failure):
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError("Check your Internet connection."))
                case .authorizationError(let errorJson):
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage("Unknown Error"))
                }
            }
        }
    }
    
    func getSingleStockData(stockSymbol:String,name:String){
      
        self.loading.onNext(true)
        APIManager.requestDatawithBaseUrl2(url: "/v7/finance/chart/\(stockSymbol)?interval=1d", method: .get, parameters: nil){result in self.loading.onNext(false)
            switch result{
            case .success(let jsonData):
                let decoder = JSONDecoder()
                do {
                    var result = try decoder.decode(SingleStockDataResponse.self, from: jsonData)
                    self.arrayOfSingleResponse.append(result)
                    result.name = name
                    self.singleStock.onNext(result)
                    self.success.onNext(true)
                } catch {
                    print(error)
                    self.error.onNext(.serverMessage("Error Fetching Single Stocks"))
                }
                
            case .failure(let failure):
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError("Check your Internet connection."))
                case .authorizationError(let errorJson):
                    
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage("Unknown Error"))
                }
            }
        }
    }
    
    func getSingleStockValue(stockSymbol:String){
        self.loading.onNext(true)
       APIManager.requestDatawithBaseUrl3(url: "/time_series?symbol=\(stockSymbol)&interval=1day&outputsize=5&format=json", method: .get, parameters: nil){result in self.loading.onNext(false)
            switch result{
            case .success(let jsonData):
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(SingleStockValueResponse.self, from: jsonData)
                   
                    if let res = result.values{
                        self.singleStockValue.onNext(res)
                        self.success.onNext(true)
                    }else{
                        self.error.onNext(.serverMessage("Stock Details Not Available"))
                    }
                } catch {
                    print(error)
                    self.error.onNext(.serverMessage("Error Fetching Stocks"))
                }
                
            case .failure(let failure):
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError("Check your Internet connection."))
                case .authorizationError(let errorJson):
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage("Unknown Error"))
                }
            }
        }
    }
}
