//
//  Person.swift
//  Roster
//
//  Created by Shu-Mei Cheng on 11/3/16.
//  Copyright © 2016 Shu-Mei Cheng. All rights reserved.
//

import Foundation
import RealmSwift

class Person: Object {
    dynamic var name : String = ""
    let classes = LinkingObjects(fromType: Class.self, property: "persons")
    let dates = List<MyDate>()
}

