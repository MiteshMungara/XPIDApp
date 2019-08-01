//
//  ConnectToIphoneVC.swift
//  XPIDApp WatchKit Extension
//
//  Created by Mits on 10/19/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

import UIKit
import WatchKit
import Foundation
import CoreLocation

class ConnectToIphoneVC: WKInterfaceController {

    @IBOutlet var loader: WKInterfaceImage!
    @IBOutlet weak var lblTopHeader : WKInterfaceLabel!
   // @IBOutlet weak var lblinfo : WKInterfaceLabel!
    @IBOutlet weak var ConnectButton : WKInterfaceButton!
    
    
    @IBOutlet weak var lblcode : WKInterfaceLabel!
    @IBOutlet weak var lblLatitude : WKInterfaceLabel!
    @IBOutlet weak var lbllongitude : WKInterfaceLabel!
    
    @IBOutlet weak var micButton : WKInterfaceButton!
    
    
    var activity : UIImage!
    var codeStr : String = ""
    var activeStr : String = ""
    var voicestring : String = ""
    var watchdeleteidstring : String = ""
    
    func connectShow()
    {
        lblTopHeader.setHidden(false)
        lblcode.setHidden(false)
        ConnectButton.setHidden(false)
        micButton.setHidden(false)
    }
    
    func connectHide()
    {
        lblTopHeader.setHidden(true)
        lblcode.setHidden(true)
        ConnectButton.setHidden(true)
        micButton.setHidden(true)
    }
    
    func showLoader() {
        self.setLoader(hidden: false)
        loader.setImageNamed("loader")
        loader.startAnimatingWithImages(in: NSRange(location: 1,
                                                    length: 8), duration: 0.8, repeatCount: -1)
    }
    
    func stopLoader() {
        self.loader.stopAnimating()
        self.setLoader(hidden: true)
    }
    
    private func setLoader(hidden:Bool) {
        self.loader.setHidden(hidden)
        //  self.button.setHidden(!hidden)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
  
    }
    
    
    @IBAction func MicBtnPressed(sender:Any)
    {
        self.presentTextInputController(withSuggestions: ["Your voice converted to text"], allowedInputMode: .plain) { (args) in
            
            let (answers) = args as! NSArray
            if (answers != nil) && answers.count > 0 {
                // if let answer = answers[0] as? String ?? [0]{
                print(answers[0])
                self.voicestring = answers[0] as! String
                let scretecodestring = String(format: "Enter code in iphone:%@", self.voicestring)
                self.lblcode.setText(scretecodestring)
                //self.voiceLabel.setText(answers[0] as! String)
                // }
            }
        }
        //        self.pushController(withName: "ConfirmVC", context: self)
    }
    
    
    func activityIndicator()
    {
        var activity : WKInterfaceImage!
        for i in 0..<10
        {
            let image = String(format: "activity%d", i)
           // activity = UIImage(named: image)
            if i == 10
            {
                activityIndicator()
            }
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        print(codeStr)
        connectShow()
      //  codeStr = UserDefaults.standard.string(forKey: "code")!
        //MicBtnPressed()
      
        
//        UserDefaults.standard.set(code, forKey: "code")
//        UserDefaults.standard.set(active, forKey: "activa_code")
        print(lblcode)
    }
    
    func confirmiphone()
    {
        connectHide()
        //  let url = NSURL(string: "http://techspak.com/xpidapp/app/connectapplewatch.php")
        self.showLoader()
        let request = NSMutableURLRequest(url: NSURL(string: "http://xpid.me/app/getconfirmiphone.php")! as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        let params = ["code":self.voicestring,"deivce":"watch"] as Dictionary<String, String>
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            //print("Response: \(response)")
            
            //            let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //            print("Body: \(strData)")
            
            if error != nil
            {
                print("Error: " + error.debugDescription)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                print(json)
                let success = json!["Success"] as? String
                if success == "1"
                {
                    
                    let code = json!["secret_code"] as? String
                    let active = json!["is_active"] as? String
                    let iphone_active = json!["iphone_active"] as? String
                    let uid = json!["u_id"] as? String
                    let email = json!["u_email"] as? String
                    let username = json!["u_username"] as? String
                    self.watchdeleteidstring = json!["u_id"] as? String ?? ""
                    
                    self.deletewatchid()
                    UserDefaults.standard.set(uid, forKey: "uid")
                    //Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(), userInfo: nil, repeats: false)
                    //deletewatchid
                    UserDefaults.standard.set(username, forKey: "username")
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(active, forKey: "active_code")
                    UserDefaults.standard.set(code, forKey: "code")
                    UserDefaults.standard.set(iphone_active, forKey: "iphone_active")
                   // if(iphone_active == "1")
                    //{
                          self.pushController(withName: "Location", context: self)
                       // self.pushController(withName: "LoginCompleteVC", context: self)
                   // }
                    
                    
                }
            } catch {
                print(error.localizedDescription)
            }
            self.stopLoader()
            self.connectShow()
        })
        
        task.resume()
        
        
    }
    
    
    @objc func deletewatchid()
    {
        let request = NSMutableURLRequest(url: NSURL(string: "http://xpid.me/app/deletewatchid.php")! as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        let params = ["id":self.watchdeleteidstring] as Dictionary<String, String>
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            //print("Response: \(response)")
            
            //            let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //            print("Body: \(strData)")
            
            if error != nil
            {
                print("Error: " + error.debugDescription)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                print(json)
                let success = json!["Success"] as? String
                if success == "1"
                {
                   
                    
                }
            } catch {
                print(error.localizedDescription)
            }
        })
        
        task.resume()
        
        
    }
    
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    @IBAction func continueverifyBtnPressed(sender:Any)
    {
        confirmiphone()
    }
}
