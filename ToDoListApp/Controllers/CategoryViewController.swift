//
//  CategoryViewController.swift
//  ToDoListApp
//
//  Created by Tomasz Paluszkiewicz on 03/11/2020.
//  Copyright © 2020 Tomasz Paluszkiewicz. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    // Acces to viewContext (CoreData)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Set name of cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // Set text in row
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! ToDoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                // Property selectedCategory created and sended to ToDoListConroller
                destinationVC.selectedCategory = categories[indexPath.row]
            }
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategoryAndReload() {
        
        // Save data in context (CoreData)
        do {
            try context.save()
        }catch {
            print("ERROR SAVING CONTEXT: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        // Load Item data with request params
        do {
            categories = try context.fetch(request)
        }catch {
            print("ERROR FETCHING DATA FROM CONTEXT: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        // Main property for TextField
        var textField = UITextField()
        
        // Set Alert Window
        let mainAlert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        mainAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        mainAlert.addAction(UIAlertAction(title: "Add", style: .default) { (action) in
            
            // Add new Item to context
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            guard newCategory.name != "" else{
                let alert = UIAlertController(title: "Text field is empty", message: "You have to type something here", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.present(mainAlert, animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            
            // Apped texfield to arrow
            self.categories.append(newCategory)
            
            self.saveCategoryAndReload()
        })
        
        mainAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category"
            textField = alertTextField
        }
        
        present(mainAlert, animated: true, completion: nil)
        
    }
    
    
}
