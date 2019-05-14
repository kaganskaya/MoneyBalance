//
//  ChartViewController.swift
//  MoneyBalance
//
//  Created by liza_kaganskaya on 5/13/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import UIKit
import SwiftChart

class ChartViewController: UIViewController{

    @IBOutlet weak var graphicView: UIView!
    @IBOutlet weak var categoriesView: UIView!
    @IBOutlet weak var totalL: UILabel!
    
    var money:[(String,Double)] = []
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        setupView()
        money = lp.getTotalPerDay()
        createChart()
    }
    
    
    func createChart(){
        let height = self.graphicView.bounds.height*0.7
        
        let chart = Chart(frame: CGRect(x: 0, y: self.graphicView.bounds.maxY-height, width: self.graphicView.bounds.width, height:height))
        
        var data: [(Int,Double)] = []
        
        money.map({ i  in
            
            let dt = Int(i.0.prefix(2))!

            data.append((dt,i.1))
        })
        print(data)
        
        let series = ChartSeries(data: data)
        series.area = true
        
        chart.add(series)
        self.graphicView.addSubview(chart)
    }
    
    func setupView(){
        
        self.categoriesView.layer.cornerRadius = 20
        self.categoriesView.layer.shadowRadius  = 10
        self.categoriesView.layer.shadowColor = UIColor.black.cgColor
        self.categoriesView.layer.shadowOffset = .zero
        self.categoriesView.layer.shadowOpacity = 0.3
        print(lp.getTotalPerMonth().description)
        totalL.text = "$\(lp.getTotalPerMonth().description)"
        
    }
}

extension ChartViewController:ChartDelegate{
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        for (seriesIndex, dataIndex) in indexes.enumerated() {
            if dataIndex != nil {
                // The series at `seriesIndex` is that which has been touched
                let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex)
            }
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        return
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        return
    }
    
        
        
    }



