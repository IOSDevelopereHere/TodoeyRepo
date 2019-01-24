//
//  ViewController.swift
//  Todoey
//
//  Created by Reactive Space on 16/01/2019.
//  Copyright © 2019 Reactive Space. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController {

    @IBOutlet weak var mySearchBar: UISearchBar!
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
  //  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     //   print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
      //  self.loadItems()
        
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
        
      //  itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        saveData()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //  MARK:- BUTTON ACTIONS
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //  todo
            
            
            
            let newitem = Item(context: self.context)
            newitem.title = textField.text!
            newitem.done = false
            newitem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newitem)
            
            self.saveData()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //  using coredata
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        request.predicate = predicate
        do{
            itemArray = try context.fetch(request)
        }
        catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    //  using nsdecoder
//    func loadItems()  {
//        if let data = try? Data(contentsOf: self.dataFilePath!){
//            let decoder = PropertyListDecoder()
//            do{
//            itemArray = try decoder.decode([item].self, from: data)
//            }catch{
//                print("Error Decoding")
//            }
//        }
//    }

    func saveData() {
        do{
            try context.save()
        }
        catch{
            print("Error Saving Item Array.")
        }
        tableView.reloadData()
    }
    
    
}

//  MARK:- UISearchBarDelegate
extension TodoViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //  creating a fetch request
        let req: NSFetchRequest<Item> = Item.fetchRequest()
        
        //  creating a predicate/ pattern to search data
        req.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        req.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: req)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
        
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}
