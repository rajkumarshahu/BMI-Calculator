//
//  TrackingBMIViewController.swift
//  BMI-Calculator
//
//  Created by Raj Kumar Shahu on 2020-12-07.
//  Copyright © 2020 Centennial College. All rights reserved.
//

import UIKit

import CoreData

class TrackingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weightTV: UITextField!
    @IBOutlet weak var BMILabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
}

var cellIndex = 0

class TrackingBMIViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    var BMIs : [BMIData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Anytime view is about to appear this function gets called. This is where we access coredata
    override func viewWillAppear(_ animated: Bool) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let coreDataBMIData = try? context.fetch(BMIData.fetchRequest()) as? [BMIData] {
                BMIs = coreDataBMIData
                tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        BMIs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Making a new table view cell from TrackingTableViewCell class
        let cell = tableView.dequeueReusableCell(withIdentifier: "BMITrackingCell", for: indexPath) as! TrackingTableViewCell
        
        // Pulling out bmi from the array according to index and set to bmiList
        let BMIList =  BMIs[indexPath.row]
        
        nameLabel.text = BMIList.name
        ageLabel.text = BMIList.age! + " years"
        genderLabel.text = BMIList.gender
        
        cell.dateLabel?.text = BMIList.updatedDate
        cell.weightTV.text = BMIList.weight!
        cell.unitLabel.text = (((BMIList.unit) != 0) ? "lb" : "kg")
        cell.BMILabel?.text = BMIList.bmi! + " 🏋️‍♂️ " + BMIList.message!
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // declaring custom actions for swiped cell
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // declaring Delete action when swiped cell
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (contextualAction, view, boolValue) in
            
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
                // removing data from the list of array (in backend)
                context.delete(self.BMIs[indexPath.row])
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                
            }
            // removing cell from the tableView (in frontend)
            self.BMIs.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        
        let updateAlert = UIAlertController(title: "Update", message: "Do you really want to update this?.", preferredStyle: UIAlertController.Style.alert)
        
        updateAlert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action: UIAlertAction!) in
            
            guard let cell = (sender as AnyObject).superview?.superview as? TrackingTableViewCell else {
                return
            }
            
            let buttonPostion = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: self.tableView)
            
            if let indexPath = self.tableView.indexPathForRow(at: buttonPostion) {
                let rowIndex =  indexPath.row
                
                
                if ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext) != nil{
                    
                    let today = Date()
                    var dateComponent = DateComponents()
                    dateComponent.day = 0
                    let updatedDate = Calendar.current.date(byAdding: dateComponent, to: today)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEEE MMMM d, yyyy hh:mm a"
                    
                    self.BMIs[rowIndex].weight = cell.weightTV.text
                    let heightSq = Float(self.BMIs[rowIndex].height!)! * Float(self.BMIs[rowIndex].height!)!
                    let weight = cell.weightTV.text
                    let floatWeight = (weight! as NSString).floatValue
                    
                    var updatedBMI = floatWeight * 10000 / heightSq
                    if(self.BMIs[rowIndex].unit != 0) {
                        updatedBMI = floatWeight * 730 / heightSq
                    }
                    
                    if updatedBMI <= 16 {
                        self.BMIs[rowIndex].message = "Severe Thinness"
                    } else if updatedBMI > 16 && updatedBMI <= 17 {
                        self.BMIs[rowIndex].message = "Moderate Thinness"
                    } else if updatedBMI > 17 && updatedBMI <= 18.5 {
                        self.BMIs[rowIndex].message = "Mild Thinness"
                    } else if updatedBMI > 18.5 && updatedBMI <= 25 {
                        self.BMIs[rowIndex].message = "Normal"
                    }else if updatedBMI > 25 && updatedBMI <= 30 {
                        self.BMIs[rowIndex].message = "Over Weight"
                    } else if updatedBMI > 30 && updatedBMI <= 35 {
                        self.BMIs[rowIndex].message = "Obese Class I"
                    } else if updatedBMI > 35 && updatedBMI <= 40 {
                        self.BMIs[rowIndex].message = "Obese Class II"
                    } else if updatedBMI > 40 {
                        self.BMIs[rowIndex].message = "Obese Class III"
                    }
                    
                    self.BMIs[rowIndex].bmi = String(format: "Your BMI is: %.2f", updatedBMI)
                    self.BMIs[rowIndex].updatedDate = formatter.string(from: updatedDate!)
                    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                    
                    self.tableView.reloadData()
                }
            }
        }))
        
        updateAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Cancelled")
        }))
        
        present(updateAlert, animated: true, completion: nil)
    }
}
