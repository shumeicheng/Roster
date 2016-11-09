//
//  ClassRosterViewControler.swift
//  Roster
//
//  Created by Shu-Mei Cheng on 11/6/16.
//  Copyright © 2016 Shu-Mei Cheng. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class ClassRosterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var realm: Realm?
    var thisClass : Class?
    var todayDate: Date?
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    override func viewDidLoad() {
        navigationBar.topItem?.title = thisClass?.name
        realm = try! Realm()
        todayDate = Date()
        todayDate?.date = NSDate()
        try! realm?.write{
            realm?.add(todayDate!)
            thisClass?.dates.append(todayDate!)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classRosterCell", for: indexPath) as UITableViewCell
        let name = thisClass?.persons[indexPath.row].name
        cell.textLabel?.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thisClass!.persons.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = (thisClass?.persons[indexPath.row])! as Person
        try! realm!.write{
            person.dates.append(todayDate!)
        }
    }
    
    @IBAction func pressReport(_ sender: AnyObject) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ReportDatesViewController") as! ReportDatesViewController
        vc.dates = thisClass?.dates
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func pressDone(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
