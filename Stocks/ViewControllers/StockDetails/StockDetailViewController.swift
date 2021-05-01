//
//  ViewController.swift
//  Stocks
//
//  Created by Anthony Odu on 28/04/2021.
//

import UIKit
import RxCocoa
import RxSwift
import Charts

class StockDetailViewController: UIViewController, ChartViewDelegate{
    
    
  
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var collectionView: UICollectionView!
    var stock: SingleStockDataResponse?
    var viewModel = StockDetailsViewModel()
    let disposeBag = DisposeBag()
    let child = SpinnerViewController()
    var data: [[String : String]]?
    var dates: [String] = []
    var value: [Double] = []
    var dataEntries = [ChartDataEntry]()
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = stock?.chart?.result?[0].meta?.symbol
        chartView.delegate = self
        axisFormatDelegate = self
        fetchStockBySymbol()
        setUp()
    }
    
    func setUp(){
       
        chartView.rightAxis.enabled = false
        let yaxix = chartView.leftAxis
        yaxix.labelFont = .boldSystemFont(ofSize: 12)
        yaxix.setLabelCount(5, force: false)
       
        yaxix.labelTextColor = .white
        yaxix.labelPosition = .outsideChart
        yaxix.axisLineColor = .white
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        chartView.xAxis.setLabelCount(5, force: true)
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.axisLineColor = UIColor(red: 0.02, green: 0.02, blue: 0.06, alpha: 1.00)
        getAllData()
        chartView.animate(xAxisDuration: 2.5)
    }

    
    func fetchStockBySymbol() {
        if let stock = stock?.chart?.result?[0].meta{
            viewModel.getSingleStockDetails(symbol: stock)
        }
    }
    
    
    func getAllData(){
        viewModel.error.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] (error) in
            guard let self = self else {return}
            switch error {
            case .internetError(let message):
                self.showAlert(message: message)
            case .serverMessage(_):break
                //self.showAlert(message: message)
            }
        })
        .disposed(by: disposeBag)
        
        viewModel.allStockValue.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] (result) in
            guard let self = self else {return}
            for i in 0..<result.count{
                self.value.append(result[i].close!)
                if let day = result[i].date{
                    self.dates.append(self.changeTime(date: day))
                }
            }
            print(self.dates)
            self.setData(dataPoints: self.dates, values: self.value)
        }).disposed(by: disposeBag)
        
        viewModel.allStockDetails.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] (result) in
           // print(result)
           self?.data = result
           self?.collectionView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    
    func setData(dataPoints: [String], values: [Double]){
        
        for i in 0..<dataPoints.count{
                let dataEntry = ChartDataEntry(x:Double(i), y: values[i],data: dataPoints)
                self.dataEntries.append(dataEntry)
        }
        let set1 = LineChartDataSet(entries: dataEntries, label: "Stocks")
        set1.mode = .cubicBezier
        set1.lineWidth = 3
        set1.setColor(.white)
        set1.fill = Fill(color: .white)
        set1.fillAlpha = 0.8
        set1.drawFilledEnabled = true
        set1.drawHorizontalHighlightIndicatorEnabled = false
        //set1.drawCirclesEnabled = false
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        chartView.data = data
        chartView.xAxis.valueFormatter = axisFormatDelegate
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



extension StockDetailViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = data{
            return  data.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stockDataCell", for: indexPath as IndexPath) as? StockDataCell{
            if let data = data{
                cell.setData(data: data[(indexPath.section * 2) + indexPath.row])
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width/2), height: 44)
    }
    
    func changeTime(date:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let userDate = formatter.date(from: date) {
            formatter.dateFormat = "MM-dd"
            //formatter.dateFormat = "MMM dd,yyyy"
            let formattedDate = formatter.string(from: userDate)
            return formattedDate
        }
        return ""
    }
}

extension StockDetailViewController: IAxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dates[Int(value)]
    }
}


