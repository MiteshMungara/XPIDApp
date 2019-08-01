//
//  ConfirmVC.swift
//  XPIDApp
//
//  Created by Mits on 9/27/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class ConfirmVC: UIViewController {

    @IBOutlet var totalXPLabel : UILabel!
    @IBOutlet var pointLabel : UILabel!
    @IBOutlet var imageLocationImgV : UIImageView!
  
    @IBOutlet var commentTextV : UITextView!
    @IBOutlet var sendButton : UIButton!
    
    var totalXP : String = ""
    var points : String = ""
    var imageLocationURL : String = ""
    var typecomment : String = ""
    
    var XPID : String = ""
    var SatisfyXP : String = ""
    
    @IBOutlet var myxpView : UIView!
    @IBOutlet var historyView : UIView!
   // @IBOutlet var watchView : UIView!
    @IBOutlet var postxpView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(totalXP)
        print(points)

        totalXPLabel.text = SatisfyXP
        pointLabel.text = XPID
//        totalXPLabel.text = totalXP
//        pointLabel.text = points
        
        sendButton.layer.cornerRadius = 10
        myxpView.layer.cornerRadius = 12
        historyView.layer.cornerRadius = 12
        postxpView.layer.cornerRadius = 12
        //imageLocationImgV.sd_setImage(with: URL.init(string: imageLocationURL), completed: nil)
        typecomment = "insert"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(sender:Any)
    {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func myxpBtnPressed(sender:Any)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let StorePage = storyBoard.instantiateViewController(withIdentifier: "MyXPVC") as! MyXPVC
        self.present(StorePage, animated: true, completion: nil)
    }
    
    @IBAction func myGlobalHistoryBtnPressed(sender:Any)
    {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let StorePage = storyBoard.instantiateViewController(withIdentifier: "GlobalHistoryVC") as! GlobalHistoryVC
        self.present(StorePage, animated: true, completion: nil)
        
    }
    
    @IBAction func postmyxpBtnPressed(sender:Any)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let StorePage = storyBoard.instantiateViewController(withIdentifier: "LocationListVC") as! LocationListVC
        self.present(StorePage, animated: true, completion: nil)
        
        //self.performSegue(withIdentifier: "LocationListVC", sender: self)
    }
    
    @IBAction func sendCommentBtnPressed(sender:Any)
    {
        let commenttest = commentTextV.text!
        let commenttrimmed = commenttest.trimmingCharacters(in: .whitespaces)
        
        
        if commenttrimmed.isEmpty
        {
            Toast.long(message: "Comment is required", success: "0", failer: "1")
        }
        else
        {
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(sendComment), userInfo: nil, repeats: false)
        }
    }
    
    @objc func sendComment()
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false

        //Parameter
        let userid = UserDefaults.standard.string(forKey: "userid")!
        let parameters = [
            "u_id":userid,
            "type": typecomment,
            "comment":commentTextV.text
            ] as [String : Any]
        print(parameters)
        RequstJsonClass.sharedInstance.requestPOSTURL("sendcomment.php", params: parameters as [String : AnyObject]?, headers: nil, view: self, success: { (json) in
            // success code
            print(json)
            //   let response = json as? NSDictionary
            let success = json["Success"].string
            if success == "1"
            {
              self.typecomment = "update"
                Toast.long(message: "Experience Added Successfully", success: "1", failer: "0")
                self.commentTextV.text = ""
            }
            else
            {
                Toast.long(message: "Something went wrong.", success: "0", failer: "1")
                //       Toast.long(message: "Login Invalid", success: "0", failer: "1")
            }
            self.view.isUserInteractionEnabled = true

            SVProgressHUD.dismiss()
        }, failure: { (error) in
            //error code
            
            print(error)
        })
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
