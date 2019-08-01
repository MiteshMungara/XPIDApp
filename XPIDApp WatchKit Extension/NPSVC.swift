//
//  NPSVC.swift
//  XPIDApp WatchKit Extension
//
//  Created by Mits on 7/20/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

import WatchKit
import Foundation

class NPSVC: WKInterfaceController {

    @IBOutlet var loader: WKInterfaceImage!
    
    @IBOutlet var firstGroup: WKInterfaceGroup!
    @IBOutlet var secondGroup: WKInterfaceGroup!
    @IBOutlet var TopHeaderlabel: WKInterfaceLabel!
    
    
//    override func awake(withContext context: Any?) {
//        super.awake(withContext: context)
//
//
//        // Configure interface objects here.
//    }
//
//    override func willActivate() {
//        // This method is called when watch view controller is about to be visible to user
//        super.willActivate()
//    }
//
//    override func didDeactivate() {
//        // This method is called when watch view controller is no longer visible
//        super.didDeactivate()
//    }
    
    func connectShow()
    {
        TopHeaderlabel.setHidden(false)
        secondGroup.setHidden(false)
        firstGroup.setHidden(false)
    }
    
    func connectHide()
    {
        TopHeaderlabel.setHidden(true)
        secondGroup.setHidden(true)
        firstGroup.setHidden(true)
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
        UserDefaults.standard.set("1", forKey: "familyxp")
        self.pushController(withName: "VoiceVC", context: self)
        //Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(postXP), userInfo: nil, repeats: false)
//        postXP()
        //    self.pushController(withName: "ConfirmVC", context: self)
    }
    
    
    @IBAction func TwoNPSBtnPressed(sender:Any)
    {
        UserDefaults.standard.set("2", forKey: "familyxp")
        self.pushController(withName: "VoiceVC", context: self)
        //Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(postXP), userInfo: nil, repeats: false)
      //  postXP()
        //    self.pushController(withName: "ConfirmVC", context: self)
    }
    
    @IBAction func ThreeNPSBtnPressed(sender:Any)
    {
        UserDefaults.standard.set("3", forKey: "familyxp")
        self.pushController(withName: "VoiceVC", context: self)
        //Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(postXP), userInfo: nil, repeats: false)
       // postXP()
        //    self.pushController(withName: "ConfirmVC", context: self)
    }
    
    @IBAction func FourNPSBtnPressed(sender:Any)
    {
        UserDefaults.standard.set("4", forKey: "familyxp")
        self.pushController(withName: "VoiceVC", context: self)
        //Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(postXP), userInfo: nil, repeats: false)
       // postXP()
        //    self.pushController(withName: "ConfirmVC", context: self)
    }
    
    @IBAction func FiveNPSBtnPressed(sender:Any)
    {
        UserDefaults.standard.set("5", forKey: "familyxp")
        self.pushController(withName: "VoiceVC", context: self)
        //Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(postXP), userInfo: nil, repeats: false)
        //postXP()
        //    self.pushController(withName: "ConfirmVC", context: self)
    }
    
    @IBAction func SixNPSBtnPressed(sender:Any)
    {
        UserDefaults.standard.set("6", forKey: "familyxp")
        self.pushController(withName: "VoiceVC", context: self)
        //Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(postXP), userInfo: nil, repeats: false)
        //postXP()
        //    self.pushController(withName: "ConfirmVC", context: self)
    }
    
    @IBAction func SevenNPSBtnPressed(sender:Any)
    {
        UserDefaults.standard.set("7", forKey: "familyxp")
        self.pushController(withName: "VoiceVC", context: self)
    
        //Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(postXP), userInfo: nil, repeats: false)
       // postXP()
        //    self.pushController(withName: "ConfirmVC", context: self)
        
    }
    
    @IBAction func EightNPSBtnPressed(sender:Any)
    {
        UserDefaults.standard.set("8", forKey: "familyxp")
        self.pushController(withName: "VoiceVC", context: self)
        //Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(postXP), userInfo: nil, repeats: false)
        //postXP()
        //    self.pushController(withName: "ConfirmVC", context: self)
    }
    
    @IBAction func NineNPSBtnPressed(sender:Any)
    {
        UserDefaults.standard.set("9", forKey: "familyxp")
        self.pushController(withName: "VoiceVC", context: self)
        //Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(postXP), userInfo: nil, repeats: false)
       // postXP()
        //    self.pushController(withName: "ConfirmVC", context: self)
    }
    
    
    @IBAction func TenNPSBtnPressed(sender:Any)
    {
        UserDefaults.standard.set("10", forKey: "familyxp")
        self.pushController(withName: "VoiceVC", context: self)
        //Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(postXP), userInfo: nil, repeats: false)
       // postXP()
        //    self.pushController(withName: "ConfirmVC", context: self)
    }
    
    
    @objc func postXP()
    {
        showLoader()
        connectHide()
        //Parameter
        let date = NSDate()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy";
        let currentDate = dateformatter.string(from: date as Date)//"12/02/2019"
        
        let lng =  UserDefaults.standard.string(forKey: "long")
        let lat =  UserDefaults.standard.string(forKey: "lat")
        let uname =  UserDefaults.standard.string(forKey: "email")
        let uid =  UserDefaults.standard.string(forKey: "uid")
        let satisfymyxp = UserDefaults.standard.string(forKey: "xp")
        let friendandfamilyxp = UserDefaults.standard.string(forKey: "familyxp")
        let descriptionXP = ""//UserDefaults.standard.string(forKey: "description")
        let imagevideoXP = UserDefaults.standard.string(forKey: "placeimage")
        
        var xp:Int = 0
        var family:Int = 0
        var dec:Int = 0
        var img:Int = 0
        if satisfymyxp != ""
        {
            xp = 2
        }
        if friendandfamilyxp != ""
        {
            family = 2
        }
        if descriptionXP != ""
        {
            dec = 2
        }
        if imagevideoXP != ""
        {
            img = 2
        }
        let totalXP =  xp+family+dec+img
        
        let placename = UserDefaults.standard.string(forKey: "placename")
        let address = UserDefaults.standard.string(forKey: "address")
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://xpid.me/app/postxp.php")! as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        let params = ["u_id":uid,"placename":placename,"xp_friend_family":friendandfamilyxp,"username":uname,"address":address,"city":"","state":"","country":"","satisfy_xp":satisfymyxp,"xp_description":descriptionXP,"long":lng,"lat":lat,"current_date":currentDate,"image":imagevideoXP,"ranking":String(format:"%d",totalXP),"points":String(format:"%d",totalXP)] as! Dictionary<String, String>
        print(params)
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
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
                    //let jsonDict = json!["post"] as? [String:AnyObject]
                    self.pushController(withName: "ConfirmVC", context: self)
                    
                }
                
            } catch {
                print(error.localizedDescription)
            }
            self.stopLoader()
            self.connectShow()
        })
        
        task.resume()
        
    }
}
