//
//  HomeViewModel.swift
//  Stocks
//
//  Created by Anthony Odu on 30/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel{
    
    let loading: PublishSubject<Bool> = PublishSubject()
    let error : PublishSubject<CustomError> = PublishSubject()
    let success: PublishSubject<Bool> = PublishSubject()
    let allStockValue: PublishSubject<[SingleStockDataResponse]> = PublishSubject()
    
    let dataSource = DataSource.shared
    let disposeBag = DisposeBag()
    
    var valueArray = [AllSingleStockData]()
    var arr1 = [SingleStockDataResponse]()
    
    func loadStocks(){
        self.valueArray.removeAll()
        dataSource.getAllStockName()
        dataSource.loading.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] (loading) in
            self?.loading.onNext(loading)
        })
        .disposed(by: disposeBag)
        
        dataSource.error.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] (error) in
            guard let self = self else {return}
            self.error.onNext(error)
        })
        .disposed(by: disposeBag)
        arr1.removeAll()
        dataSource.allStock.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] (result) in
            result.forEach { (stocks) in
              
               self?.dataSource.getSingleStockData(stockSymbol: stocks.symbol, name: stocks.name)
                
            }
            self?.dataSource.singleStock.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] (result) in
                if let self = self{
                    self.arr1.append(result)
                    self.allStockValue.onNext(self.arr1)
                }

            }).disposed(by: self!.disposeBag)
          
        }).disposed(by: disposeBag)
        
 
        
    }
    
    
    
    func getAllStocks(symbol:AllStock,name:String){
        dataSource.getSingleStockData(stockSymbol: symbol.symbol, name: name)

        dataSource.loading.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] (loading) in
            self?.loading.onNext(loading)

        })
        .disposed(by: disposeBag)

        dataSource.error.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] (error) in
            guard let self = self else {return}
            self.error.onNext(error)
        })
        .disposed(by: disposeBag)

        dataSource.singleStock.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] (result) in
            if let self = self{
                self.arr1.append(result)
                self.allStockValue.onNext(self.arr1)
            }
            
        }).disposed(by: self.disposeBag)
    }
    
    func removeDuplicates(_ nums: inout [AllSingleStockData]) -> [AllSingleStockData] {
        var index = 0
        while index < nums.count {
            if index > 0 && nums[index].symbol == nums[index - 1].symbol {
                nums.remove(at: index)
            } else{
                index += 1
            }
        }
        return nums
    }
}

extension Array {
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}
