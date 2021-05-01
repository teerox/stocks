//
//  StockDetails.swift
//  Stocks
//
//  Created by Anthony Odu on 30/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

class StockDetailsViewModel {
    let loading: PublishSubject<Bool> = PublishSubject()
    let error : PublishSubject<CustomError> = PublishSubject()
    let allStockValue: PublishSubject<[ChartPoint]> = PublishSubject()
    let allStockDetails: PublishSubject<[[String : String]]> = PublishSubject()
    
    let dataSource = DataSource.shared
    let disposeBag = DisposeBag()
    
    var chartPoints = [ChartPoint]()
    
    func getSingleStockDetails(symbol:SingleStockData){
        if let stockSymbol = symbol.symbol{
            dataSource.getSingleStockValue(stockSymbol: stockSymbol)
        }

        dataSource.loading.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] (loading) in
            self?.loading.onNext(loading)
        })
        .disposed(by: disposeBag)
        
        dataSource.error.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] (error) in
            guard let self = self else {return}
            self.error.onNext(error)
        })
        .disposed(by: disposeBag)
        
        dataSource.singleStockValue.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] (result) in
            if let self = self {
               
                result.forEach { (result) in
                    if let closing = result.close{
                        guard let close = NumberFormatter().number(from: closing) as? Double else { return }
                        self.chartPoints.append(ChartPoint(date: result.datetime, close: close))
                    }
                }
                self.allStockValue.onNext(self.chartPoints)
                self.allStockDetails.onNext(self.getStockDetails(symbol: symbol))
            }
        }).disposed(by: disposeBag)
    }
    
    
    func getStockDetails(symbol:SingleStockData) -> [[String : String]]{
        var dataFields = [[String : String]]()
        
        if let marketPrice = symbol.regularMarketPrice{
            
            dataFields.append(["Opening":String(marketPrice)])
          
        }
        
        if let close = symbol.chartPreviousClose{
            dataFields.append(["Closing":String(close)])
           
        }
        
        if let symbol = symbol.symbol{
            dataFields.append(["Symbol":symbol])

        }
        
        if let type = symbol.instrumentType{
            dataFields.append(["Instrument":type])
        }
        
        if let currency = symbol.currency{
            dataFields.append(["Currency":currency])
        }else{
            dataFields.append(["Currency":"USD"])
        }
        
        
        
        
   

        return dataFields
    }
}
