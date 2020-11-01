//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Tomasz Paluszkiewicz on 31/10/2020.
//  Copyright © 2020 Tomasz Paluszkiewicz. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggs", "Eat Pizza"]
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        print("LAUNCHED: ToDoListView viewDidLoad")
        super.viewDidLoad()
        
        // Data persisted using user defaults method
        if let itemArrayCheck = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemArray = itemArrayCheck
        }
       
        
        
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Selected row
        print(itemArray[indexPath.row])
        
        // Deselect row animation
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Checkmark
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        
    }
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Scope var
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if textField.text != nil {
                // Apped texfield to arrow
                self.itemArray.append(textField.text!)
                // Save iteamArray in a .plist file (app sandbox / device storage)
                self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                // Reload TableView
                self.tableView.reloadData()
                
            }else {
                print("ERROR in add new todo to array")
            }
              
        }
    
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

