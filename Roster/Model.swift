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
   
    
    func saveDB()
    {
         let realm = try! Realm()
        
     // let classes = realm.objects(Classes.self)
        
        let classList = realm.objects(Classes.self).first
        for aclass in (classList?.classes)! {
            if(aclass.name.isEmpty){
                continue
            }
            //print(aclass.name)
            let persons = aclass.persons
            var studentIds = [CKReference]()
            for person in persons {
               // print(person.name)
                let id = CKRecordID(recordName: person.name)
                let firstName = person.name.components(separatedBy: " ")[0]
                var lastName: String?
                if(person.name.components(separatedBy: " ").count > 1){
                    lastName = person.name.components(separatedBy: " ")[1]
                }else{
                    lastName = "empty"
                }

                var aNameRecord: CKRecord?
                self.publicDB.fetch(withRecordID: id, completionHandler: {
                    (record,error) in
                    guard(error == nil) else {
                        //print(error)
                        aNameRecord = CKRecord(recordType: "Student", recordID: id)
                        aNameRecord?.setObject(firstName as CKRecordValue, forKey:
                            "FirstName")
                        aNameRecord?.setObject(lastName as? CKRecordValue, forKey: "LastName")
                        self.publicDB.save(aNameRecord!, completionHandler: {
                            (record:CKRecord?,error:Error?) in
                            guard(error == nil) else {
                                print(error!)
                                return
                            }
                        } )

                        return
                    }
                    aNameRecord = record
                    let reference = CKReference(recordID: id, action: .deleteSelf)
                    studentIds.append(reference )
                })
                
            }
            
            let classId = CKRecordID(recordName: aclass.name)
            var aClass: CKRecord?
            let className =  aclass.name
            self.publicDB.fetch(withRecordID: classId, completionHandler: {(classRecord,error) in
                guard(error == nil) else {
                    //print(error!)
                    aClass = CKRecord(recordType: "Classes", recordID: classId)
                    aClass?.setObject(className as CKRecordValue? , forKey: "ClassName")
                    // setup student list and save the record
                    self.saveTheClass(aClass: aClass!,studentIds: studentIds)
                    return
                }
                aClass = classRecord
                self.saveTheClass(aClass: aClass!,studentIds: studentIds)


            })
            
        }
      
 
         //checkDB()
    }
    func saveTheClass(aClass: CKRecord, studentIds: [CKReference])
    {
        aClass.setObject(studentIds as CKRecordValue?, forKey: "Students")
        self.publicDB.save(aClass, completionHandler: {
            (record,error) in
            guard (error == nil) else{
                print(error!)
                return
            }
        })
        

    }
    func checkDB(){
        let predicate = NSPredicate(value:true)
        let query = CKQuery(recordType: "Classes", predicate: predicate)
        publicDB.perform(query, inZoneWith: nil, completionHandler: { (records:[CKRecord]?,error:Error?) in
            guard (error == nil) else {
                print (error!)
                return
            }
            if(records?.count == 0 ){
                return
            }
            for r in records! {
                let className = r.object(forKey: "ClassName") as! String
                let aNames = r.object(forKey: "Students") as! [CKReference]
                print(className)
                for aName in aNames {
                    self.publicDB.fetch(withRecordID: aName.recordID, completionHandler: {
                        (record,error) in
                        guard(error == nil) else {
                            //print(error)
                            return
                        }
                        
                        let firstName = record?.object(forKey: "FirstName") as! String
                        let lastName = record?.object(forKey: "LastName") as! String
                        print (firstName, lastName)

                    })
                   
                }
            }
        } )
    }
    
}
