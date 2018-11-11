//
//  News.swift
//  tests
//
//  Created by Тимофей on 10/11/2018.
//  Copyright © 2018 Тимофей. All rights reserved.
//

import Foundation
import UIKit

class News{
    var name: String
    var content: String
    
    init(withName name: String, withContent content: String) {
        self.name = name
        self.content = content
    }
    
    init(withArray array: [String: Any?]) {
        self.name = array["name"] as! String
        self.content = array["content"] as! String
    }
}
