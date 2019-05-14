//
//  LocalProvider.swift
//  MoneyBalance
//
//  Created by liza_kaganskaya on 4/24/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import Foundation
import CoreData
import UIKit

let lp = LocalProvider()
struct Q
{
    var date:String
    var sum:Double
    
}
class LocalProvider {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    lazy var managedContext = appDelegate!.persistentContainer.viewContext
    
    let date = Date()
    
    func getTotalPerDay() -> [(String,Double)]  {
        
        var result:[(String,Double)] = []
        
        let fetchRequest =  NSFetchRequest<NSDictionary>(entityName: "Spendings")
        
        
        let sumExpression = NSExpression(format: "sum:(amount)")
        let sumED = NSExpressionDescription()
        sumED.expression = sumExpression
        sumED.name = "sumOfAmount"
        sumED.expressionResultType = .doubleAttributeType
        fetchRequest.propertiesToFetch = ["date", sumED]
        fetchRequest.propertiesToGroupBy = ["date"]
        
        fetchRequest.resultType = .dictionaryResultType
        do{
        var res = try managedContext.fetch(fetchRequest)
            
            res.map { i in
                let amount = i["sumOfAmount"] as! Double
                let date = i["date"] as! String
                
                result.append((date, amount))
            }

        }catch{}
       return result
    }
    
    func getTotalPerMonth() -> Float{
       
        var result:Float = 0
        
        let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "Spendings")
     
        
            fetchRequest.predicate = NSPredicate(format: "date contains[c] %@", date.monthAsNumber())
       
        do {
        
            let fetchRes  = try self.managedContext.fetch(fetchRequest) as! [Spendings]
            if fetchRes.count > 0 {
                fetchRes.map { i in
                result += Float(i.amount!)!
            }
            }else{
                print("Could not fetch")
            }
        
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return result
    }
    
    func deleteData(index:Spendings){
        
        managedContext.delete(index as NSManagedObject )

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    func getData() ->[Spendings]{
        
        let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "Spendings")
        
        var business:[Spendings] = []
        
        do {
           business  = try self.managedContext.fetch(fetchRequest) as! [Spendings]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return business
    }
    
    func saveToBd( date:String, amount:String, category:String) -> Bool{
        
        let entity =  NSEntityDescription.entity(forEntityName: "Spendings",in: managedContext)!
        
        let busines = NSManagedObject(entity: entity,insertInto: managedContext) as! Spendings
        
            busines.category = category
        
            busines.date = date
        
            busines.amount = amount
        
        do {
            try managedContext.save()
            return true
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
            
        }
    }
}
