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
    
    // Create a Item.plist for itemArray
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    
    override func viewDidLoad() {
        print("LAUNCHED: viewDidLoad(ToDoListView)")
        super.viewDidLoad()
        
        
        
        print(dataFilePath ?? "none")
        

        
        loadItems()
        
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
        
        saveItemsAndReload()
        
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
            
            self.saveItemsAndReload()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulation Method
    
    func saveItemsAndReload() {
        
        // Save iteamArray in a .plist file (app sandboxing / device storage)
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch {
            print("Error encoding item array, \(error)")
        }
        
        // Reload TableView
        tableView.reloadData()
    }
    
    func loadItems() {
        
        // Retrieve itemArray from Item.plist file.
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
        
}



