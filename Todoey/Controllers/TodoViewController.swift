//
//  ViewController.swift
//  Todoey
//
//  Created by Reactive Space on 16/01/2019.
//  Copyright © 2019 Reactive Space. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {

    var itemArray = [item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = item()
        item1.title = "Find Mac"
        itemArray.append(item1)
        
        let item2 = item()
        item2.title = "Buy Eggs"
        itemArray.append(item2)
        
        let item3 = item()
        item3.title = "Destroy Demogrogon"
        itemArray.append(item3)
        
       
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //  MARK:- BUTTON ACTIONS
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //  todo
            
            let newitem = item()
            newitem.title = textField.text!
            
            self.itemArray.append(newitem)
            self.defaults.set(self.itemArray, forKey: "itemsArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    

}

