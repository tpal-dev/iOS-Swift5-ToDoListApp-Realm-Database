//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Tomasz Paluszkiewicz on 31/10/2020.
//  Copyright © 2020 Tomasz Paluszkiewicz. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    
    // Property sended from CategoryViewController by segue
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    // Path to documentDirectory (NSObject)
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    // Acces to viewContext (CoreData)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        print("LAUNCHED: viewDidLoad(ToDoListView)")
        super.viewDidLoad()
        
        
        print(dataFilePath)

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
        
        // Print selected row
        var checked = ""
        if itemArray[indexPath.row].done == false { checked = "✓"} else { checked = ""}
        print("\(itemArray[indexPath.row].title!) \(checked)")
 
        
        // Deselect row animation
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Set done statement
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Delete row
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        
        saveItemsAndReload()
        
    }
    
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Main property for TextField
        var textField = UITextField()
        
        
        // Set Alert Window
        let mainAlert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        mainAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        mainAlert.addAction(UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // Add new Item to context
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            guard newItem.title != "" else{
                let alert = UIAlertController(title: "Text field is empty", message: "You have to type something here", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.present(mainAlert, animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            // Apped TextField to arrow
            self.itemArray.append(newItem)
            
            self.saveItemsAndReload()
        })
        
        mainAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        
        
        present(mainAlert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Method
    
    func saveItemsAndReload() {
        
        // Save data in context (CoreData)
        do {
            try context.save()
        }catch {
            print("ERROR SAVING CONTEXT: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        //Default Request = Item.fetchRequest()
        
        //Add Filter how we want to query data
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }

        
        // Load Item data with request params
        do {
            itemArray = try context.fetch(request)
        }catch {
            print("ERROR FETCHING DATA FROM CONTEXT: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
}



    //MARK: - SearchBar Method

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Create a request
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //Add Filter how we want to query data
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        // Sort in alphabetical order
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}


