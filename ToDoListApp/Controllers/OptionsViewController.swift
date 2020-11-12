//
//  OptionsViewController.swift
//  ToDoListApp
//
//  Created by Tomasz Paluszkiewicz on 09/11/2020.
//  Copyright © 2020 Tomasz Paluszkiewicz. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
   
    let timeArray = ["0","5","10","15","20","30","45","60","90","120"]
    var alertDelay: String = ""

    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var button1: CustomButton!
    @IBOutlet weak var button2: CustomButton!
    @IBOutlet weak var button3: CustomButton!
    @IBOutlet weak var button4: CustomButton!
    @IBOutlet weak var button5: CustomButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshColorTheme()
        
    }
    
   
    
    @IBAction func returnButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func darkModeButtonPressed(_ sender: Any) {
        
        setThemeColor()
        
    }
    
    
    
    @IBAction func firstAlertPressed(_ sender: Any) {
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "1st Alarm Delay", message: "Set Minutes", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        
        editRadiusAlert.addAction(UIAlertAction(title: "OK", style: .default) { alert in
         
            self.defaults.set(self.alertDelay, forKey: KeyUserDefaults.firstAlarmDelay)
        })
        
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
        
    }
    
    
    
    @IBAction func secondAlertPressed(_ sender: Any) {
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "2nd Alarm Delay", message: "Set Minutes", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        
        editRadiusAlert.addAction(UIAlertAction(title: "OK", style: .default) { alert in
    
            self.defaults.set(self.alertDelay, forKey: KeyUserDefaults.secondAlarmDelay)
        })
        
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
        
    }
    
    
    
    @IBAction func tutorialButtonPressed(_ sender: Any) {
        
    }
    
    
    
    @IBAction func aboutButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(style: .actionSheet)
        
        alert.addTextViewer(text: .attributedText(AboutText.text))
        alert.addAction(title: "OK".localized, style: .cancel)
        alert.view.addSubview(UIView())
        DispatchQueue.main.async {
            self.present(alert, animated: false, completion: nil)
        }
        
    }
    
    
    
    func  setThemeColor() {
        
        let blackColorTheme = defaults.bool(forKey: KeyUserDefaults.colorTheme)
        let settings = DefaultSettings.sharedInstance
        
        if blackColorTheme == false {
            settings.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            settings.buttonBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            settings.buttonLabelColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            settings.labelColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            defaults.set(true, forKey: KeyUserDefaults.colorTheme)
            refreshColorTheme()
        } else {
            settings.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            settings.buttonBackgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            settings.buttonLabelColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            settings.labelColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            defaults.set(false, forKey: KeyUserDefaults.colorTheme)
            refreshColorTheme()
        }
        
    }
    
    func refreshColorTheme() {
        
        let settings = DefaultSettings.sharedInstance
        
        self.view.backgroundColor = settings.backgroundColor
        label1.textColor = settings.labelColor
        label2.textColor = settings.labelColor
        label3.textColor = settings.labelColor
        label4.textColor = settings.labelColor
        self.button1.backgroundColor = settings.buttonBackgroundColor
        self.button2.backgroundColor = settings.buttonBackgroundColor
        self.button3.backgroundColor = settings.buttonBackgroundColor
        self.button4.backgroundColor = settings.buttonBackgroundColor
        self.button5.backgroundColor = settings.buttonBackgroundColor
        button1.setTitleColor(settings.buttonLabelColor, for: .normal)
        button2.setTitleColor(settings.buttonLabelColor, for: .normal)
        button3.setTitleColor(settings.buttonLabelColor, for: .normal)
        button4.setTitleColor(settings.buttonLabelColor, for: .normal)
        button5.setTitleColor(settings.buttonLabelColor, for: .normal)
        
    }
    
    // MARK: - - PickerView Configuration
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return timeArray[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            alertDelay = "\(timeArray[row])"
            
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
               return timeArray.count
           }

    
}


