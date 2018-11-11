//
//  CafeListViev.swift
//  
//
//  Created by Тимофей on 25/08/2018.
//

import Foundation
import UIKit
import PureLayout
import Alamofire

class CafeListView: UIScrollView {
    
    weak var segueDelegate: CafeListSegueDelegate?
    
    init(frame: CGRect, list: [[String: Any]]) {
        cafeList = list
        super.init(frame: frame)
        print("cafelist: \(cafeList)")
        updateModel(with: cafeList)
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder, list: [[String: Any]]) {
        cafeList = list
        super.init(coder: aDecoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        cafeList = []
        super.init(coder: aDecoder)
    }
    
    var cafeList: [[String: Any]]
    
    var imageList: [String:UIImage] = [:]{
        didSet{
//            updateInfo()
        }
    }
    
    var curentPhotoToWorkWith: UIImage = #imageLiteral(resourceName: "misk")
    
    func loadImage(fromURL URL: String, completion : ()->()){
        Alamofire.request("http://46.21.249.26:8000\(URL)").responseData { (response) in
            if response.error == nil {
                print(response.result)
                
                if let data = response.data {
                    let photo = UIImage(data: data)
                    self.curentPhotoToWorkWith = photo!
                }
            }
        }
        completion()
    }


    var verticalMenuScrolViewsArray: [UIView]! = []
    
    var nextY = 72
    
//    var containerViewDict: [Int:UIView] = [:]
    
    @objc func menuItemButtonAction(sender: IdentifibleButton!){
        let view = self.subviews[sender.identifire]
        let image = view.subviews[2]
        
        if !sender.flag {
            UIView.animate(withDuration: 0.1) {
                image.frame.size.width *= 3
                image.frame.size.height *= 3
                image.center.x = view.center.x - 8
                image.center.y = 250
                sender.frame.size = image.frame.size
                sender.center = image.center
                sender.flag = true
                for view in view.subviews{
                    if view != image{
                        view.layer.opacity -= 0.4
                    }
                }
                
            }
        }
        else{
            UIView.animate(withDuration: 0.1) {
                image.frame.size.width /= 3
                image.frame.size.height /= 3
                image.center.y = 128/2
                image.center.x = 128/2
                sender.frame.size = image.frame.size
                sender.center = image.center
                sender.flag = false
                for view in view.subviews{
                    if view != image{
                        view.layer.opacity += 0.4
                    }
                }
            }
        }
    }
    
    func updateModel(with cafeList: [[String: Any]], imagesNeedToBeUpdated updateImages: Bool = false){
        
        // composing container view array
        for i in 0..<Int(cafeList.count){
            
            // container view
            let containerViewSize = CGSize.init(width: self.frame.width - 16, height: 500)
            let containerViewframe = CGRect.init(origin: CGPoint.init(x: 8, y: nextY), size: containerViewSize)
            let containerView = UIView(frame: containerViewframe)
            containerView.backgroundColor = #colorLiteral(red: 0.9483264594, green: 0.9483264594, blue: 0.9483264594, alpha: 1)
            containerView.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            containerView.layer.cornerRadius = 10
            containerView.layer.shadowOpacity = 1
            containerView.layer.shadowOffset = CGSize.zero
            containerView.layer.shadowRadius = 5
            
            
            // list item image
            let menueItemImageSize = CGSize(width: 128, height: 128)
            let menueItemImageFrame = CGRect(origin: CGPoint.init(x: 0, y: nextY), size: menueItemImageSize)
            let menueItemImage = UIImageView(frame: menueItemImageFrame)
            let Url = (cafeList[i]["photos"] as! [[String: Any?]])[0]["image"] as! String
            Alamofire.request("http://46.21.249.26:8000\(Url)").responseData { (response) in
                if response.error == nil {
                    print(response.result)
                    
                    if let data = response.data {
                        let photo = UIImage(data: data)
                        menueItemImage.image = photo!
                    }
                }
            }
            menueItemImage.image = curentPhotoToWorkWith
            menueItemImage.layer.cornerRadius = 15
            menueItemImage.clipsToBounds = true
            
            // Menue item button
            let menueItemButton = IdentifibleButton(withIdentifire: i, frame: menueItemImageFrame)
            menueItemButton.addTarget(self, action: #selector(self.menuItemButtonAction), for: .touchUpInside)
            
            // Menue item lable
            let menueItemLableSize = CGSize.init(width: 157, height: 128 - 32)
            let menueItemLableFrame = CGRect.init(origin: CGPoint(x: 136, y: 10), size: menueItemLableSize)
            let menueItemLable = UILabel(frame: menueItemLableFrame)
            menueItemLable.text = cafeList[i]["name"] as? String
            menueItemLable.numberOfLines = 3
            
            //Menue item textfield
            let textfieldSize = CGSize.init(width: containerViewframe.width - 32, height: containerViewframe.height - menueItemImageFrame.height - 32)
            let textfieldFrame = CGRect.init(origin: CGPoint(x: 16, y: menueItemImageFrame.height + 16), size: textfieldSize)
            let textfield = UITextView(frame: textfieldFrame)
            textfield.font = UIFont(name: "System", size: 24)
            textfield.text = cafeList[i]["content"] as? String
            textfield.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            textfield.layer.cornerRadius = 10
            textfield.layer.shadowOpacity = 1
            textfield.layer.shadowOffset = CGSize.zero
            textfield.layer.shadowRadius = 5
            

            // Composing everithing in on menue item container view
            containerView.addSubview(menueItemLable)
            containerView.addSubview(textfield)
            containerView.addSubview(menueItemImage)
            containerView.addSubview(menueItemButton)
            
            // Autolayout
            
            // Menue item button edges
            menueItemButton.autoPinEdge(.top, to: .top, of: containerView)
            menueItemButton.autoPinEdge(.leading, to: .leading, of: containerView)
            // Menue item button dimentions
            menueItemButton.autoSetDimensions(to: menueItemImageSize)
            
            // Menue item lable edges
            menueItemLable.autoPinEdge(.top, to: .top, of: containerView, withOffset: 16)
            menueItemLable.autoPinEdge(.leading, to: .leading, of: containerView, withOffset: 136)
            // Menue item lable dimentions
            menueItemLable.autoSetDimensions(to: menueItemLableSize)
            
            //textfield
            textfield.autoPinEdge(.top, to: .bottom, of: menueItemImage, withOffset: 16)
            textfield.autoPinEdge(.bottom, to: .bottom, of: containerView, withOffset: -16)
            textfield.autoPinEdge(.leading, to: .leading, of: containerView, withOffset: 16)
            textfield.autoPinEdge(.trailing, to: .trailing, of: containerView, withOffset: -16)
            
            // Menue item image edges
            menueItemImage.autoPinEdge(.top, to: .top, of: containerView)
            menueItemImage.autoPinEdge(.leading, to: .leading, of: containerView)
            // Menue item image dimensions
            menueItemImage.autoSetDimensions(to: menueItemImageSize)

            verticalMenuScrolViewsArray.append(containerView)
            
            nextY += 560
        }
        print("model Updated")
    }
    
    func updateView(){
        
        var nextTopY = 8
        var vievIterator = 1
        let numberOfViews = verticalMenuScrolViewsArray.count
        let standartOfset = 16
        let bottomofset = -150
        
        for view in verticalMenuScrolViewsArray{
            let multiplayer = vievIterator - numberOfViews
            let nextBottomY = (Int(view.frame.height) + standartOfset) * multiplayer + bottomofset
            
            self.addSubview(view)
            
            //autolayaut
            //dimensions
            view.autoSetDimensions(to: CGSize(width: self.frame.width - 16, height: 500))
            //            view.addConstraint(NSLayoutConstraint(item: view.frame, attribute: .width, relatedBy: .equal, toItem: self.frame, attribute: .width, multiplier: 1, constant: 0))
            //            view.addConstraint(NSLayoutConstraint(item: view.frame, attribute: .height, relatedBy: .equal, toItem: self.frame, attribute: .height, multiplier: 1, constant: 0))
            //edjes
            view.autoPinEdge(.top, to: .top, of: self, withOffset: CGFloat(nextTopY))
            view.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: CGFloat(nextBottomY))
            view.autoPinEdge(.leading, to: .leading, of: self, withOffset: 8)
            view.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -8)
            
            nextTopY += 500 + standartOfset
            vievIterator+=1
        }
        print("view Updated")
    }
    
    func updateInfo(){
        for view in self.subviews{
            print(view.subviews)
        }
    }
    
}

protocol CafeListSegueDelegate: class {
    func onButtonTapped(button: UIButton)
}

//extension UIButton{
//    var identifire: Int?
//}



