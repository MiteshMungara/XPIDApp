//
//  ConfirmVC.swift
//  XPIDApp WatchKit Extension
//
//  Created by Mits on 7/20/18.
//  Copyright © 2018 MitTech. All rights reserved.
//


import WatchKit
import Foundation


class ConfirmVC: WKInterfaceController {
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
        // Configure interface objects here.
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
//    @IBAction func btnFindLocation()
//    {
//
//
//    }
//
//    func displayLocation(placemark:CLPlacemark)
//    {
//
//    }
//
//    @IBAction func enrterLocationBtnPressed(sender:Any)
//    {
//        self.pushController(withName: "Location", context: self)
//    }
    
    @IBAction func submitBtnPressed(sender:Any)
    {
        self.pushController(withName: "Location", context: self)
    }
    
    
    @IBAction func postXPChanged(_ sender: Any) {
        // label.text = "\(currentValue)s"
        
  
    }
    
}
