//
//  IdentifibleButton.swift
//  S_soboy
//
//  Created by Тимофей on 20/09/2018.
//  Copyright © 2018 Тимофей. All rights reserved.
//

import UIKit

class IdentifibleButton: UIButton {
    
    var identifire: Int = 0
    var flag: Bool = false
    
    init(withIdentifire identifire: Int, frame: CGRect){
        self.identifire = identifire
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
