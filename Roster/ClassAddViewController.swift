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

class ClassAddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var names = Array(repeating: "Name", count: 35)
    @IBOutlet weak var tableView: UITableView!
    var nameJustEntered = ""
    var classN = ""
    var tableViewCell: TableViewCell?
    var currentIndex = 0
    var classes: Classes?
    var thisClass: Class?
    var realm: Realm?
    @IBOutlet weak var className: UITextField!
 
    override func viewDidLoad() {
       className.delegate = self
       realm = try! Realm()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 35
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.tag == 1 ){ // class name
            classN = textField.text!
        }else {
            nameJustEntered = textField.text!
            tableViewCell?.textLabel?.text = String(currentIndex + 1) + ". " + nameJustEntered
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
        cell.textLabel?.text = String(indexPath.row + 1) + ". " + names[indexPath.row]
    
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
        thisClass = Class()
        thisClass?.name = classN

        try! realm!.write {
            realm!.add(thisClass!)
            classes!.classes.append(thisClass!)
        }
        

        for name in names{
            if name == "Name" {
                break
            }
            let person = Person()
             person.name = name
            try! realm!.write {
                
                realm!.add(person)
                thisClass?.persons.append((person))

                
            }
        }
        // reset the names to empty
        names.removeAll()
        self.dismiss(animated: true, completion: nil)
        
    }
}
