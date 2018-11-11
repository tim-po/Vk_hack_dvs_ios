//
//  MapScrolViewController.swift
//  tests
//
//  Created by Тимофей on 09/11/2018.
//  Copyright © 2018 Тимофей. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol NumPadDelegate {
    func didTapButton(button: NamedButton)
}

class MapScrolViewController: UIViewController, NumPadDelegate {
    
    let icons = ["misk" : #imageLiteral(resourceName: "misk"), "Бар": #imageLiteral(resourceName: "bar"), "выставка" : #imageLiteral(resourceName: "exebition"), "стритфуд": #imageLiteral(resourceName: "foodPlace")]
    let texts = ["детская площадка": "Здесь можно гулять с детьми", "parking": "парковка для машин"]
    
    var popoverMaxHeigth = 128
    
    func didTapButton(button: NamedButton) {
        if let place = places[button.name]{
            popoverMaxHeigth = 400
            popoverLable.text = place.name
            popoverIcon.image = icons[place.category]
            popoverIcon.layer.cornerRadius = 15
            popoverIcon.clipsToBounds = true
            let url = URL(string: "http://46.21.249.26:8000/places/descriptions/\(place.description)")
            let request = URLRequest(url: url!)
            popoverWebView.loadRequest(request)
            cofigurePopover()
        }
        else if button.name == "детская площадка" || button.name == "parking" {
            popoverLable.text = texts[button.name]
            popoverMaxHeigth = 128
            cofigurePopover()
            popoverLable.frame.size.width = popover.frame.width - 16
            popoverLable.center.x = popover.center.x
            popoverLable.textAlignment = .center
            popoverIcon.image = nil
        }
        UIView.animate(withDuration: 0.5) {
            self.popover.center.y = self.view.frame.height - self.popover.frame.height/2 - 48
        }
    }
    
    var places: [String: Place] = [:]
    
    func loadCafesFromBackend(){
        Alamofire.request("http://46.21.249.26:8000/places").responseJSON{
            response in
            
            if let json = response.result.value {
                let places = json as! [[String: Any]]
                
                for place in places{
                    let _place = Place(withDict: place)
                    self.places[_place.name] = _place
                }
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
    

    @IBOutlet weak var popover: UIView!
    @IBOutlet weak var popoverLable: UILabel!
    @IBOutlet weak var popoverIcon: UIImageView!
    @IBOutlet weak var popoverTextfield: UITextView!
    
    @IBOutlet weak var popoverWebView: UIWebView!
    
    var needToShowPopower = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var MapContainerView: UIView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    
    @IBAction func panned(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        UIView.animate(withDuration: 0.1) {
            self.popoverWebView.frame.size.height = self.popover.frame.height - 128
            if self.popover.frame.size.height - translation.y < 128 && self.popover.frame.size.height - translation.y > 120{
                self.popover.frame.size.height = 128
            }
            else if self.popover.frame.size.height - translation.y < 120{
                self.cofigurePopover()
            }
            else if Int(self.popover.frame.size.height) > self.popoverMaxHeigth{
                self.popover.frame.size.height = CGFloat(self.popoverMaxHeigth)
                self.popover.center.y -= translation.y - 1
            }
            else{
                self.popover.center.y += translation.y
                self.popover.frame.size.height -= translation.y
            }
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func cofigurePopover(){
        popoverIcon.clipsToBounds = true
        popoverIcon.layer.cornerRadius = 10
        
        popoverWebView.frame.size.height = 0
        popoverWebView.frame.size.width = popover.frame.width - 16
        popoverWebView.center.y = 120
        popoverWebView.center.x = popover.center.x - 8
        
        popoverLable.frame.size.width = popover.frame.width - popoverIcon.frame.width - 16 - 8
        popoverLable.frame.origin.x = 8 + popoverIcon.frame.width + 8
        
        popover.frame.size.width = self.view.frame.width - 16
        popover.frame.size.height = 128
        popover.center = self.view.center
        popover.center.y = self.view.center.y + self.view.frame.height/2 + popover.frame.height/2
        popover.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        popover.layer.cornerRadius = 10
        popover.layer.shadowOpacity = 1
        popover.layer.shadowOffset = CGSize.zero
        popover.layer.shadowRadius = 5
    }
    
    override func viewDidLoad() {
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 0.1
        cofigurePopover()
        loadCafesFromBackend()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }
    
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / MapContainerView.bounds.width
        let heightScale = size.height / MapContainerView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destanation_vc = segue.destination as! MapContainerViewController
        destanation_vc.delegate = self
    }
    
}

extension MapScrolViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return MapContainerView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
    
    fileprivate func updateConstraintsForSize(_ size: CGSize) {
        
        let yOffset = max(0, (size.height - MapContainerView.frame.height) / 2)
        MapContainerView.center.y = yOffset
        
        let xOffset = max(0, (size.width - MapContainerView.frame.width) / 2)
        MapContainerView.center.x = xOffset
        
        view.layoutIfNeeded()
    }
}
