//
//  ViewController.swift
//  MoneyBalance
//
//  Created by liza_kaganskaya on 4/24/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {

    @IBOutlet weak var viewUo: UIView!
    @IBOutlet weak var spendings: UITableView!
    @IBOutlet weak var addB: UIButton!
    @IBOutlet weak var input: UITextField!
    let date = Date()
    var money : [Spendings] = []
    var dateC:String = ""
    var dateFormatter = DateFormatter()
    var dateString:String = " "
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateString = dateFormatter.string(from: date as Date)
        
        spendings.layer.cornerRadius = 20
        viewUo.layer.cornerRadius = 20
        addB.layer.cornerRadius = 10
        
        input.layer.cornerRadius = 10
        var frameRect = input.frame
        frameRect.size.height = 50
        var frameRect1 = addB.frame
        frameRect1.size.height = 45
        frameRect1.size.width = 45

        addB.frame = frameRect1

        input.frame = frameRect
        input.layer.borderColor = UIColor.white.cgColor
        input.layer.borderWidth  = 2
      
        self.money = lp.getData()
        
        self.spendings.reloadData()

        self.spendings.delegate = self
        self.spendings.dataSource = self
    }
    let lp = LocalProvider()
    @IBAction func adding(_ sender: Any) {
        
        lp.saveToBd(date:self.dateString,amount: input.text!)
        self.money = lp.getData()
        self.input.text?.removeAll()
       self.spendings.reloadData()
    }
    
}
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return money.count+1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {

            lp.deleteData(index: money[indexPath.row])

            money.remove(at: indexPath.row)

            tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "spendingCell", for: indexPath) as! spendingsCell
        let index = indexPath.row
        if(index == 0){
            var frameRect =  cell.dateL.frame
            frameRect.size.width = cell.frame.width/2
            cell.dateL.frame = frameRect
            cell.dateL.font = cell.dateL.font.withSize(35)
            cell.dateL.text = date.monthAsString()
            
            cell.moneyL.text = lp.getTotalPerMonth().description
        }else{
        cell.dateL.text = money[index-1].date
        cell.moneyL.text = money[index-1].amount!
        }
        return cell
    }
    
    
    
}

