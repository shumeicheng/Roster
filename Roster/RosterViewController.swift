//
//  RosterViewController.swift
//  Roster
//
//  Created by Shu-Mei Cheng on 11/1/16.
//  Copyright © 2016 Shu-Mei Cheng. All rights reserved.
//

import UIKit
import RealmSwift

class RosterViewController: UIViewController {
    var classes : Classes?
    var realm : Realm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        classes = Classes()
        try! realm?.write(){
            realm?.add(classes!)
        }
    }

    @IBAction func createRoster(_ sender: AnyObject) {
       let vc = storyboard?.instantiateViewController(withIdentifier: "ClassViewController") as! ClassViewController
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func listRoster(_ sender: AnyObject) {
        performSegue(withIdentifier: "TableSeque", sender: self)
    }
    
}

