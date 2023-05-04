//
//  ItemTableViewController.swift
//  ToDoList
//
//  Created by Christopher Endress on 5/3/23.
//

import UIKit
import CoreData

class ItemTableViewController: UITableViewController {
  
  //MARK: - Properties
  
  var itemArray = [Item]()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  //MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    loadItems()
  }
  
  //MARK: - Tableview Methods
  
  private func setupTableView() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ItemCell")
    tableView.rowHeight = 80.0
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    let item = itemArray[indexPath.row]
    cell.textLabel?.text = item.title
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let item = itemArray[indexPath.row]
      context.delete(item)
      itemArray.remove(at: indexPath.row)
      saveItems()
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
  //MARK: - Actions
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
    alert.addTextField { (textField) in
      textField.placeholder = "Create new item"
    }
    let addAction = UIAlertAction(title: "Add Item", style: .default) { [weak self, weak alert] _ in
      guard let self = self, let textField = alert?.textFields?.first else { return }
      let item = Item(context: self.context)
      item.title = textField.text ?? ""
      self.itemArray.append(item)
      self.saveItems()
      self.tableView.reloadData()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(addAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }
  
  //MARK: - Core Data Methods
  
  private func saveItems() {
    do {
      try context.save()
    } catch {
      print("Error saving context, \(error)")
    }
  }
  
  private func loadItems() {
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    do {
      itemArray = try context.fetch(request)
    } catch {
      print("Error fetching data from context \(error)")
    }
    tableView.reloadData()
  }
}




