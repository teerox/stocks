//
//  HomeViewController.swift
//  Stocks
//
//  Created by Anthony Odu on 30/04/2021.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    let child = SpinnerViewController()
    
    let allStockValue: PublishSubject<[SingleStockDataResponse]> = PublishSubject()
    var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Stocks"
        viewModel.loadStocks()
        configure()
        setupBinding()
    }
    
    func configure(){
        showSpinnerView(child: child)
        viewModel.allStockValue.observe(on: MainScheduler.instance).bind(to: allStockValue).disposed(by: disposeBag)
        
        viewModel.loading.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] (loading) in
            guard let this = self else {return}
            if loading{
                this.showSpinnerView(child: this.child)
            }else{
                this.removeSpinnerView(child: this.child)
            }
        })
        .disposed(by: disposeBag)
        
        viewModel.error.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] (error) in
            guard let self = self else {return}
            switch error {
            case .internetError(let message):
                self.showAlert(message: message)
            case .serverMessage(_):break
                //self.showAlert(message: message)
            }
        },onCompleted: {
            self.removeSpinnerView(child: self.child)
        }
        )
        .disposed(by: disposeBag)
        
        
        
    }
    
    private func setupBinding(){
//        tableView.register(UINib(nibName: "StockCell", bundle: nil), forCellReuseIdentifier: String(describing: StockCell.self))
        tableView.register(UINib(nibName: "StockCell", bundle: Bundle.main), forCellReuseIdentifier: "stockCell")
        allStockValue.bind(to: tableView.rx.items(cellIdentifier: "stockCell",cellType: StockCell.self)){
            (row,stocks,cell) in
            cell.stocks = stocks
        }.disposed(by: disposeBag)
        
        
//        tableView.rx.willDisplayCell
//            .subscribe(onNext: ({ (cell,indexPath) in
//                cell.alpha = 0
//                let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -250, 0)
//                cell.layer.transform = transform
//                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//                    cell.alpha = 1
//                    cell.layer.transform = CATransform3DIdentity
//                }, completion: nil)
//            })).disposed(by: disposeBag)
        
        
        tableView.rx.itemSelected.subscribe(onNext: ({
            [weak self] indexPath in
            guard let this = self else{return}
            let cell = self?.tableView.cellForRow(at: indexPath) as? StockCell
            let data = cell?.stocks
            if let stocDetail = data{
                this.moveToStockDetails(singleStock: stocDetail)
            }
        })).disposed(by: disposeBag)
    }
    
    func moveToStockDetails(singleStock: SingleStockDataResponse){
        let nextVc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StockDetailViewController") as? StockDetailViewController
        if let viewController = nextVc{
            viewController.stock = singleStock
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
}
