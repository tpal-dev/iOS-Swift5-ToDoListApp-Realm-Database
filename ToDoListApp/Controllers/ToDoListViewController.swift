//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Tomasz Paluszkiewicz on 31/10/2020.
//  Copyright © 2020 Tomasz Paluszkiewicz. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        print("LAUNCHED: viewDidLoad(ToDoListView)")
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Eat Pizza"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Shopping"
        itemArray.append(newItem2)
        
        // Data persisted using user defaults method
        if let itemArrayCheck = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = itemArrayCheck
        }
        
        
        
    }
    
    
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let item = itemArray[indexPath.row]
        
        // Set name of cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // Set text in row
        cell.textLabel?.text = item.title
        
        // Set checkmark (done statement) by using TERNARY OPERATOR
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Selected row
        print(itemArray[indexPath.row].title)
        
        // Deselect row animation
        tableView.deselectRow(at: indexPath, animated: true)

        // Set done statement
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        // if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //     tableView.cellForRow(at: indexPath)?.accessoryType = .none
        // }else {
        //     tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        // }
        
        // Reload TableView
        tableView.reloadData()
        
    }
    
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Scope property
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            
            // Apped texfield to arrow
            self.itemArray.append(newItem)
           
            // Save iteamArray in a .plist file (app sandbox / device storage)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            // Reload TableView
            self.tableView.reloadData()
            
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

