//
//  Class.swift
//  Roster
//
//  Created by Shu-Mei Cheng on 11/6/16.
//  Copyright © 2016 Shu-Mei Cheng. All rights reserved.
//

import Foundation
import RealmSwift

class Class: Object {
    dynamic var name: String = ""
    let persons = List<Person>()
    let dates = List<Date>()
}
