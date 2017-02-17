//
//  RosterViewController.swift
//  Roster
//
//  Created by Shu-Mei Cheng on 11/1/16.
//  Copyright © 2016 Shu-Mei Cheng. All rights reserved.
//

import UIKit
import RealmSwift
import CloudKit

class RosterViewController: UIViewController {
    var classes : Classes?
    var realm : Realm?
    
    func getClasses()  {
        realm = try! Realm()
        classes = realm?.objects(Classes.self).first
        if( classes == nil) {
            classes = Classes()
            try! realm?.write(){
                realm?.add(classes!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func isICloudContainerAvailable()->Bool {
        if FileManager.default.ubiquityIdentityToken != nil {
            return true
        }
        else {
            return false
        }
    }
    
    func alertAdd(title: String, message: String) -> Void{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: {
            (action) in
            exit(0)
        }
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        if(isICloudContainerAvailable()==false){
            alertAdd(title: "iCloud drive is not turned on.", message: "Please check iCloud drive setting is on.")
        }
       
    }
 
    @IBAction func createRoster(_ sender: AnyObject) {
       let vc = storyboard?.instantiateViewController(withIdentifier: "ClassAddViewController") as! ClassAddViewController
        getClasses()
        vc.classes = classes
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func listRoster(_ sender: AnyObject) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ClassListViewController") as! ClassListViewController
        present(vc, animated: true, completion: nil)
        

    }
    
}

