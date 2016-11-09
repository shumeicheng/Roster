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
    var dates: List<Date>?
    
    override func viewDidLoad() {
        try! realm = Realm()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dates?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportDateCell", for: indexPath)
        let date = dates?[indexPath.row]
        
        cell.textLabel?.text = String(describing: date?.date)
        return cell
    }
    
    @IBAction func pressDone(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
