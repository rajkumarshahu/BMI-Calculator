//
//  ViewController.swift
//  BMI-Calculator
//
//  Created by Raj Kumar Shahu on 2020-12-07.
//  Copyright © 2020 Centennial College. All rights reserved.
//

import UIKit

class PersonalInfoViewController: UIViewController {
    
    @IBOutlet weak var nameTV: UITextField!
    @IBOutlet weak var ageTV: UITextField!
    @IBOutlet weak var genderTV: UITextField!
    @IBOutlet weak var heightTv: UITextField!
    @IBOutlet weak var weightTv: UITextField!
    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bmiResultLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        nameTV.text = "Raj Kumar"
        //        genderTV.text = "Male"
        //        ageTV.text = "44"
        heightTv.placeholder = "Height in cm"
        weightTv.placeholder = "Weight in kg"
    }
    
    @IBAction func unitDidDhange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            heightTv.placeholder = "Height in cm"
            weightTv.placeholder = "Weight in kg"
        case 1:
            heightTv.placeholder = "Height in inches"
            weightTv.placeholder = "Weight in pounds"
        default:
            print("Error occured")
        }
    }
    
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        if unitSegmentedControl.selectedSegmentIndex == 0 {
            
            let bmi = Double(Float(weightTv.text!)! * 10000 / (Float(heightTv.text!)! * Float(heightTv.text!)!))
            bmiResultLabel?.text = String(format: "Your BMI is: %.2f", bmi)
            message(bmi: bmi)
            
        } else {
            
            let bmi = Double(Float(weightTv.text!)! * 730 / (Float(heightTv.text!)! * Float(heightTv.text!)!))
            bmiResultLabel?.text = String(format: "Your BMI is: %.2f", bmi)
            message(bmi: bmi)
        }
        
        bmiResultLabel?.textColor = UIColor.black
        messageLabel?.textColor = UIColor.black
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            let today = Date()
            var dateComponent = DateComponents()
            dateComponent.day = 0
            let updatedDate = Calendar.current.date(byAdding: dateComponent, to: today)
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE MMMM d, yyyy hh:mm a"
            
            // New bmi object
            let bmi = BMIData(context: context)
            
            // Creating BMI
            if let name =  nameTV.text {
                
                bmi.name = name
                bmi.updatedDate = formatter.string(from: updatedDate!)
                bmi.age = ageTV.text
                bmi.message = messageLabel.text
                bmi.bmi = bmiResultLabel.text
                bmi.height = heightTv.text
                bmi.weight = weightTv.text
                bmi.unit = unitSegmentedControl.selectedSegmentIndex != 0 ? 1 : 0;
                bmi.gender = genderTV.text
                
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            }
        }     
    }
    
    func message(bmi: Double) {
        if bmi <= 16 {
            messageLabel.text = "Severe Thinness"
        } else if bmi > 16 && bmi <= 17 {
            messageLabel.text = "Moderate Thinness"
        } else if bmi > 17 && bmi <= 18.5 {
            messageLabel.text = "Mild Thinness"
        } else if bmi > 18.5 && bmi <= 25 {
            messageLabel.text = "Normal"
        }else if bmi > 25 && bmi <= 30 {
            messageLabel.text = "Over Weight"
        } else if bmi > 30 && bmi <= 35 {
            messageLabel.text = "Obese Class I"
        } else if bmi > 35 && bmi <= 40 {
            messageLabel.text = "Obese Class II"
        } else if bmi > 40 {
            messageLabel.text = "Obese Class III"
        }
    }
    
    
}

