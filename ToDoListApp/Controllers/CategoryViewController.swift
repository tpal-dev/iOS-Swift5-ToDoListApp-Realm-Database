//
//  CategoryViewController.swift
//  ToDoListApp
//
//  Created by Tomasz Paluszkiewicz on 03/11/2020.
//  Copyright © 2020 Tomasz Paluszkiewicz. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Set name of cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // Set text in row
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
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
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Delete row
        if (editingStyle == .delete) {
            
            deleteData(at: indexPath)
            
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        // Save data in context (CoreData)
        do {
            try realm.write {
                realm.add(category)
            }
        }catch {
            print("ERROR SAVING CONTEXT: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
    }
    
    func deleteData(at indexPath: IndexPath) {
        
        if let categoriesForDeletion = categories?[indexPath.row] {
            
            // delete selected data
            do {
                try realm.write {
                    // Delete children's also
                    realm.delete(categoriesForDeletion.items)
                    // Delete category Object
                    realm.delete(categoriesForDeletion)
                }
            } catch {
                print("ERROR DELETING CATEGORY: \(error)")
            }

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
            
            // Add new Category
            let newCategory = Category()
            newCategory.name = textField.text!
            
            
            guard newCategory.name != "" else{
                let alert = UIAlertController(title: "Text field is empty", message: "You have to type something here", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.present(mainAlert, animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
    
            self.save(category: newCategory)
        })
        
        mainAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category"
            textField = alertTextField
        }
        
        present(mainAlert, animated: true, completion: nil)
        
    }
    
    
}
