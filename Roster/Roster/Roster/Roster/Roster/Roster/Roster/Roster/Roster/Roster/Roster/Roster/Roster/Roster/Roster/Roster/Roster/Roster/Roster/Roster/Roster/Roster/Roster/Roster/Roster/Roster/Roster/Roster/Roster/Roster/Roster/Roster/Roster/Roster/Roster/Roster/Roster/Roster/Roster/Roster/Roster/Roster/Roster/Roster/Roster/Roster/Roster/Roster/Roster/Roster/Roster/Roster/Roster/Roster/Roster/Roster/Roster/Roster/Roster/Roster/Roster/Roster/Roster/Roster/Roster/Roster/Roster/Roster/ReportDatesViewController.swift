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
                let tDate = (self.dates?[indexPath.row])!
                try! self.realm?.write
                    {
                  tDate.theDate
                    = newDate!
                }
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
                try! realm!.write {
                    realm!.delete(date!)
                }
            }
        }

    }
    
    @IBAction func pressDone(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}