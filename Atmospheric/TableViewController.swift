//
//  TableViewController.swift
//  Atmospheric
//
//  Created by Casey Wilcox on 2/2/17.
//  Copyright © 2017 Casey Wilcox. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var cityTextField: UITextField!
    
    var cityToPass = String()
    
    //var locations = [String]()
    var locations = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.stack.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Location")
        
        do {
            locations = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
        }
    }
    
    @IBAction func addToList(_ sender: Any) {
        if (cityTextField.text?.isEmpty)! {
            displayAlert(title: "Oops!", message: "Let's add some characters!")
        } else {
            self.saveLocation(location: cityTextField.text!.replacingOccurrences(of: " ", with: "-"))
            cityTextField.text = ""
        }
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if ((textField.text?.isEmpty)!) {
            displayAlert(title: "Oops!", message: "Let's add some characters!")
        } else {
            self.saveLocation(location: textField.text!)
            textField.text = ""
            textField.resignFirstResponder()
        }
        tableView.reloadData()
        return true
    }
    
    @IBAction func refresh(_ sender: Any) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let city = locations[indexPath.row]
        cell.cityLabel.text = city.value(forKeyPath: "name") as? String
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cityToDelete = locations[indexPath.row]
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let context = appDelegate.stack.persistentContainer.viewContext
            
            context.delete(cityToDelete)
            locations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityToPass = locations[indexPath.row].value(forKey: "name") as! String
        let detailView = storyboard?.instantiateViewController(withIdentifier: "detailView") as! DetailViewController
        detailView.selectedCity = cityToPass.replacingOccurrences(of: " ", with: "-")
        navigationController?.pushViewController(detailView, animated: true)
    }
    
    func saveLocation(location: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.stack.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: context)!
        let city = NSManagedObject(entity: entity, insertInto: context)
        
        city.setValue(location, forKeyPath: "name")
        
        do {
            try context.save()
            locations.append(city)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}
