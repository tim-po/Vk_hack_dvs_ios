//
//  Place.swift
//  Alamofire
//
//  Created by Тимофей on 10/11/2018.
//

import Foundation
import UIKit

class Place{
    var name: String
    
    var description: String
    
    var category: String
    
    init(withName name: String, withDescription description: String, withCategory category: String) {
        self.name = name
        self.description = description
        self.category = category
    }
    
    init(withDict dict: [String: Any?]) {
        self.name = dict["name"] as! String
        self.description = String(dict["description"] as! Int)
        self.category = dict["category"] as! String
    }
}
