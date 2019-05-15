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

    @IBOutlet weak var labellLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelChart: UILabel!
    @IBOutlet weak var graphicView: UIView!
    @IBOutlet weak var categoriesView: UIView!
    @IBOutlet weak var totalL: UILabel!
    
    var labelLeadingMarginInitialConstant: CGFloat!

    var money:[(String,Double)] = []
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        labelLeadingMarginInitialConstant = labellLeadingConstraint.constant
        setupView()
        money = lp.getTotalPerDay()
        createChart()
    }
    
    
    func createChart(){
        
        let height = self.graphicView.bounds.height*0.7
        
        let chart = Chart(frame: CGRect(x: 0, y: self.graphicView.bounds.maxY-height, width: self.graphicView.bounds.width-5, height:height))
        
        chart.delegate = self
        
        var data: [(Int,Double)] = []

        money.map({ i  in

            let dt = Int(i.0.prefix(2))!

            data.append((dt,i.1))
        })
        print(data)
        //data = [(01,123),(02,675),(03,23),(12,234),(14,776),(18,452),(24,123),(26,1123),(29,987),(31,237)]
        let series = ChartSeries(data: data)
        series.area = true
        
        //chart.xLabelsTextAlignment = .center
        chart.lineWidth = 0.5
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

                if let value = chart.valueForSeries(0, atIndex: indexes[0]) {
                    let numberFormatter = NumberFormatter()
                    numberFormatter.minimumFractionDigits = 2
                    numberFormatter.maximumFractionDigits = 2
                    labelChart.text = numberFormatter.string(from: NSNumber(value: value))
                    
                    // Align the label to the touch left position, centered
                    var constant = labelLeadingMarginInitialConstant + left - (labelChart.frame.width / 2)
                    
                    // Avoid placing the label on the left of the chart
                    if constant < labelLeadingMarginInitialConstant {
                        constant = labelLeadingMarginInitialConstant
                    }
                    
                    // Avoid placing the label on the right of the chart
                    let rightMargin = chart.frame.width - labelChart.frame.width
                    if constant > rightMargin {
                        constant = rightMargin
                    }
                    
                    labellLeadingConstraint.constant = constant
                }
        
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        labelChart.text = ""
        labellLeadingConstraint.constant = labelLeadingMarginInitialConstant
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        return
    }
    
        
        
    }



