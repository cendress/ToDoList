//
//  ItemTableViewController.swift
//  ToDoList
//
//  Created by Christopher Endress on 5/3/23.
//

import UIKit
import CoreData

class ItemTableViewController: UITableViewController {
  
  var itemArray = [Item]()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadItems()
  }
  
  //MARK: - Tableview Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    cell.textLabel?.text = itemArray[indexPath.row].title
    return cell
  }
  
  //MARK: - Tableview Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    context.delete(itemArray[indexPath.row])
    itemArray.remove(at: indexPath.row)
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    saveItems()
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80.0
  }
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
    
    let addAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
      let newItem = Item(context: self.context)
      newItem.title = textField.text!
      self.itemArray.append(newItem)
      self.saveItems()
      self.tableView.reloadData()
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
      alert.dismiss(animated: true, completion: nil)
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
    }
    
    alert.addAction(addAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  
  //MARK: - Model Manipulation Methods
  
  func saveItems() {
    let encoder = PropertyListEncoder()
    
    do {
      try context.save()
    } catch {
      print("Error saving context, \(error)")
    }
  }
  
  func loadItems() {
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    
    do {
      itemArray = try context.fetch(request)
    } catch {
      print("Error fetching data from context \(error)")
    }
  }
}


