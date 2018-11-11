//
//  MooringViewController.swift
//  tests
//
//  Created by Тимофей on 11/11/2018.
//  Copyright © 2018 Тимофей. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class MooringViewController: UIViewController {
    @IBOutlet var mooringButtons: [UIButton]!
    
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var dateTime: UIDatePicker!
    
    var selectedPlace: Int?{
        didSet{
            let button = self.mooringButtons[selectedPlace!]
            UIButton.animate(withDuration: 0.2,
                             animations: {
                                button.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)
            },
                             completion: { finish in
                                UIButton.animate(withDuration: 0.2, animations: {
                                    button.transform = CGAffineTransform.identity
                                })
            })
        }
    }
    
    var identifibleMooringbuttons: [IdentifibleButton] = []
    
    var bookAvalible = false{
        didSet{
            if bookAvalible{
                bookButton.layer.opacity += 0.4
            }
            else{
                bookButton.layer.opacity -= 0.4
            }
        }
    }
    
    @IBAction func checkAvalability(_ sender: UIButton) {
        checkAvelability()
    }
    @IBAction func book(_ sender: UIButton) {
        if bookAvalible{
            if identifibleMooringbuttons[selectedPlace!].backgroundColor == #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1){
                let dateAndTime = dateTime.date.description.split(separator: " ")
                let date = dateAndTime[0].split(separator: "-").joined(separator: ".")
                let dateFinish = "\(dateAndTime[0].split(separator: "-")[0]).\(dateAndTime[0].split(separator: "-")[1]).\(String(Int(dateAndTime[0].split(separator: "-")[1])! + 1))"
                
                let time = "\(dateAndTime[1].split(separator: ":")[0]):\(dateAndTime[1].split(separator: ":")[1])"
                let parameters2: Parameters = ["time_start": time, "date_start": date, "time_finish": time, "date_finish": dateFinish, "boat_name": "sirius", "mooring_id": selectedPlace]
                Alamofire.request("http://46.21.249.26:8000/cafes/create_order", method: .post, parameters: parameters2).responseJSON{
                    response in
                    if let json = response.result.value {
                        print(json)
                    }
                }
            }
            else{
                bookAvalible = false
            }
        }
    }
    
    @objc func mooringButtonAction(sender: IdentifibleButton){
        print(111111111111)
        selectedPlace = sender.identifire
        checkAvelability()
        if sender.backgroundColor == #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1){
            bookAvalible = true
        }
    }
    
    func checkAvelability(){
        let dateAndTime = dateTime.date.description.split(separator: " ")
        let date = dateAndTime[0].split(separator: "-").joined(separator: ".")
        let time = "\(dateAndTime[1].split(separator: ":")[0]):\(dateAndTime[1].split(separator: ":")[1])"
        Alamofire.request("http://46.21.249.26:8000/mooring_places/?time=\(time)&date=\(date)").responseJSON{
            response in
            
            if let json = response.result.value {
                let avalability = json as! [String: Bool]
                
                for i in 1...avalability.count{
                    if avalability[String(i)]!{
                        self.mooringButtons[i-1].backgroundColor = #colorLiteral(red: 0.9955437779, green: 0.8829300404, blue: 0.4963339567, alpha: 1)
                    }
                    else{
                        self.mooringButtons[i-1].backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
                    }
                }
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
    
    
    override func viewDidLoad() {
        var i = 0
        for button in mooringButtons{
            button.transform = CGAffineTransform(rotationAngle: CGFloat(9.92))
            button.layer.cornerRadius = 30
            identifibleMooringbuttons.append(IdentifibleButton(withIdentifire: i, frame: button.frame))
            i += 1
        }
        for button in identifibleMooringbuttons{
            button.addTarget(self, action: #selector(self.mooringButtonAction), for: .touchUpInside)
        }
    }
}
