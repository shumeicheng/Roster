//
//  Model.swift
//  Roster
//
//  Created by Shu-Mei Cheng on 1/20/17.
//  Copyright © 2017 Shu-Mei Cheng. All rights reserved.
//

import Foundation
import CloudKit
import RealmSwift

class Model {
    let publicDB = CKContainer.default().publicCloudDatabase
    let realm : Realm = try! Realm()
    
    func saveDB()
    {
       // let classes = realm.objects(Classes.self)
        let classList = realm.objects(Classes.self).first
        
        for aclass in (classList?.classes)! {
            print (aclass.name)
            if(aclass.name.isEmpty){ // bad data
                continue
            }
            
            var studentIds = [CKRecordID]()

            let classId = CKRecordID(recordName: aclass.name)
            let aClass = CKRecord(recordType: "ClassItem", recordID: classId)
            
            aClass.setObject(aclass.name as CKRecordValue?, forKey: "ClassName")
            
            // aClass new or existing one
            
            aClass.setObject(studentIds as CKRecordValue?, forKey: "StudentNames")
            let persons = aclass.persons
            for aperson in persons {
                let id = CKRecordID(recordName: aperson.name)
                let aName = CKRecord(recordType: "StudentName", recordID: id)

                //let studentNameId = CKRecordID(recordName: aperson.name)
                studentIds.append(id) // reference list
                
                let firstName = aperson.name.components(separatedBy: " ")[0]
                let lastName = aperson.name.components(separatedBy: " ")[1]
                aName.setObject(firstName as CKRecordValue, forKey:
                "FirstName")
                aName.setObject(lastName as CKRecordValue, forKey: "LastName")
                
                publicDB.save(aName, completionHandler: {
                    (record,error) in
                    guard (error == nil) else {
                        print(error!)
                        return
                    }
                    
                })

            }
            publicDB.save(aClass, completionHandler: {
                (record,error) in
                guard (error == nil) else {
                    print(error!)
                    return
                }
            })
            
        }
        
        checkDB()
    }
    
    func checkDB(){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "ClassItem", predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil, completionHandler: { (records,error) in
            guard (error == nil) else {
                print (error!)
                return
            }
            if(records?.count == 0 ){
                return
            }
            for r in records! {
                let className = r.object(forKey: "ClassName") as! String
                let ids = r.object(forKey: "StudentNames") as! [CKRecordID]
                print(className)
                for id in ids {
                    self.publicDB.fetch(withRecordID: id, completionHandler: {
                        (student,error) in
                        guard( error == nil) else {
                            print(error!)
                            return
                        }
                        let firstName = student?.object(forKey: "FirstName") as! String
                        let lastName = student?.object(forKey: "LastName") as! String
                        print (firstName, lastName)
                    })
                }
            }
        })
        
    }
    
}
