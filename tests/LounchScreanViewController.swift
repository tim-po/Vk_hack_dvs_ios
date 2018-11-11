
//
//  LounchScreanViewController.swift
//  tests
//
//  Created by Тимофей on 10/11/2018.
//  Copyright © 2018 Тимофей. All rights reserved.
//

import Foundation
import UIKit

class LounchScreanViewController: UIViewController {
    @IBOutlet weak var wheel: UIImageView!
    
    override func viewDidLoad() {
        UIView.animate(withDuration: 2.0) {
            self.wheel.transform = CGAffineTransform(rotationAngle: CGFloat(1000))
        }
        performSegue(withIdentifier: "essentialSegue", sender: nil)
    }
}
