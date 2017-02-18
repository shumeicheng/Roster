//
//  ReportDatesViewController.swift
//  Roster
//
//  Created by Shu-Mei Cheng on 11/9/16.
//  Copyright © 2016 Shu-Mei Cheng. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ReportDatesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var realm: Realm?
    var dates: List<MyDate>?
    var thisClass: Class?
    
    override func viewDidLoad() {
        try! realm = Realm()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dates?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportDateCell", for: indexPath)
        let date = dates?[indexPath.row]
        cell.textLabel?.text = String(describing: date!.theDate)
        return cell
    }
    
    func changeIt(indexPath: IndexPath, cell: UITableViewCell) {
        let alertController = UIAlertController(title: "Edit the date", message: "ok", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField(configurationHandler: nil)
        var text = ""
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: {
            action in
            switch action.style {
            case .default:
                text = (alertController.textFields?[0].text)!
                cell.textLabel?.text = text
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let newDate = dateFormatter.date(from: text)
                if(newDate == nil){
                    let warnAlert = UIAlertController(title: "Invalid Format", message: "the format should be yyyy-MM-dd.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: {
                    (action)  in
                    self.dismiss(animated: true, completion: nil)})
                    warnAlert.addAction(ok)
                    self.present(warnAlert, animated: true, completion: nil)
                    return
                }
                let tDate = (self.dates?[indexPath.row])!
                try! self.realm?.write
                    {
                  tDate.theDate
                    = newDate!
                }
                var nsDate: NSDate?
                nsDate = newDate! as NSDate?
                // add it to Calendar
                CalendarEvent().addEventToCalendar(title: self.thisClass!.name, description: self.thisClass!.name, startDate: nsDate!, endDate: nsDate! )
                

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
        present(alertController, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = dates?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportDateCell", for: indexPath)
        changeIt(indexPath: indexPath, cell: cell)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            if(indexPath.row < (dates?.count)!){
                let date = dates?[indexPath.row]
                var nsDate : NSDate?
               
                nsDate = date?.theDate as NSDate?
            
                try! realm!.write {
                    realm!.delete(date!)
                }
                // delete it from Calendar
                CalendarEvent().removeEventFromCalendar(title: thisClass!.name, description: thisClass!.name, startDate: nsDate!, endDate: nsDate! )
                

            }
        }

    }
    
    @IBAction func pressDone(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
