//
//  CategoryViewController.swift
//  ToDoListApp
//
//  Created by Tomasz Paluszkiewicz on 03/11/2020.
//  Copyright © 2020 Tomasz Paluszkiewicz. All rights reserved.
//

import UIKit
import UserNotifications
import EventKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    let eventStore = EKEventStore()
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        //print("LAUNCHED: viewDidLoad(CategoryListView)")
        super.viewDidLoad()
        
        
        /// Check first launch. If true then show BeginViewController
        if defaults.value(forKey: "FirstLaunch") as? Bool ?? true == true {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                     let newViewController = storyBoard.instantiateViewController(withIdentifier: "BeginViewController") as! BeginViewController
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.modalTransitionStyle = .partialCurl
                        self.navigationController?.present(newViewController, animated: true, completion: nil)
        }
    
        /// Request to use PUSH Notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if success {
                print("USER PUSH NOTIFICATION SUCCESS")
            } else if let error = error {
                print("Error USER NOTIFICATION : \(error)")
            }
        }
        
        /// Request to use Calendar
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            print("CALENDAR AUTHORIZED")
        case .denied:
            print("CALENDAR ACCESS DENIED")
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion:
                {(granted: Bool, error: Error?) -> Void in
                    if granted {
                        print("CALENDAR GRANTED")
                    } else {
                        print("CALENDAR ACCESS DENIED")
                    }
            })
        default:
            print("CALENDAR CASE DEFAULT")
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longpress))
        tableView.addGestureRecognizer(longPress)
        
        loadCategories()
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        
       navigationItem.leftBarButtonItem = UIBarButtonItem.optionsButton(self, action: #selector(optionsButtonPressed), imageName: "options")
        
        
    }
    
    @objc func optionsButtonPressed() {
          print("Menu button pressed")
      }
    
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// Set name of cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        
        if let category = categories?[indexPath.row] {
            /// Set text in row
            cell.textLabel?.text = category.name
            cell.textLabel?.font = UIFont(name: Fonts.helveticNeueMedium, size: 20)

            guard let categoryColor = UIColor(hexString: category.color) else { fatalError() }
            
            /// Cell backgroundColor
            cell.backgroundColor = categoryColor
            /// Cell text color
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
    
        return cell
        
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! ToDoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                /// Property selectedCategory created and sended to ToDoListConroller
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        /// Delete row
        if (editingStyle == .delete) {
            
            deleteData(at: indexPath)
            
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
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
            
            /// Delete all Calendar Events and PUSH Notifications in Category Folder
            for item in categoriesForDeletion.items {
                
                if item.dateCreated != nil {
                    let notificationCenter = UNUserNotificationCenter.current()
                    notificationCenter.removePendingNotificationRequests(withIdentifiers: ["id_\(item.title)-\(String(describing: item.dateCreated))"])
                }
                if let eventID = item.eventID {
                    if let event = self.eventStore.event(withIdentifier: eventID) {
                        do {
                            try self.eventStore.remove(event, span: .thisEvent)
                        } catch let error as NSError {
                            print("FAILED TO DELETE EVENT WITH ERROR : \(error)")
                        }
                    }
                }
                
            }
            
            /// Delete selected data
            do {
                try realm.write {
                    /// Delete children's also
                    realm.delete(categoriesForDeletion.items)
                    
                    /// Delete category Object
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
        
        /// Main property for TextField
        var textField = UITextField()
        
        /// Set Alert Window
        let mainAlert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        mainAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        mainAlert.addAction(UIAlertAction(title: "Add", style: .default) { (action) in
            
            /// Add new Category
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            
            
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
            alertTextField.autocorrectionType = .yes
            alertTextField.spellCheckingType = .yes
            textField = alertTextField
        }
        
        present(mainAlert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - LongPress Gesture Configuration for Color Change
    
    @objc func longpress(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                
                
                
                let pickedRowColor = categories?[indexPath.row].color ?? "#ffffff"
                
                let alert = UIAlertController(style: .alert)
                alert.addColorPicker(color: UIColor(hexString: pickedRowColor)) { color in
                    
                    if let categoryColor = self.categories?[indexPath.row] {
                        
                        /// Update row color
                        do {
                            try self.realm.write {

                                categoryColor.color = "\(color.hexValue())"
                            }
                        } catch {
                            print("ERROR CHANGE CATEGORY COLOR: \(error)")
                        }

                    }

                    self.tableView.reloadData()

                    //print(color.hexValue())

                }
                alert.addAction(title: "Cancel", style: .cancel)
                alert.show()

                //print("Long press Pressed:\(indexPath.row)")
            }
        }

    }
    
    
    
}

extension UIBarButtonItem {

    static func optionsButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true

        return menuBarItem
    }
}
