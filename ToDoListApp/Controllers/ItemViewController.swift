//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Tomasz Paluszkiewicz on 31/10/2020.
//  Copyright © 2020 Tomasz Paluszkiewicz. All rights reserved.
//

import UIKit
import UserNotifications
import EventKit
import RealmSwift
import ChameleonFramework

class ItemViewController: UITableViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    let eventStore = EKEventStore()
    let defaults = UserDefaults.standard
    
    /// Property sended from CategoryViewController by segue
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        //print("LAUNCHED: viewDidLoad(ToDoListView)")
        super.viewDidLoad()
        
        loadItems()
        viewDidLoadConfig()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //print("LAUNCHED: viewWillAppear(ToDoListView)")
        super.viewWillAppear(animated)
        
        viewWillAppearConfig()
        
    }
    
    
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// Set checkmark image
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage(named: ImageName.chekmark)
        
        /// Set cell
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName.toDoItemCell, for: indexPath)
        
        cell.accessoryView = imageView
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        cell.layer.borderColor = #colorLiteral(red: 0.05518321701, green: 0.05518321701, blue: 0.05518321701, alpha: 1)
        cell.layer.borderWidth = 0
        
        
        if let item = todoItems?[indexPath.row] {
            
            /// Set text in row
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.dateReminder
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 9)
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(todoItems!.count)) - CGFloat(0.05)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                cell.detailTextLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                
            }
            /// Set checkmark (done statement) by using TERNARY OPERATOR
            cell.accessoryView = item.done ? imageView : .none
            
        }else {
            cell.textLabel?.text = "No Items Added".localized()
        }
        print(self.selectedCategory!.items)
        //print(items)
        return cell
    }
    
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchBar.endEditing(true)
        
        /// Changing done status
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
        
        /// Deleting cell
        if (editingStyle == .delete) {
            
            deleteData(indexPath: indexPath)
            
        }
    }
    /// Alternative editingStyle .delete
    //    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    //        let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
    //            self.deleteData(indexPath: indexPath)
    //        }
    //        deleteButton.backgroundColor = .red
    //        return [deleteButton]
    //    }
    
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        /// Drag and Drop
        if let currentCategory = self.selectedCategory{
            
            do {
                try self.realm.write {
                    
                    currentCategory.items.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
                    
                    for (index, item) in currentCategory.items.enumerated() {
                        item.row = "\(index)"
                    }
                    
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
        
        
        /// Main property for TextField
        var textField = UITextField()
        
        /// Set Alert Window
        let mainAlert = UIAlertController(title: "Add New Task".localized(), message: "", preferredStyle: .alert)
        
        mainAlert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
        
        mainAlert.addAction(UIAlertAction(title: "Add Task".localized(), style: .default) { (action) in
            
            /// Try to save Item
            if let currentCategory = self.selectedCategory {
                
                
                do {
                    try self.realm.write {
                        
                        /// Add new Item to context
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        newItem.row = "\(currentCategory.items.count)"
                        
                        guard newItem.title != "" else{
                            let alert = UIAlertController(title: "Text field is empty".localized(), message: "You have to type something here".localized(), preferredStyle: .alert)
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
            
            ARSLineProgress.showSuccess()
            self.tableView.reloadData()
            
        })
        
        mainAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Title".localized()
            alertTextField.autocorrectionType = .yes
            alertTextField.spellCheckingType = .yes
            textField = alertTextField
        }
        
        present(mainAlert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Method
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: KeyPath.row, ascending: true)
        
        tableView.reloadData()
        
    }
    
    func deleteData(indexPath: IndexPath) {
        
        
        if let item = self.todoItems?[indexPath.row], let currentCategory = self.selectedCategory {
            
            if item.dateCreated != nil {
                let notificationCenter = UNUserNotificationCenter.current()
                notificationCenter.removePendingNotificationRequests(withIdentifiers: ["id_\(item.title)-\(String(describing: item.dateCreated))"])
            }
            
            if let eventID = item.eventID {
                if let event = self.eventStore.event(withIdentifier: eventID) {
                    do {
                        try self.eventStore.remove(event, span: .thisEvent)
                    } catch let error as NSError {
                        print("ERROR DELETING EVENT: \(error)")
                    }
                }
            }
            
            do {
                try self.realm.write {
                    
                    self.realm.delete(item)
                    for (index, item) in currentCategory.items.enumerated() {
                        item.row = "\(index)"
                    }
                }
            } catch {
                print("ERROR DELETING ITEM: \(error)")
            }
            
            //print("ITEM DELETED")
            ARSLineProgress.showFail()
            self.tableView.reloadData()
            
        }
    }
    
    //MARK: - LongPress Gesture Configuration (Add a New Date Notification)
    
    @objc func longpress(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                
                var dateSet : Date?
                let dateFormatter = DateFormatter()
                
                /// Add date to item
                let alert = UIAlertController(title: "Date Picker".localized(), message: "Select the event date".localized(), preferredStyle: .alert)
                alert.addDatePicker(mode: .dateAndTime, date: Date(), minimumDate: nil, maximumDate: nil) { date in
                    
                    dateSet = date
                    
                }
                
                /// Add picked date to item and set a reminder
                alert.addAction(title: "OK", style: .default) { alert in
                    
                    if let item = self.todoItems?[indexPath.row] {
                        
                        do {
                            try self.realm.write {
                                item.dateReminder = dateSet?.dateTimeString(ofStyle: .short)
                            }
                        } catch {
                            print("ERROR ADD DATE TO ITEM: \(error)")
                        }
                        
                        /// Delete Push Notification if exist
                        if item.dateCreated != nil {
                            let notificationCenter = UNUserNotificationCenter.current()
                            notificationCenter.removePendingNotificationRequests(withIdentifiers: ["id_\(item.title)-\(String(describing: item.dateCreated))"])
                            //print("Old PUSH Notification date DELETED")
                            
                        }
                        
                        /// Create a new PUSH Notification
                        let content = UNMutableNotificationContent()
                        content.title = "TO DO LIST - You have something to do :)".localized()
                        content.sound = .default
                        content.body = "\(item.title)"
                        
                        if let targetDate = dateSet {
                            
                            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: targetDate), repeats: false)
                            
                            let request = UNNotificationRequest(identifier: "id_\(item.title)-\(String(describing: item.dateCreated))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error) in
                                if error != nil {
                                    print("ERROR PUSH NOTIFICATION REQUEST: \(String(describing: error))")
                                    
                                }
                            }
                            
                            DispatchQueue.main.async {
                                
                                /// Delete calendar event if exist
                                if let eventID = item.eventID {
                                    if let event = self.eventStore.event(withIdentifier: eventID) {
                                        do {
                                            try self.eventStore.remove(event, span: .thisEvent)
                                        } catch let error as NSError {
                                            print("FAILED TO SAVE EVENT WITH ERROR : \(error)")
                                        }
                                        print("Old Calendar Event DELETED")
                                    }
                                }
                                
                                let firstAlarmDelay = self.defaults.string(forKey: KeyUserDefaults.firstAlarmDelay)
                                let secondAlarmDelay = self.defaults.string(forKey: KeyUserDefaults.secondAlarmDelay)
                                
                                /// Create new event
                                let event:EKEvent = EKEvent(eventStore: self.eventStore)
                                let startDate = targetDate
                                let endDate = startDate.addingTimeInterval(1 * 60 * 60)
                                let alarm1 = EKAlarm(relativeOffset: -Double(firstAlarmDelay ?? "5")!  * 60)
                                let alarm2 = EKAlarm(relativeOffset: -Double(secondAlarmDelay ?? "60")!  * 60)
                                
                                event.title = item.title
                                event.startDate = startDate
                                event.endDate = endDate
                                event.notes = "Created by TO DO LIST CALENDAR ©".localized()
                                event.addAlarm(alarm1)
                                event.addAlarm(alarm2)
                                event.calendar = self.eventStore.defaultCalendarForNewEvents
                                do {
                                    try self.eventStore.save(event, span: .thisEvent)
                                    try self.realm.write { item.eventID = event.eventIdentifier }
                                } catch let error as NSError {
                                    print("FAILED TO SAVE EVENT WITH ERROR : \(error)")
                                }
                                
                            }
                            
                            /// Event Time Text HUD
                            dateFormatter.dateFormat = "hh:mm  dd/MM/YYYY"
                            let dateString = dateFormatter.string(from: targetDate)
                            
                            let alert = UIAlertController(title: "Event Time Set".localized(), message: "\(dateString)", preferredStyle: .alert)
                            if #available(iOS 13.0, *) {
                                alert.setTitle(font: UIFont(name: Fonts.helveticNeueMedium, size: 18)!, color: .label)
                                alert.setMessage(font: UIFont(name: Fonts.helveticNeueLight, size: 15)!, color: .label)
                            } else {
                                alert.setTitle(font: UIFont(name: Fonts.helveticNeueMedium, size: 18)!, color: .black)
                                alert.setMessage(font: UIFont(name: Fonts.helveticNeueLight, size: 15)!, color: .black)
                            }
                            //alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .black
                            self.present(alert, animated: true, completion: nil)
                            let when = DispatchTime.now() + 3
                            DispatchQueue.main.asyncAfter(deadline: when){
                                alert.dismiss(animated: true, completion: nil)
                            }
                            
                        } else { print("ERROR, let targetDate = nil \(String(describing: dateSet))") }
                        
                        self.tableView.reloadData()
                        
                    } else { print("ERROR, let item = nil \(String(describing: self.todoItems?[indexPath.row]))") }
                    
                }
                
                alert.addAction(title: "Cancel".localized(), style: .cancel)
                alert.show()
                
                //print("Long press Pressed:\(indexPath.row) \(String(describing: todoItems?[indexPath.row].title))")
                
            }
        }
        
    }
    
    
    // MARK: - ViewDidLoad Configuration
    
    func viewDidLoadConfig() {
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        
        
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longpress))
        tableView.addGestureRecognizer(longPress)
    }
    
    
    //MARK: - ViewDidAppear Configuration
    
    func viewWillAppearConfig() {
        
        if let colorHex = selectedCategory?.color {
            
            title = selectedCategory!.name
            self.navigationItem.rightBarButtonItem = self.editButtonItem
            self.view.backgroundColor = DefaultSettings.sharedInstance.backgroundColor
            
            //guard let navBar = navigationController?.navigationBar else {fatalError("NavigationController does not exist") }
            
            if let customColor = UIColor(hexString: colorHex) {
                
                searchBar.barTintColor = customColor
                searchBar.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
                    textfield.textColor = UIColor.black
                    textfield.backgroundColor = UIColor.white
                    textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
                }
                /// Extra options
                //navBar.barTintColor = navBarColor
                //navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                //navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
            }
        }
    }
    
    
    
    
}
//MARK: - SearchBar Method

extension ItemViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: KeyPath.row, ascending: true)
        
        tableView.reloadData()
        
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
        
    }
    
}


