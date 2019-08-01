//
//  AppleWatchConnectVC.swift
//  XPIDApp
//
//  Created by Mits on 10/25/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import SwiftyJSON

class AppleWatchConnectVC: UIViewController {

    @IBOutlet var enterpinTextF:UITextField!
    @IBOutlet var appleWatchPinLabel:UILabel!
    var pinstr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func enterpinBtnPressed(_ sender: Any) {
        // label.text = "\(currentValue)"
        //        let emailvalid = isValidEmail(testStr: emailTextF.text!)
        //        let emailtest = emailTextF.text!
        //        let emailtrimmed = emailtest.trimmingCharacters(in: .whitespaces)
        
        let pintest = enterpinTextF.text!
        let pintrimmed = pintest.trimmingCharacters(in: .whitespaces)
        
        
        if pintrimmed.isEmpty
        {
            
            Toast.long(message:"Pin is required", success: "0", failer: "1")
        }
        else
        {
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(pingenerate), userInfo: nil, repeats: false)
        }
        
    }
    
    @objc func pingenerate()
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false

        let code = self.enterpinTextF.text!
        //Parameter
        let uid = UserDefaults.standard.string(forKey: "userid")!
        let parameters = ["date":"19-10-2018","iphone_active":"0","applewatch_active":"1","u_email":"","u_id":uid,"code":"\(code)","deivce":"iphone"] as Dictionary<String, String>
        //{"code":"19008","device":"iphone","u_id":"72","deivce":"iphone","applewatch_active":"1","date":"19-10-2018","iphone_active":"0","u_email":""}
        
        
       // let parameters = [
           // "code":"\(code)",
         //   "u_id":uid
          //  ] as [String : Any]  http://xpid.me/app/getconfirmiphone.php
        print(parameters)
        RequstJsonClass.sharedInstance.requestPOSTURL("getconfirmiphone.php", params: parameters as [String : AnyObject]?, headers: nil, view: self, success: { (json) in
            // success code
            print(json)
            //   let response = json as? NSDictionary
            let success = json["Success"].string
            if success == "1"
            {
                print(success)
                Toast.long(message: "Pin Generated Successfully", success: "1", failer: "0")
                
               // let is_active = json["is_active"].string
               // let message = String(format: "Your pin is %@", is_active!)
               // Toast.long(message:message , success: "1", failer: "0")
              //  self.appleWatchPinLabel.text = ""//message
            }
            else
            {
                Toast.long(message: "Pin is not found", success: "0", failer: "1")
            }
            self.view.isUserInteractionEnabled = true

            SVProgressHUD.dismiss()
        }, failure: { (error) in
            //error code
            self.view.isUserInteractionEnabled = true

            SVProgressHUD.dismiss()
            print(error)
        })
    }
    
    
    
    
    @IBAction func backBtnPressed(sender:Any)
    {
        self.dismiss(animated: false, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
