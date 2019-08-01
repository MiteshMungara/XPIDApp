//
//  OverAllSatisfactionController.swift
//  XPIDApp
//
//  Created by Mits on 7/6/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

import WatchKit
import Foundation


class OverAllSatisfactionController: WKInterfaceController {
    
    @IBOutlet var oneRatButton:WKInterfaceButton!
    @IBOutlet var twoRatButton:WKInterfaceButton!
    @IBOutlet var threeRatButton:WKInterfaceButton!
    @IBOutlet var fourRatButton:WKInterfaceButton!
    @IBOutlet var fiveRatButton:WKInterfaceButton!
    
    
    
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

    @IBAction func oneRateVBtnPressed(sender:Any)
    {
        UserDefaults.standard.set("1", forKey: "xp")
        self.pushController(withName: "NPSVC", context: self)
    }
    
    @IBAction func twoRateVBtnPressed(sender:Any)
    {
        
        UserDefaults.standard.set("2", forKey: "xp")
        self.pushController(withName: "NPSVC", context: self)
    }
    
    
    @IBAction func threeRateVBtnPressed(sender:Any)
    {
        
        UserDefaults.standard.set("3", forKey: "xp")
        self.pushController(withName: "NPSVC", context: self)
    }
    
    @IBAction func fourRateVBtnPressed(sender:Any)
    {
        UserDefaults.standard.set("4", forKey: "xp")
        self.pushController(withName: "NPSVC", context: self)
    }
    
    
    @IBAction func fiveRateVBtnPressed(sender:Any)
    {
        UserDefaults.standard.set("5", forKey: "xp")
        self.pushController(withName: "NPSVC", context: self)
    }
}
//NPSController
/*
 //
 //  NPSController.swift
 //  XPIDApp WatchKit Extension
 //
 //  Created by Mits on 7/6/18.
 //  Copyright © 2018 MitTech. All rights reserved.
 //
 import WatchKit
 import Foundation
 
 
 class NPSController: WKInterfaceController {
 
 override func willActivate() {
 // This method is called when watch view controller is about to be visible to user
 super.willActivate()
 }
 
 override func didDeactivate() {
 // This method is called when watch view controller is no longer visible
 super.didDeactivate()
 }
 
 
 @IBAction func OneNPSBtnPressed(sender:Any)
 {
 self.pushController(withName: "VoiceReviewVC", context: self)
 }
 
 @IBAction func TwoNPSBtnPressed(sender:Any)
 {
 self.pushController(withName: "VoiceReviewVC", context: self)
 }
 
 @IBAction func ThreeNPSBtnPressed(sender:Any)
 {
 self.pushController(withName: "VoiceReviewVC", context: self)
 }
 
 @IBAction func FourNPSBtnPressed(sender:Any)
 {
 self.pushController(withName: "VoiceReviewVC", context: self)
 }
 
 @IBAction func FiveNPSBtnPressed(sender:Any)
 {
 self.pushController(withName: "VoiceReviewVC", context: self)
 }
 
 
 }

 */
