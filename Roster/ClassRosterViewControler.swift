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
    
    @IBOutlet weak var tableView: UITableView!
    var thisPerson:Person?
    var realm: Realm?
    var thisClass : Class?
    var todayDate: MyDate?
    let myCalendarEvent = CalendarEvent()
    
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    override func viewDidLoad() {
        navigationBar.topItem?.title = ""//thisClass?.name
        
        realm = try! Realm()
        todayDate = MyDate()
        todayDate?.theDate = Date()
        try! realm?.write{
            realm?.add(todayDate!)
        }
        className.text = thisClass?.name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classRosterCell", for: indexPath) as UITableViewCell
        let name = thisClass?.persons[indexPath.row].name
        let str = String(indexPath.row + 1) + ". " + name!
        cell.textLabel?.text = str
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thisClass!.persons.count
    }
    
    func personCheckin(){
        try! realm!.write {
            thisPerson?.dates.append(todayDate!)
        }
    }
    
    func classCheckin(){
        try! realm!.write {
            thisClass?.dates.append(todayDate!)
        }
// add to the calendar
        myCalendarEvent.addEventToCalendar(title: thisClass!.name, description: thisClass!.name, startDate: todayDate!.theDate as NSDate, endDate: todayDate!.theDate as NSDate)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        thisPerson = (thisClass?.persons[indexPath.row])! as Person
        checkIn(handler: personCheckin)
    }
    
    func checkIn(handler: @escaping ()->Void){
        let alertController = UIAlertController(title: "Check in:", message: "Check in now?", preferredStyle: .alert)
    
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: {
        action in
            switch action.style {
            case .default:
                handler()
                break
                
            case .cancel:
                break
                
            case .destructive:
                break
            }}
        )
        alertController.addAction(defaultAction)
        let cancelAction = UIAlertAction(title: "cancel", style: .default, handler: {
            action in
            switch action.style {
            case .default:
          
                break
                
            case .cancel:
                break
                
            case .destructive:
                break
            }}
        )
        alertController.addAction(cancelAction)
        let reportAction = UIAlertAction(title: "Report", style: .default, handler: {
            action in
            switch action.style {
            case .default:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportDatesViewController") as! ReportDatesViewController
                vc.dates = self.thisPerson?.dates
                vc.thisClass = self.thisClass
                self.present(vc, animated: true, completion: nil)
                break
                
            case .cancel:
                break
                
            case .destructive:
                break
            }}
        )
        alertController.addAction(reportAction)

        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addMember(_ sender: Any) {
        
        let alert =
        UIAlertController(title: "Name:", message: "enter the name", preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: {
            action in
            switch action.style {
            case .default:
                let name = alert.textFields?[0].text
                let person = Person()
                person.name = name!
                try! self.realm?.write(){
                    self.realm?.add(person)
                    self.thisClass?.persons.append(person)
                }
                self.tableView.reloadData()
                break
            case .cancel:
                break
            case .destructive:
                break
            }}
        )
        alert.addAction(defaultAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler:nil)
        alert.addAction(cancelAction)
        
        alert.addTextField(configurationHandler: nil)
        
        present(alert, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            if(indexPath.row < (thisClass?.persons.count)!){
                let person = thisClass?.persons[indexPath.row]
                try! realm!.write {
                    realm!.delete(person!)
                }
            }
        }

    }
    
    @IBAction func pressReset(_ sender: Any) {
        try! realm!.write {
          let persons = thisClass?.persons
        
        // for every persons clear up its dates
          for person in persons! {            
              person.dates.removeAll()
          }
        }
        try! realm!.write {
          thisClass?.dates.removeAll()
        }
        tableView.reloadData()
    }
    
    @IBAction func pressCheckIn(_ sender: Any) {
        checkIn(handler: classCheckin)
    }
    
    @IBAction func pressReport(_ sender: AnyObject) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ReportDatesViewController") as! ReportDatesViewController
        vc.dates = thisClass?.dates
        vc.thisClass = thisClass
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func pressDone(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
