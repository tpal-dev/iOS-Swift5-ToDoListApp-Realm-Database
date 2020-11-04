//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Tomasz Paluszkiewicz on 31/10/2020.
//  Copyright © 2020 Tomasz Paluszkiewicz. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController{
    
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    // Property sended from CategoryViewController by segue
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    
    override func viewDidLoad() {
        print("LAUNCHED: viewDidLoad(ToDoListView)")
        super.viewDidLoad()
        
        
        loadItems()
        
    }
    
    
    
    //MARK: - TableView DataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Set name of cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        
        if let item = todoItems?[indexPath.row] {
            
            // Set text in row
            cell.textLabel?.text = item.title
            
            // Set checkmark (done statement) by using TERNARY OPERATOR
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Changing done status
        if let item = todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("ERROR SAVING DONE STATUS: \(error)")
            }
        }

        tableView.reloadData()
        
        // Deselect row animation
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Deleting cell
        if (editingStyle == .delete) {
            
            
            
            deleteData(indexPath: indexPath)
            
            
            
        }
    }
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Main property for TextField
        var textField = UITextField()
        
        
        // Set Alert Window
        let mainAlert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        mainAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        mainAlert.addAction(UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            // Try to save Item
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        
                        // Add new Item to context
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        
                        guard newItem.title != "" else{
                            let alert = UIAlertController(title: "Text field is empty", message: "You have to type something here", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                self.present(mainAlert, animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            return
                        }
                        
                        currentCategory.items.append(newItem)
                        
                    }
                } catch {
                    print("ERROR SAVING NEW ITEMS: \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        })
        
        mainAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        present(mainAlert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Method
   
    
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }
    
    func deleteData(indexPath: IndexPath) {
        
        if let itemForDeletion = todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            } catch {
                print("ERROR DELETING ITEM: \(error)")
            }
            
            tableView.reloadData()
            
        }
        
    }
    
    
    
}
//MARK: - SearchBar Method

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
          todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
              
              tableView.reloadData()
        
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}


