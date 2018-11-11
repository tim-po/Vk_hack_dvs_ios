
//
//  NamedButton.swift
//  tests
//
//  Created by Тимофей on 10/11/2018.
//  Copyright © 2018 Тимофей. All rights reserved.
//

import Foundation
import UIKit

class NamedButton: UIButton {
    var name = ""
    
    init(withName name: String, fromButton button: UIButton ){
        super.init(frame: button.frame)
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
