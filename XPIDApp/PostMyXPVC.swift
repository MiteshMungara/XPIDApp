//
//  PostMyXPVC.swift
//  XPIDApp
//
//  Created by Mits on 9/27/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import SwiftyJSON

class PostMyXPVC: UIViewController ,UITextViewDelegate{

    var uid : String = ""
    var city : String = ""
    var state : String = ""
    var country : String = ""
    var username : String = ""
    var address : String = ""
    var long : String = ""
    var lat : String = ""
    var img_url : String = ""
    var ranking : String = ""
    var points : String = ""
    var placename : String = ""
    
    @IBOutlet var locationImageV:UIImageView!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var locationLabel:UILabel!
    @IBOutlet var xpLabel : UILabel!
    @IBOutlet var friendfamilyXPLabel : UILabel!
    @IBOutlet var descriptionTextV : UITextView!
    
    var myXP : Int = 0
    var friendfamilyXP :Int = 0
    var descriptionXP : Int = 0
    var imagevideoXP : Int = 0
    
    var satisfymyxp:String = ""
    var friendandfamilyxp:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //img_url = "https://images.pexels.com/photos/67636/rose-blue-flower-rose-blooms-67636.jpeg"
        print(img_url)
        locationImageV.sd_setImage(with: URL.init(string: img_url), placeholderImage: nil, options: .continueInBackground, completed: nil)
        nameLabel.text = placename
        locationLabel.text = address
        print(address)
        print(username)
        // Do any additional setup after loading the view.
        descriptionTextV.text = "Why did you give the score above?"
        descriptionTextV.textColor = UIColor.lightGray
        descriptionTextV.layer.cornerRadius = 13
        descriptionTextV.delegate = self
        //  print(lo    cationArr)
        // Do any additional setup after loading the view.
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text =  "Why did you give the score above?"
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
           // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }
        
            // For every other case, the text should change with the usual
            // behavior...
        else {
            return true
        }
        self.descriptionXP = 2
        
        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text =  "Why did you leave the scores above?"
            textView.textColor = UIColor.lightGray
        }
        descriptionXP = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func satisfyXPChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        satisfymyxp = "\(currentValue)"
       // xpLabel.text =  "+\(currentValue)"
        print(satisfymyxp)
        myXP = 1
        xpLabel.text = satisfymyxp
       // label.text = "\(currentValue)"
    }
    
    @IBAction func friendandsatisfyfamiluChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        friendandfamilyxp = "\(currentValue)"
        //friendfamilyXPLabel.text =  "+\(currentValue)"
        print(friendandfamilyxp)
        friendfamilyXP = 2
        friendfamilyXPLabel.text = friendandfamilyxp
       // label.text = "\(currentValue)"
    }

    @IBAction func postXPChanged(_ sender: Any) {
        // label.text = "\(currentValue)s"
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(postXP), userInfo: nil, repeats: false)
    }

    @objc func postXP()
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        
        //Parameter
        let date = NSDate()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy";
        let currentDate = dateformatter.string(from: date as Date)//"12/02/2019"
        let totalXP = myXP + friendfamilyXP + descriptionXP + imagevideoXP
        print(myXP)
        print(descriptionXP)
        print(friendfamilyXP)
        print(imagevideoXP)
        print(totalXP)
        var imageData: Data?
        if locationImageV.image != nil
        {
            imageData = UIImageJPEGRepresentation(locationImageV.image!, 0.2)
            
        }
       
        let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        let uname = username as! String
        print(placename)
        let parameters = [
            "u_id":uid,
            "username":uname,
            "placename":"\(placename)",
            "address":"\(address)",
            "city":city,
            "state":state,
            "country":country,
            "satisfy_xp":satisfymyxp,
            "xp_friend_family":friendandfamilyxp,
            "xp_description":descriptionTextV.text,
            "long":long,
            "lat":lat,
            "current_date":currentDate,
            "image":img_url,
            "ranking":String(format:"%d",totalXP),
            "points":String(format:"%d",totalXP),
            "picture":imageStr
            ] as [String : Any]
        
        print(parameters)
        RequstJsonClass.sharedInstance.requestPOSTURL("postxp.php", params: parameters as [String : AnyObject]?, headers: nil, view: self, success: { (json) in
            // success code
            print(json)
            //   let response = json as? NSDictionary
            let success = json["Success"].string
            if success == "1"
            {
                print(success)
                //Toast.long(message: "Post Successfully", success: "1", failer: "0")
                
                let ranking = json["points"].string ?? ""
                let XPID = json["XPID"].int ?? 0
                let totalsatisfyxp = json["totalsatisfyxp"].int ?? 0
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let StorePage = storyBoard.instantiateViewController(withIdentifier: "ConfirmVC") as! ConfirmVC
                print(ranking)
                StorePage.imageLocationURL = self.img_url
                var totalXPSet = Double(totalXP)
                var rankingSet = Double(ranking) ?? 0
                if totalXP < 0
                {
                    totalXPSet = 0
                }
                if rankingSet < 0
                {
                    rankingSet = 0
                }
                StorePage.points = String(format:"%.1f",Double(round(totalXPSet)))
                StorePage.totalXP = String(format:"%.1f",Double(round(rankingSet)))
                StorePage.SatisfyXP = String(format:"%d",totalsatisfyxp)
                StorePage.XPID = String(format:"%d",XPID)
                
                self.present(StorePage, animated: true, completion: nil)
                
            }
            else
            {
                Toast.long(message: "PostXp Invalid", success: "0", failer: "1")
            }
            self.view.isUserInteractionEnabled = true

            SVProgressHUD.dismiss()
        }, failure: { (error) in
            //error code
            SVProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
