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
    
    
    
}

var cellIndex = 0

class TrackingBMIViewController: UITableViewController {
    
    // Array of todos
    var BMIs : [BMIData] = []
    
    // BMI of type BMIData
    var bmi : BMIData? = nil

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
        
        // Making a new table view cell from TodoTableViewCell class
        let cell = tableView.dequeueReusableCell(withIdentifier: "BMITrackingCell", for: indexPath) as! TrackingTableViewCell
        
        // Pulling out bmi from the array according to index and set to todoList
        let BMIList =  BMIs[indexPath.row]
        
        print(BMIList)
        
        cell.dateLabel?.text = BMIList.updatedDate
        cell.weightTV.text = BMIList.weight
        cell.BMILabel?.text = BMIList.bmi
  
        return cell
    }
   

    @IBAction func updateButtonTapped(_ sender: Any) {
        
        print("Update tapped!!!")
        
        let updateAlert = UIAlertController(title: "Update", message: "Do you really want to update this?.", preferredStyle: UIAlertController.Style.alert)
               
               updateAlert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action: UIAlertAction!) in
                   
                   if ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext) != nil{
                      
                       
                      
                       
                   }
               }))
               
               updateAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                   print("Cancelled")
               }))
               
               present(updateAlert, animated: true, completion: nil)
    }
}
