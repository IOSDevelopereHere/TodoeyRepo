//
//  ViewController.swift
//  Todoey
//
//  Created by Reactive Space on 16/01/2019.
//  Copyright © 2019 Reactive Space. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoViewController: UITableViewController {

    @IBOutlet weak var mySearchBar: UISearchBar!
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
  //  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mySearchBar.delegate = self
     //   print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
      //  self.loadItems()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "Nothing to show"
            cell.accessoryType = .none
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                    
                    DispatchQueue.main.async {
                    tableView.reloadData()
                    }
                }
            }
            catch{
                print("Couldnt Update data")
            }
        }
        
        
        
        
      //  itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
     //   context.delete(itemArray[indexPath.row])
      //  itemArray.remove(at: indexPath.row)
        
     //   saveData()
        
        
    }
    
    
    //  MARK:- BUTTON ACTIONS
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //  todo
            
            
            guard let selectedCategory = self.selectedCategory else{return}
            
            do{
                try self.realm.write {
                    let newitem = Item()
                    newitem.title = textField.text!
                    newitem.done = false
                    selectedCategory.items.append(newitem)
                }
            }
            catch{
                print("couldn't set the value for category")
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    

        //  using realm
        func loadItems(){
            self.todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
            self.tableView.reloadData()
        }
    
//    //  using coredata
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
//
//        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        request.predicate = predicate
//        do{
//            itemArray = try context.fetch(request)
//        }
//        catch{
//            print("Error fetching data from context \(error)")
//        }
//        tableView.reloadData()
//    }
    
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

    func saveData(item: Item) {
        do{
            try realm.write {
                realm.add(item)
            }
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
        
        
        todoItems = todoItems?.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!))
        tableView.reloadData()
        
     //   loadItems()
        
        
//        //  creating a fetch request
//        let req: NSFetchRequest<Item> = Item.fetchRequest()
//
//        //  creating a predicate/ pattern to search data
//        req.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//
//        req.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItems(with: req)
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
