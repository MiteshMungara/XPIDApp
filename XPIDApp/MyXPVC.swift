//
//  MyXPVC.swift
//  XPIDApp
//
//  Created by Mits on 9/27/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import SVProgressHUD
import CoreLocation

class MyXPVC: UIViewController ,CLLocationManagerDelegate,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var locationImgV:UIImageView!
    @IBOutlet var MyXPID:UILabel!
    @IBOutlet var TotalPoints:UILabel!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var tbl_myXpTableV:UITableView!
    @IBOutlet var scrollV:UIScrollView!
    @IBOutlet var addressLabel:UILabel!
    
    @IBOutlet var postXPView:UIView!
    @IBOutlet var myXPVCLabel:UILabel!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var jsonArr = NSArray()
    
    var cellHeight:CGFloat = 0.0
    var cellHeightArr = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postXPView.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(historyList), userInfo: nil, repeats: false)
       // scrollV.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 676)
     
        let privacyKey = UserDefaults.standard.string(forKey: "privacyCode")
        if privacyKey == "" || privacyKey == nil
        {
            var fourDigitNumber: String {
                var result = ""
                repeat {
                    // Create a string with a random number 0...9999
                    result = String(format:"%04d", fabs(Double(arc4random_uniform(10000))))
                } while result.count < 4
                return result
            }//MY XPID:### 00000 ## XXX ###
            UserDefaults.standard.set(privacyKey, forKey:"privacyCode")
         //  myXPVCLabel.text = String(format:"MY XPID:###  ## XXX ###")
        }
        else
        {
            myXPVCLabel.text = String(format:"MY XPID:### %d ## XXX ###",privacyKey!)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LocationListVCBtnPressed(sender:Any)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let StorePage = storyBoard.instantiateViewController(withIdentifier: "LocationListVC") as! LocationListVC
        self.present(StorePage, animated: true, completion: nil)
    }
    @IBAction func SettingBtnPressed(sender:Any)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let StorePage = storyBoard.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        self.present(StorePage, animated: true, completion: nil)
    }
    
    
    @objc func historyList()
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false

        //Parameter
        let userid = UserDefaults.standard.string(forKey: "userid")
        let parameters = [
            "u_id":userid,
            "type":"myxp"
        ]
        print(parameters)
        RequstJsonClass.sharedInstance.requestPOSTURL("history.php", params: parameters as [String : AnyObject]?, headers: nil, view: self, success: { (json) in
            // success code
            print(json)
            //   let response = json as? NSDictionary
            let success = json["Success"].string
            if success == "1"
            {
                self.jsonArr = json["posts"].array! as NSArray
                self.cellHeightArr = NSMutableArray()
                
                for i in 0..<self.jsonArr.count
                {
                    self.cellHeightArr.add(0.0)
                }
                if self.jsonArr.count != 0
                {
                    let data = JSON(self.jsonArr)
                    Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.reloadTBL), userInfo: nil, repeats: false)
                }
             //   let userDic = json["userprofile"].dictionary!
                if let userDic = json["userprofile"].dictionary
                {
                    // let data = user
                    let imageURL = userDic["image"]!.string
                    self.nameLabel.text = userDic["name"]!.string
                    self.addressLabel.text = userDic["address"]!.string
                    
                    self.MyXPID.text = String(format:"  %d  Total Post ",(userDic["totalPost"]?.int!)!);
                    self.myXPVCLabel.text = String(format:"MY XPID:### %@ ## XXX ###",(userDic["random_number"]?.string!)!);
                    self.locationImgV.sd_setImage(with: URL.init(string: imageURL!), placeholderImage: nil, options: .continueInBackground, completed: nil)
                    //self.MyXPID.text = String(format:"%d Satisfy XP",(userDic!["totalmyxp"]?.string!)!)
                    self.TotalPoints.text =  String(format:"%d",(userDic["totalmyxp"]?.int!)!);//String(format:"%d",(userDic!["totalmyxp"]?.string!)!)
                }
                
            }
            else
            {
                //       Toast.long(message: "Login Invalid", success: "0", failer: "1")
            }
            self.view.isUserInteractionEnabled = true

            SVProgressHUD.dismiss()
        }, failure: { (error) in
            //error code
            
            print(error)
        })
    }
    
    @objc func reloadTBL()
    {
        self.tbl_myXpTableV.reloadData()
        self.tbl_myXpTableV.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.jsonArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GlobalHistoryCell
        
        let data = JSON(jsonArr[indexPath.row])
        
        cell.nameLabel.text = data["placename"].string
        cell.nameLabel.numberOfLines = 0
        let namemaximumLabelSize: CGSize = CGSize(width: 280, height: 9999)
        let nameexpectedLabelSize: CGSize = cell.nameLabel.sizeThatFits(namemaximumLabelSize)
        var namenewFrame: CGRect = cell.nameLabel.frame
        namenewFrame.size.height = nameexpectedLabelSize.height
        cell.nameLabel.frame = namenewFrame
        
        cell.addressLabel.text = data["address"].string
        cell.addressLabel.numberOfLines = 0
        let addressmaximumLabelSize: CGSize = CGSize(width: 280, height: 9999)
        let addressexpectedLabelSize: CGSize = cell.addressLabel.sizeThatFits(addressmaximumLabelSize)
        var addressnewFrame: CGRect = cell.addressLabel.frame
        addressnewFrame.size.height = addressexpectedLabelSize.height
        cell.addressLabel.frame = addressnewFrame
        cell.addressLabel.frame.origin.y = cell.nameLabel.frame.origin.y + cell.nameLabel.frame.size.height + 7
       
        print(cell.addressLabel.frame.size.height + cell.addressLabel.frame.origin.y)

        cell.satisfyXPLabel.text = String(format:"%@",data["satisfy_xp"].string!)
        cell.satisfyXPLabel.numberOfLines = 0
        let satisfyXPmaximumLabelSize: CGSize = CGSize(width: 280, height: 9999)
        let satisfyXPexpectedLabelSize: CGSize = cell.satisfyXPLabel.sizeThatFits(satisfyXPmaximumLabelSize)
        // create a frame that is filled with the UILabel frame data
        var satisfyXPnewFrame: CGRect = cell.nameLabel.frame
        // resizing the frame to calculated size
        satisfyXPnewFrame.size.height = satisfyXPexpectedLabelSize.height
        // put calculated frame into UILabel frame
        cell.satisfyXPLabel.frame = satisfyXPnewFrame
        cell.satisfyXPLabel.frame.origin.y = cell.addressLabel.frame.origin.y + cell.addressLabel.frame.size.height + 7

        cell.satisfyXPTitleLabel.frame.origin.y = cell.addressLabel.frame.origin.y + cell.addressLabel.frame.size.height + 7
        
        let friendandfamily = Double(data["xp_friend_family"].string!)!
        cell.friendandfamilyXPLabel.text =  String(format:"%.0f",Double(friendandfamily))
        cell.friendandfamilyXPLabel.numberOfLines = 0
        let friendandfamilyXPmaximumLabelSize: CGSize = CGSize(width: 280, height: 9999)
        let friendandfamilyXPexpectedLabelSize: CGSize = cell.friendandfamilyXPLabel.sizeThatFits(friendandfamilyXPmaximumLabelSize)
        // create a frame that is filled with the UILabel frame data
        var friendandfamilyXPnewFrame: CGRect = cell.nameLabel.frame
        // resizing the frame to calculated size
        friendandfamilyXPnewFrame.size.height = friendandfamilyXPexpectedLabelSize.height
        // put calculated frame into UILabel frame
        cell.friendandfamilyXPLabel.frame = friendandfamilyXPnewFrame
        cell.friendandfamilyXPLabel.frame.origin.y = cell.satisfyXPLabel.frame.origin.y + cell.satisfyXPLabel.frame.size.height + 7

        cell.friendandfamilyXPTitleLabel.frame.origin.y = cell.satisfyXPLabel.frame.origin.y + cell.satisfyXPLabel.frame.size.height + 7
        
        cell.descriptionLabel.text = data["xp_description"].string
        cell.descriptionLabel.numberOfLines = 0
        let dmaximumLabelSize: CGSize = CGSize(width: 280, height: 9999)
        let dexpectedLabelSize: CGSize = cell.descriptionLabel.sizeThatFits(dmaximumLabelSize)
        // create a frame that is filled with the UILabel frame data
        var dnewFrame: CGRect = cell.descriptionLabel.frame
        // resizing the frame to calculated size
        dnewFrame.size.height = dexpectedLabelSize.height
        // put calculated frame into UILabel frame
        cell.descriptionLabel.frame = dnewFrame
        cell.descriptionLabel.frame.origin.y = cell.friendandfamilyXPLabel.frame.origin.y + cell.friendandfamilyXPLabel.frame.size.height + 7
 
        
        cell.rankingLabel.text = String(format:"%@ Ranking",data["ranking"].string!)
     
        let imageURL = data["image"].string
        cell.placeImage.sd_setImage(with: URL.init(string: imageURL!), placeholderImage: #imageLiteral(resourceName: "ic_location_placeholder"), options: .continueInBackground, completed: nil)
        cellHeight = CGFloat(cell.descriptionLabel.frame.origin.y + cell.descriptionLabel.frame.size.height + 25)
        
//        let cellH = String(format:"%d",cellHeight)
        cellHeightArr.replaceObject(at: indexPath.row, with: cellHeight)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        if cellHeightArr.count > 0
        {
            print(cellHeightArr)
            let cellheight1 = cellHeightArr.object(at: indexPath.row) as! CGFloat
            if cellheight1 != 0.0
            {
                print(cellheight1)
                if cellheight1 < 150.0
                {
                    return 155
                }
                else
                {
                    return cellheight1
                }
            }
        }
        //return UITableViewAutomaticDimension
        return 165
    }
   
    @IBAction func backBtnPressed(sender:Any)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let StorePage = storyBoard.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
        self.present(StorePage, animated: true, completion: nil)
        
        //self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func editRegisterBtnPressed(sender:Any)
    {
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let StorePage = storyBoard.instantiateViewController(withIdentifier: "EditRegistrationVC") as! EditRegistrationVC
    self.present(StorePage, animated: true, completion: nil)
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

extension MyXPVC
{
    
//    func nearestLocation()
//    {
//        if app.long != "" && app.lat != ""{
//
//            let urlLink = String(format:"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=5000&keyword=starbucks&key=AIzaSyAhBZsez76ZAwrMHb7MZP4PpkDbKCnCjkU",app.lat,app.long)
//
//            RequstJsonClass.sharedInstance.requestGETSingleURL(urlLink, view: self, success: { (json) in
//                //            print(json)
//                //   let response = json as? NSDictionary
//                if json != nil
//                {
//                    let isDataExist = json["results"].array
//                    if (isDataExist?.count)! < 0 || isDataExist == nil
//                    {
//                        return
//                    }
//                    let dataAr = JSON(json["results"].array as Any)
//                    print(dataAr)
//                    print(dataAr.count)
//                    let photoRef = dataAr[0]["photos"][0]//["photo_reference"] as? String
//
//                    if dataAr.count != 0 || photoRef != nil
//                    {
//                        self.jsonArr = dataAr.array as! NSArray
//
//                        let photoRef = dataAr[0]["photos"][0]//["photo_reference"] as? String
//                        let mm = JSON(photoRef["photo_reference"])
//                        print(mm)
//                        print(photoRef["photo_reference"])
//                        self.firstObj = String(format:"https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photoreference=%@&key=AIzaSyAhBZsez76ZAwrMHb7MZP4PpkDbKCnCjkU",mm.string!)
//                        print(self.firstObj)
//                        self.locationImgV.sd_setImage(with: URL.init(string: self.firstObj), placeholderImage: nil, options: .continueInBackground, completed: nil)
//
//
//                    }
//                }
//
//
//            }) { (error) in
//
//                print(error)
//
//            }
//        }
//
//    }
    
    
    
}
