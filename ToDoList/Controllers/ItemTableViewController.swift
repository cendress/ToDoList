//
//  ItemTableViewController.swift
//  ToDoList
//
//  Created by Christopher Endress on 5/3/23.
//

import UIKit
import CoreData

class ItemTableViewController: UITableViewController {
  
  var itemArray = ["Hello", "Bonjour", "Hola"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  //MARK: - Tableview Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    cell.textLabel?.text = itemArray[indexPath.row]
    return cell
  }
  
  //MARK: - Tableview Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80.0
  }
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
    
    let addAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
      let newItem = Item()
      newItem.title = textField.text!
      self.itemArray.append(newItem.title)
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
}


