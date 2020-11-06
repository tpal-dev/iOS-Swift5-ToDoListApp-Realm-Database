//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Tomasz Paluszkiewicz on 31/10/2020.
//  Copyright © 2020 Tomasz Paluszkiewicz. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: UITableViewController{
    
    var todoItems: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
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
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("LAUNCHED: viewWillAppear(ToDoListView)")
        super.viewWillAppear(animated)
        
        viewSetUp()
        
    }
    
    
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Set checkmark image
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage(named:"checkmark.png")
        
        // Set cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.accessoryView = imageView
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        
        
        
        if let item = todoItems?[indexPath.row] {
            
            // Set text in row
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(todoItems!.count)) - CGFloat(0.1)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                //tableView.backgroundColor = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row + 1) / CGFloat(todoItems!.count + 1))
                
            }
            
            // Set checkmark (done statement) by using TERNARY OPERATOR
            cell.accessoryView = item.done ? imageView : .none
            
        }else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchBar.endEditing(true)
        
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
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Deleting cell
        if (editingStyle == .delete) {
            
            deleteData(indexPath: indexPath)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
       
        
        // Drag and Drop
        if let item = todoItems?[sourceIndexPath.row] {
            
            do {
                try realm.write {
                    
                    swap(&item.title, &todoItems![destinationIndexPath.row].title)
                    swap(&item.done, &todoItems![destinationIndexPath.row].done)
                    swap(&item.dateCreated, &todoItems![destinationIndexPath.row].dateCreated)
                    
                }
            } catch {
                print("ERROR SAVING DONE STATUS: \(error)")
            }
        }
    
         tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
          return true
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
            alertTextField.autocorrectionType = .yes
            alertTextField.spellCheckingType = .yes
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
    
    
    
    //MARK: - Set up NavigationBar
    
    func viewSetUp() {
        if let colorHex = selectedCategory?.color {
            
            title = selectedCategory!.name
            
            //guard let navBar = navigationController?.navigationBar else {fatalError("NavigationController does not exist") }
            
            if let navBarColor = UIColor(hexString: colorHex) {
                
                searchBar.barTintColor = navBarColor
                
                // Extra options
                //navBar.barTintColor = navBarColor
                //navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                //navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
            }
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


