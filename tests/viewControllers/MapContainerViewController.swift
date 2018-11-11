
//
//  MapContainerViewController.swift
//  tests
//
//  Created by Тимофей on 09/11/2018.
//  Copyright © 2018 Тимофей. All rights reserved.
//

import Foundation
import UIKit


class MapContainerViewController: UIViewController {
    
    @IBOutlet weak var popoverView: UIView!
    
    var delegate: NumPadDelegate?
    

    @IBAction func tom(_ sender: UIButton) {
        let button = NamedButton(withName: "Выставка котов дяди Тома", fromButton: sender)
        buttonAction(button)
    }
    @IBAction func taco(_ sender: UIButton) {
        let button = NamedButton(withName: "Devil Taco", fromButton: sender)
        buttonAction(button)
    }
    @IBAction func burger(_ sender: UIButton) {
        let button = NamedButton(withName: "Meet Up Burgers", fromButton: sender)
        buttonAction(button)
    }
    @IBAction func beer(_ sender: UIButton) {
        let button = NamedButton(withName: "Пивмастерия 17М", fromButton: sender)
        buttonAction(button)
    }
    @IBAction func playground(_ sender: UIButton) {
        let button = NamedButton(withName: "детская площадка", fromButton: sender)
        buttonAction(button)
    }
    @IBAction func parking(_ sender: UIButton) {
        let button = NamedButton(withName: "parking", fromButton: sender)
        buttonAction(button)
    }
    
    @IBAction func hatter(_ sender: UIButton) {
        let button = NamedButton(withName: "Авторская выставка Александра Шляпика", fromButton: sender)
        buttonAction(button)
    }
    
    func buttonAction(_ button: NamedButton){
        delegate?.didTapButton(button: button)
    }
    
    override func viewDidLoad() {
    }
    
}
