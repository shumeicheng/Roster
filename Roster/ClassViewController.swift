//
//  ClassViewController.swift
//  Roster
//
//  Created by Shu-Mei Cheng on 11/3/16.
//  Copyright © 2016 Shu-Mei Cheng. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ClassViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var names = Array(repeating: "Name", count: 35)
    @IBOutlet weak var tableView: UITableView!
    var nameJustEntered = ""
    var tableViewCell: TableViewCell?
    var currentIndex = 0
    var classes: Classes?
    var realm: Realm?
    @IBOutlet weak var className: UITextField!
 
    override func viewDidLoad() {
       realm = try! Realm()
       classes = realm?.objects(Classes.self).first
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 35
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.tag == 1 ){ // class name
            let thisClass = Class()
            thisClass.name = textField.text!
            try! realm?.write {
                realm?.add(thisClass)
            }
           
        }else {
            nameJustEntered = textField.text!
            tableViewCell!.name.isHidden = true
            names[currentIndex] = textField.text!
            tableView.reloadData()
            tableViewCell!.name.isHidden = false
        }
        textField.resignFirstResponder()

        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableViewCell
        cell.name.delegate = self
        tableViewCell = cell
        currentIndex = indexPath.row
        //print(cell.name.text)
    }
    
    @IBAction func pressDone(_ sender: AnyObject) {
        // create Realm name objects
        for name in names{
            let person = Person()
            person.name = name
            try! realm?.write {
                realm?.add(person)
            }
        }
        // reset the names to empty
        names.removeAll()
        self.dismiss(animated: true, completion: nil)
        
    }
}
