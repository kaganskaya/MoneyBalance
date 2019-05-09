//
//  ViewController.swift
//  MoneyBalance
//
//  Created by liza_kaganskaya on 4/24/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import UIKit
import CoreData
import SwiftValidators
import iOSDropDown

class ViewController: UIViewController {

    @IBOutlet weak var dropDown: DropDown!
    @IBOutlet weak var viewUo: UIView!
    @IBOutlet weak var spendings: UITableView!
    @IBOutlet weak var addB: UIButton!
    @IBOutlet weak var input: UITextField!

    let date = Date()
    var money : [Spendings] = []
    var dateC:String = ""
    var dateFormatter = DateFormatter()
    var dateString:String = " "
    var category:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dropDown.optionArray = ["Food","Clothes","Fun","Kids","Other"]
        dropDown.didSelect{(selectedText , index ,id) in
            self.category = selectedText
            print(self.category)
        }
        
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
        
        let check = Validator.isInt().apply(input.text) || Validator.isFloat().apply(input.text)
        if check{
            lp.saveToBd(date:self.dateString,amount: input.text!, category: self.category )
        self.money = lp.getData()
        self.input.text?.removeAll()
            self.spendings.reloadData()}
        else{
            self.input.text?.removeAll()

        }
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indePpath) in
            self.deleteAction(indexPath: indePpath)
        }
        
        let updateAction  = UITableViewRowAction(style: .default, title: "Update") { (action, indPath) in
            self.updateAction(indexPath:indPath)
        }
        updateAction.backgroundColor = .blue
        return [deleteAction,updateAction]
    }
    func updateAction(indexPath: IndexPath){
        
        let alert = UIAlertController(title: "Update", message: "Update summa", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style:.default) { action in
            
        guard let textField = alert.textFields?.first  else {
            return

        }
            
            if let textToEdit = textField.text{
                if textToEdit.count == 0 {
                    return
                }
                
                self.lp.saveToBd(date: self.money[indexPath.row-1].date!, amount: textToEdit,category: self.money[indexPath.row-1].category!)
                self.lp.deleteData(index: self.money[indexPath.row-1])
                self.money = self.lp.getData()
                self.spendings.reloadData()
            }else{
                return
                
            }
        }
         let cancel =  UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addTextField()
        guard let textField = alert.textFields?.first  else {
            return
            
        }
        textField.placeholder  = "New value"
        alert.addAction(saveAction)
        alert.addAction(cancel)
        present(alert,animated: true)
        
    }
    func deleteAction(indexPath: IndexPath){
        let alert = UIAlertController(title: "Delete", message: "Are you sure u want to delete?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Yes", style:.default) { action in
            
            self.lp.deleteData(index: self.money[self.money.count-indexPath.row])
            self.money.remove(at: self.money.count-indexPath.row)
            self.spendings.reloadData()

        }
        let cancel =  UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancel)
        present(alert,animated: true)
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "spendingCell", for: indexPath) as! spendingsCell
        let index = indexPath.row
        if(index == 0){
            var frameRect =  cell.dateL.frame
            frameRect.size.width = cell.frame.width/2
            cell.dateL.frame = frameRect
            cell.dateL.font = cell.dateL.font.withSize(30)
            cell.dateL.text = date.monthAsString()
            cell.categoryL.text = " "
            cell.moneyL.text = lp.getTotalPerMonth().description
        }else{
        cell.dateL.text = money[money.count-indexPath.row].date
        cell.moneyL.text = money[money.count-indexPath.row].amount!
        cell.categoryL.text = money[money.count-indexPath.row].category!
        }
        return cell
    }
    
    
    
}

