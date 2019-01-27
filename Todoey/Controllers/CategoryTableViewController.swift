//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Reactive Space on 19/01/2019.
//  Copyright © 2019 Reactive Space. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryTableViewController: UITableViewController {

    
    let realm = try! Realm()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        tableView.tableFooterView = UIView()
        loadCategories()
        
    }

    
    
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        self.tableView.reloadData()
    }
    
    //      using coredata
//    func loadCategories()  {
//        let request: NSFetchRequest<Category> = Category.fetchRequest()
//
//        do{
//            categories = try context.fetch(request)
//
//        }
//        catch{
//            print("Couldnt load categories")
//        }
//        self.tableView.reloadData()
//    }

    
    
    func saveCategories(category: Category) {
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("Couldnt save new category..")
        }
        self.tableView.reloadData()
    }
    
    
//    func saveCategories() {
//        do{
//            try self.context.save()
//        }
//        catch{
//            print("Couldnt save new category..")
//        }
//        self.tableView.reloadData()
//    }
    
   
    @IBAction func addButtonPressed(_ sender: Any) {
        showAlert()
    }
    
    
    func showAlert() {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Please Enter Category Name", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (field) in
            textField = field
            field.placeholder = "Category Name"
        }
        
        let okAction = UIAlertAction(title: "Save", style: .default) { (alert) in
            guard textField.text != nil else{return}
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.saveCategories(category: newCategory)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
//    func showAlert() {
//
//        var textField = UITextField()
//        let alert = UIAlertController(title: "Please Enter Category Name", message: nil, preferredStyle: .alert)
//
//        alert.addTextField { (field) in
//            textField = field
//            field.placeholder = "Category Name"
//        }
//
//        let okAction = UIAlertAction(title: "Save", style: .default) { (alert) in
//            guard textField.text != nil else{return}
//
//            let newCategory = Category(context: self.context)
//            newCategory.name = textField.text!
//
//            self.categories.append(newCategory)
//            self.saveCategories()
//        }
//
//        alert.addAction(okAction)
//        self.present(alert, animated: true, completion: nil)
//    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "no category"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "gotoItems", sender: self.categories![indexPath.row])
    }
    
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoViewController
        destinationVC.selectedCategory = (sender as! Category)
    }
    
}
