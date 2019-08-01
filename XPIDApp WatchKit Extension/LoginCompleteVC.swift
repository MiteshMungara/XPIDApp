//
//  LoginCompleteVC.swift
//  XPIDApp WatchKit Extension
//
//  Created by Mits on 10/19/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

import UIKit
import WatchKit
import Foundation
import CoreLocation



class LoginCompleteVC: WKInterfaceController {

    var activecodeidentify = ""
    var onepin = ""
    var twopin = ""
    var threepin = ""
    var fourpin = ""
    
    @IBOutlet var onebtn : WKInterfaceButton!
    @IBOutlet var twobtn : WKInterfaceButton!
    @IBOutlet var threebtn : WKInterfaceButton!
    @IBOutlet var fourbtn : WKInterfaceButton!
    
     
    var pinarr = [String]()
    var active : Bool = false
    
    
    
    
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        //    UserDefaults.standard.set(active, forKey: "activa_code")
        let code = UserDefaults.standard.string(forKey: "active_code")
        print(code)
        activecodeidentify = (UserDefaults.standard.object(forKey: "activa_code") as? String)!
        onepin = generateRandomDigits(4)
        twopin = generateRandomDigits(4)
        threepin = generateRandomDigits(4)
        fourpin = generateRandomDigits(4)
        
        pinarr = [activecodeidentify,twopin,threepin,fourpin]
      //  pinarr.shuffle()
         print(pinarr)
        
        onepin = (pinarr[0] as? String)!
        twopin = (pinarr[1] as? String)!
        threepin = (pinarr[2] as? String)!
        fourpin = (pinarr[3] as? String)!

        onebtn.setTitle(onepin)
        twobtn.setTitle(twopin)
          threebtn.setTitle(threepin)
          fourbtn.setTitle(fourpin)
//        threepinactivebtn.setTitle("sfsdf")
//        fourpinactivebtn.setTitle("sdf")
        
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func onepinBtnPressed(sender:Any)
    {
        print(activecodeidentify)
        print(onepin)
        if activecodeidentify == onepin
        {
            UserDefaults.standard.set("1", forKey: "login")
            self.pushController(withName: "Location", context: self)
        }
        else
        {
            self.pushController(withName: "ConnectToIphoneVC", context: self)
        }
    }
    
    @IBAction func twopinBtnPressed(sender:Any)
    {
        print(activecodeidentify)
        print(twopin)
        if activecodeidentify == twopin
        {
            UserDefaults.standard.set("1", forKey: "login")
            self.pushController(withName: "Location", context: self)
        }
        else
        {
            self.pushController(withName: "ConnectToIphoneVC", context: self)
        }
    }
    
    @IBAction func threepinBtnPressed(sender:Any)
    {
        print(activecodeidentify)
        print(threepin)
        if activecodeidentify == threepin
        {
            UserDefaults.standard.set("1", forKey: "login")
            self.pushController(withName: "Location", context: self)
        }
        else
        {
            UserDefaults.standard.set("1", forKey: "login")
            self.pushController(withName: "ConnectToIphoneVC", context: self)
        }
    }
    
    @IBAction func fourpinBtnPressed(sender:Any)
    {
        print(activecodeidentify)
        print(fourpin)
        if activecodeidentify == fourpin
        {
            self.pushController(withName: "Location", context: self)
        }
        else
        {
            self.pushController(withName: "ConnectToIphoneVC", context: self)
        }
    }
    
    
    func generateRandomDigits(_ digitNumber: Int) -> String {
        var number = ""
        for i in 0..<digitNumber {
            var randomNumber = arc4random_uniform(10)
            while randomNumber == 0 && i == 0 {
                randomNumber = arc4random_uniform(10)
            }
            number += "\(randomNumber)"
        }
        return number
    }
}
