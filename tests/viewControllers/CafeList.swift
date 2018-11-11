//
//  CafeList.swift
//  S_soboy
//
//  Created by Тимофей on 24/08/2018.
//  Copyright © 2018 Тимофей. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SQLite3

class MapTolistViewController: UIViewController, CafeListSegueDelegate{
    var cafeId = "0"
    
    @IBOutlet weak var mainScrolView: CafeListView!
    
    func onButtonTapped(button: UIButton) {
        cafeId = button.currentTitle!
        
        performSegue(withIdentifier: "cafeMenueSegue", sender: nil)
    }
    
    
    var lightCafeArray: [[String: Any]] = []
    
    var profile: CafeListView!
    
    var cafeList: [News] = []
    
    var imageList: [String: UIImage] = [:]
    
//    func createPopular(from cafeLlist: [Cafe]) -> ArraySlice<Cafe>{
//
        // MARK: todo sort popular
//        let popular = cafeLlist
////            .sorted { (lhs: Cafe, rhs: Cafe) -> Bool in
////            // you can have additional code here
////            return lhs.rating < rhs.rating
////        }
////        let popular = _[...min(10, _.count)]
//        return popular.dropFirst(min(10, popular.count))
//    }
    
    func loadCafesFromBackend(){
        Alamofire.request("http://46.21.249.26:8000/news/").responseJSON{
            response in
            
            if let json = response.result.value {
                self.lightCafeArray = json as! [[String: Any]]
                self.profile = CafeListView(frame: self.mainScrolView.frame, list: self.lightCafeArray)
                for cafe in self.lightCafeArray{
                    self.cafeList.append(News(withArray: cafe))
                }
                self.view.addSubview(self.profile)
                self.profile.segueDelegate = self

            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCafesFromBackend()
        print("CafeList.viewDidLoad")
//        profile = CafeListView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: self.view.frame.size), list: lightCafeArray)
//        self.view.addSubview(profile)
    }
    
}

