//
//  Date.swift
//  Roster
//
//  Created by Shu-Mei Cheng on 11/6/16.
//  Copyright © 2016 Shu-Mei Cheng. All rights reserved.
//

import Foundation
import RealmSwift
class MyDate: Object {
    dynamic var theDate = Date()
    let classes = LinkingObjects(fromType: Class.self, property: "dates")
    let persons = LinkingObjects(fromType: Person.self, property: "dates")
}
