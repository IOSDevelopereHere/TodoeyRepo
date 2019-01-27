//
//  Category.swift
//  Todoey
//
//  Created by Reactive Space on 24/01/2019.
//  Copyright © 2019 Reactive Space. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    
    
    //  creating a forward category, a list of items to create relationship
    let items = List<Item>()
}
