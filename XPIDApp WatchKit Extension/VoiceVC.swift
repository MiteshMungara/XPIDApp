//
//  VoiceVC.swift
//  XPIDApp WatchKit Extension
//
//  Created by Mits on 7/20/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

import WatchKit
import Foundation

class VoiceVC: WKInterfaceController {
    @IBOutlet var loader: WKInterfaceImage!
    @IBOutlet var topheaderLabel: WKInterfaceLabel!
    @IBOutlet var MicButton: WKInterfaceButton!
    @IBOutlet var EraseButton: WKInterfaceButton!
    @IBOutlet var saparetorLabel: WKInterfaceSeparator!
    @IBOutlet var submitButton: WKInterfaceButton!
    
    @IBOutlet weak var voiceLabel: WKInterfaceLabel!
    var voicestring : String = ""
    
    func connectShow()
    {
        topheaderLabel.setHidden(false)
        MicButton.setHidden(false)
       // loader.setHidden(false)
        EraseButton.setHidden(false)
        voiceLabel.setHidden(false)
        saparetorLabel.setHidden(false)
        submitButton.setHidden(false)
    }
    
    func connectHide()
    {
        topheaderLabel.setHidden(true)
        MicButton.setHidden(true)
       // loader.setHidden(true)
        EraseButton.setHidden(true)
        voiceLabel.setHidden(true)
        saparetorLabel.setHidden(true)
        submitButton.setHidden(true)
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
        
//        self.presentTextInputController(withSuggestions: ["suggestion 1", "suggestion 2"] allowedInputMode: .plain, completion: { (answers) -> Void in
//            if (answers != nil) && answers.count > 0 {
//                if let answer = answers[0] as? String {
//                    println("\answer")
//                }
//            }
//        })
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
    
    
    @IBAction func PlayBtnPressed(sender:Any)
    {
//        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "")?.appendingPathComponent("resource.mp4")//attributesOfFileSystem(forPath: )
//
//        self.presentAudioRecorderController(withOutputURL: url!, preset: WKAudioRecorderPreset.highQualityAudio, options: nil) { (didSave, error) in
//
//            if error == nil{
//                //
//            }
//            else
//            {
//                print(error)
//            }
//        }
        
       // self.pushController(withName: "ConfirmVC", context: self)
    }
    
    @IBAction func MicBtnPressed(sender:Any)
    {
        self.presentTextInputController(withSuggestions: ["Your voice converted to text"], allowedInputMode: .plain) { (args) in
            
            let (answers) = args as! NSArray
            if (answers != nil) && answers.count > 0 {
                // if let answer = answers[0] as? String ?? [0]{
                print(answers[0])
                self.voicestring = answers[0] as! String
                self.voiceLabel.setText(answers[0] as! String)
                // }
            }
        }
//        self.pushController(withName: "ConfirmVC", context: self)
    }
    
    @IBAction func eraseBtnPressed(sender:Any)
    {
        voiceLabel.setText("")
//        self.pushController(withName: "ConfirmVC", context: self)
    }
    
    @IBAction func SubmitBtnPressed(sender:Any)
    {
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(postXP), userInfo: nil, repeats: false)
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
       // let uname = UserDefaults.standard.string(forKey: "email")
        let username = UserDefaults.standard.string(forKey: "username")!
        let uid =  UserDefaults.standard.string(forKey: "uid")!
        let satisfymyxp = UserDefaults.standard.string(forKey: "xp")
        let friendandfamilyxp = UserDefaults.standard.string(forKey: "familyxp")
        let voicestring1 = voiceLabel.description as! String//UserDefaults.standard.string(forKey: "description")
        let imagevideoXP = UserDefaults.standard.string(forKey: "placeimage")
        
        print(voiceLabel)
        
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
        
        if imagevideoXP != ""
        {
            img = 2
        }
        let totalXP =  xp+family+dec+img
        
        let placename = UserDefaults.standard.string(forKey: "placename")
        let address = UserDefaults.standard.string(forKey: "address")
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://xpid.me/app/postxpwatch.php")! as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
       // let uid1 = "1"
        print(String(describing: uid))
        
        let params = ["u_id": uid,"placename":placename,"xp_friend_family":friendandfamilyxp,"username":username,"address":address,"city":"","state":"","country":"","satisfy_xp":satisfymyxp,"xp_description":voicestring,"long":lng,"lat":lat,"current_date":currentDate,"image":imagevideoXP,"ranking":String(format:"%d",totalXP),"points":String(format:"%d",totalXP)] as! Dictionary<String, String>
        print(params)
      //  let params = ["u_id":uid1,"placename":placename,"xp_friend_family":friendandfamilyxp,"username":uname1,"address":address,"city":"","state":"","country":"","satisfy_xp":satisfymyxp,"xp_description":descriptionXP,"long":lng,"lat":lat,"current_date":currentDate,"image":imagevideoXP,"ranking":String(format:"%d",totalXP),"points":String(format:"%d",totalXP)] as! Dictionary<String, String>
        //INSERT INTO  user_location_survay(u_id,username,placename,address,city,state,country,satisfy_xp,xp_friend_family,xp_description,loc_long,loc_lang,cur_date,img_url,ranking,points,image) values('72','Mitesh','Honeymoon Packages in Manali','D.S.Barato Road, Wadala, Mumbai','','','','4','9','AQEF','72.856164','19.017615','04-05-2019','https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photoreference=CmRaAAAAOlsVCS-jPzs6JZ0tt1GGddOPOWJ1IxKCZJD_PFSwOlGI1fAvS8Dp7p_NJIhzEiAsvwML68iFIh-R22yimQhywKo1XUqpY0xxWpWOfrgAKNXAdwn-cDM_j4mMJlOaKzp8EhBZHEMZLEs8NMSdx0yWM2RQGhT9JV46JhCwsFOLzg7BUlFzsvdKLQ&key=AIzaSyBLoPujJRpBq3FYge80p-Tbh4_tPOEkiyo','6','6','fHuN48Vb3v.jpg')
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
