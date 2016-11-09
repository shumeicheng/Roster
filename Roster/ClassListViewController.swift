//
//  ClassListViewController.swift
//  Roster
//
//  Created by Shu-Mei Cheng on 11/6/16.
//  Copyright © 2016 Shu-Mei Cheng. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ClassListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var realm: Realm?
    var classList: Classes?
    
    override func viewDidLoad() {
        realm = try! Realm()
        classList = realm?.objects(Classes.self).first
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classList!.classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath) as UITableViewCell
        let thisClass = classList?.classes[indexPath.row]
        cell.textLabel?.text = thisClass?.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thisClass = classList?.classes[indexPath.row]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ClassRosterViewController") as! ClassRosterViewController
        vc.thisClass = thisClass
      
        present(vc, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let thisClass = classList!.classes[indexPath.row]
            try! realm!.write {
                realm!.delete(thisClass)
            }
        }
        
    }
    @IBAction func pressDone(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
