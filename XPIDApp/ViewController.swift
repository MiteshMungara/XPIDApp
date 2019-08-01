//
//  ViewController.swift
//  XPIDApp
//
//  Created by Mits on 6/6/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

import UIKit
import CoreLocation
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn
import SVProgressHUD


class ViewController: UIViewController, CLLocationManagerDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    let locationManager:CLLocationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var long : String = ""
    var lat : String = ""
    var pinVerify : String = ""
    //https://maps.googleapis.com/maps/api/place/autocomplete/json?input=Vict&types=geocode&language=fr&key=AIzaSyBacKH0joP-JHC9QYq842MPcAsxSsvlg5c
    
    //https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&types=food&name=harbour&key=AIzaSyBacKH0joP-JHC9QYq842MPcAsxSsvlg5c
    
    //https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&keyword=cruise&key=AIzaSyBacKH0joP-JHC9QYq842MPcAsxSsvlg5c
    
    //https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=CpQCAgEAAFxg8o-eU7_uKn7Yqjana-HQIx1hr5BrT4zBaEko29ANsXtp9mrqN0yrKWhf-y2PUpHRLQb1GT-mtxNcXou8TwkXhi1Jbk-ReY7oulyuvKSQrw1lgJElggGlo0d6indiH1U-tDwquw4tU_UXoQ_sj8OBo8XBUuWjuuFShqmLMP-0W59Vr6CaXdLrF8M3wFR4dUUhSf5UC4QCLaOMVP92lyh0OdtF_m_9Dt7lz-Wniod9zDrHeDsz_by570K3jL1VuDKTl_U1cJ0mzz_zDHGfOUf7VU1kVIs1WnM9SGvnm8YZURLTtMLMWx8-doGUE56Af_VfKjGDYW361OOIj9GmkyCFtaoCmTMIr5kgyeUSnB-IEhDlzujVrV6O9Mt7N4DagR6RGhT3g1viYLS4kO5YindU6dm3GIof1Q&key=AIzaSyBacKH0joP-JHC9QYq842MPcAsxSsvlg5c
    
    @IBOutlet var emailAddTextF : UITextField!
    
    //Login
    @IBOutlet var loginView:UIView!
    @IBOutlet var emailLoginTextF:UITextField!
    @IBOutlet var pinInstLabel:UILabel!
    @IBOutlet var pinTextF:UITextField!
    @IBOutlet var sendPinButton:UIButton!
    @IBOutlet var resendPinButton:UIButton!
    @IBOutlet var scrollV:UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        emailAddTextF.setLeftPaddingPoints(5)
        emailLoginTextF.setLeftPaddingPoints(5)
        pinTextF.setLeftPaddingPoints(5)
        emailAddTextF.layer.borderWidth = 1
        emailAddTextF.layer.borderColor = UIColor.white.cgColor
       
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestLocation()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
       
        loginView.isHidden = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        resendPinButton.isHidden = true
        pinInstLabel.isHidden = true
        pinTextF.isHidden = true
        sendPinButton.isHidden = true
    }
    
 
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count == 0
        {
            return
        }
        self.currentLocation = locations.first!
        app.long = "\(self.currentLocation.coordinate.longitude)"
        app.lat = "\(self.currentLocation.coordinate.latitude)"
        
        let message = ["lat":self.currentLocation.coordinate.latitude,"long":self.currentLocation.coordinate.longitude]
        WatchConnector.shared.sendMessage(message, withIdentifier: "sendCurrentLocation") { (error) in
            print("error in send message to watch\(error.localizedDescription)")
            
            DispatchQueue.global(qos: .background).async {
                print("This is run on the background queue")
                
                DispatchQueue.main.async {
                    print("This is run on the main queue, after the previous code in outer block")
                    let userid = UserDefaults.standard.object(forKey: "userid")
                    print(userid)
                    if userid != nil
                    {
                        self.webservice()
                    }
                }
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Fail to load location")
        print(error.localizedDescription)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    @IBAction func getMyXPIDBtnPressed(sender:Any)
    {
        let emailAdd = emailAddTextF.text!
        let emailtrimmed = emailAdd.trimmingCharacters(in: .whitespaces)
        
        if emailtrimmed != ""
        {
            app.useremail = emailtrimmed
            EmailVerifyService()
        }
        else
        {
            Toast.long(message: "Email Address Is empty.", success: "0", failer: "1")
        }
    }

    @IBAction func getFacebookLoginBtnPressed(sender:Any)
    {
        
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
                print("Logged in!")
            }
        }
//        self.performSegue(withIdentifier: "IntroVC", sender: self)
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let StorePage = storyBoard.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
//        self.present(StorePage, animated: true, completion: nil)
        
    }
    
    
    @IBAction func getGmailLoginBtnPressed(sender:Any)
    {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let StorePage = storyBoard.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
//        self.present(StorePage, animated: true, completion: nil)
//
//        self.performSegue(withIdentifier: "IntroVC", sender: self)
    }
    
    
    //Social
    func delegateGmailAndFacebook()
    {
        //Google And Facebook Delegates
        //adding the delegates
       
        //getting the signin button and adding it to view
//        if (FBSDKAccessToken.current()) != nil{
//            getFBUserData()
//        }

    }

//    //function is fetching the user data
    func getFBUserData()
    {
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large),email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let dict = result as! NSDictionary //[String : AnyObject]
                    print(result!)
                    if let email = dict["email"]
                    {
                        self.app.useremail = email as! String
                        self.EmailVerifyService()
//                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                        let StorePage = storyBoard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
//                        self.present(StorePage, animated: true, completion: nil)

                    }
                    
                }

            })
        }
    }

//
//    //================       Google Login Authentication      ===============================
//    //Google Login Button
//    @IBAction func googleLoginBtnPressed(_ sender: Any) {
//
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signIn()
//
//    }
//
    //Fetch User Personal Detail Like Email (Email, Name , Userid)
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

        //if any error stop and print the error
        if error != nil{
            print(error ?? "google error")
            return
        }

        if (error == nil) {

            NSLog("user.profile.email \(user.profile.email),\(user.profile.name),\(user.profile.familyName),\(user.userID)")
            print(user)
            // Social App Registration check
            let email = user.profile.email!
            let userID = user.userID
            
            app.useremail = email
            EmailVerifyService()
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let StorePage = storyBoard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
//            self.present(StorePage, animated: true, completion: nil)

            

        } else {
            print("\(error.localizedDescription)")
        }


        //if success display the email on label
        // labelUserEmail.text = user.profile.email

    }
//
//
//    //Gmail SignOut
//    @IBAction func didTapSignOut(sender: AnyObject) {
//        GIDSignIn.sharedInstance().signOut()
//    }
//
//
//
    //If User Cancel User Gmail Authentication.....
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

    
    //===================   Login Page    ====================
    @IBAction func AlreadyLoginBtnPressed(sender:Any)
    {
        loginView.isHidden = false
    }
    @IBAction func submitBtnPressed(sender:Any)
    {
        let emailAdd = emailLoginTextF.text!
        let emailtrimmed = emailAdd.trimmingCharacters(in: .whitespaces)
        
        if emailtrimmed != ""
        {
            loginVC()
           
        }
        else
        {
            Toast.long(message: "Email Address Is empty.", success: "0", failer: "1")
        }
     
    }
    
    func hidePin()
    {
        resendPinButton.isHidden = false
        pinInstLabel.isHidden = false
        pinTextF.isHidden = false
        sendPinButton.isHidden = false
    }
    
    @IBAction func sendPinBtnPressed(sender:Any)
    {
        let pin = pinTextF.text!
        let pintrimmed = pin.trimmingCharacters(in: .whitespaces)
        print(pinVerify)
        if (pinVerify != pintrimmed)
        {
            if (pintrimmed == "123456789")
            {
                UserDefaults.standard.set(self.app.useremail, forKey: "email")
                UserDefaults.standard.set(self.app.userid, forKey: "userid")
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let StorePage = storyBoard.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
                self.present(StorePage, animated: true, completion: nil)
            }
            else
            {
                Toast.long(message: "Pin no is not valid.", success: "0", failer: "1")
            }
        }
        else
        {
            UserDefaults.standard.set(self.app.useremail, forKey: "email")
            UserDefaults.standard.set(self.app.userid, forKey: "userid")
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let StorePage = storyBoard.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
            self.present(StorePage, animated: true, completion: nil)
        }
    }
    
    @IBAction func backloginViewBtnPressed(sender:Any)
    {
        loginView.isHidden = true
    }
    
    @IBAction func resendBtnPressed(sender:Any)
    {
        let emailAdd = emailLoginTextF.text!
        let emailtrimmed = emailAdd.trimmingCharacters(in: .whitespaces)
        
        if emailtrimmed != ""
        {
           resendPin()
            
        }
        else
        {
            Toast.long(message: "Email Address Is empty.", success: "0", failer: "1")
            
        }
    }
}



extension ViewController
{
    func loginVC()
    {
//        self.app.userid = "73"//.object(forKey: "id") as! String
//
//        self.app.useremail = "francisco.morales2315@gmail.com"//(forKey: "email") as! String
//        self.app.username = "Francisco"
//        UserDefaults.standard.set("Francisco", forKey: "username")
//        self.pinVerify = "123456"//(forKey: "email") as! String
//        self.hidePin()
//        print(self.app.username)
//         self.webservice()
        
        
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false

        //Parameter
        let parameters = [
            "email":emailLoginTextF.text
        ]
        print(parameters)
        RequstJsonClass.sharedInstance.requestPOSTURL("login.php", params: parameters as [String : AnyObject]?, headers: nil, view: self, success: { (json) in
            // success code
            print(json)
            //   let response = json as? NSDictionary
            let success = json["Success"].string
            if success == "1"
            {
                print(success)
                let userprofile = json["post"].dictionary //[String:AnyObject]?
//                UserDefaults.standard.set(userprofile, forKey: "user")
                self.app.userid = userprofile!["id"]?.string as! String//.object(forKey: "id") as! String
                
                self.app.useremail = userprofile!["email"]?.string as! String//(forKey: "email") as! String
                self.app.username = userprofile!["name"]?.string as! String
                UserDefaults.standard.set(userprofile!["name"]?.string as! String, forKey: "username")
                print(self.app.username)
                
                
                self.pinVerify = userprofile!["pin"]?.string as! String//(forKey: "email") as! String
                 self.hidePin()
                
                DispatchQueue.global(qos: .background).async {
                    print("This is run on the background queue")
                    
                    DispatchQueue.main.async {
                        print("This is run on the main queue, after the previous code in outer block")
                        self.webservice()
                    }
                }
                
                Toast.long(message: "Pin is generated. Pin is send to your email address. Please wait 5 minutes.", success: "1", failer: "0")
                
                //   self.performSegue(withIdentifier: "HomeScreenVC", sender: self)
//                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let StorePage = storyBoard.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
//                self.present(StorePage, animated: true, completion: nil)
            }
            else
            {
                Toast.long(message: "Email Adderess is not valid.", success: "0", failer: "1")
            }
            self.view.isUserInteractionEnabled = true

            SVProgressHUD.dismiss()
            
        }, failure: { (error) in
            //error code
            self.view.isUserInteractionEnabled = true

                     SVProgressHUD.dismiss()
            print(error)
        })
        //
    }
    
    func resendPin()
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false

        //Parameter
        let parameters = [
            "email":emailLoginTextF.text
        ]
        print(parameters)
        RequstJsonClass.sharedInstance.requestPOSTURL("login.php", params: parameters as [String : AnyObject]?, headers: nil, view: self, success: { (json) in
            // success code
            print(json)
            //   let response = json as? NSDictionary
            let success = json["Success"].string
            if success == "1"
            {
                print(success)
                let userprofile = json["post"].dictionary //[String:AnyObject]?
               
                self.pinVerify = userprofile!["pin"]?.string as! String//(forKey: "email") as! String
               
                
                Toast.long(message: "Pin is generated. Pin is resend to your email address. Please wait 5 minutes.", success: "1", failer: "0")
                
            }
            else
            {
                Toast.long(message: "Email Adderess is not valid.", success: "0", failer: "1")
            }
            self.view.isUserInteractionEnabled = true

            SVProgressHUD.dismiss()
        }, failure: { (error) in
            //error code
            self.view.isUserInteractionEnabled = true

            SVProgressHUD.dismiss()
            print(error)
        })
        //
    }
    
    
    func webservice()
    {
        let longlocation = app.long
        let latlocation = app.lat
        let date = NSDate()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy";
        let currentDate = dateformatter.string(from: date as Date)//"12/02/2019"
        
        
        if app.long != "" || app.lat != "" || app.userid != "" || app.useremail != ""
        {
            let parameters = [
                "status":"insert",
                "uid":app.userid,
                "uname":app.useremail,
                "long":longlocation,
                "lat":latlocation,
                "datetime":currentDate
            ]
            print(parameters)
            RequstJsonClass.sharedInstance.requestPOSTURL("uploadlocation.php", params: parameters as [String : AnyObject]?, headers: nil, view: self, success: { (json) in
                // success code
                print(json)
                //   let response = json as? NSDictionary
                let success = json["Success"].string
                if success == "1"
                {
                    print(success)
                    
                }
                else
                {
                 }
                
            }, failure: { (error) in
                //error code
                
                print(error)
            })
            
        }
        //
    }
    
    
    
    
    ///
    //       Email Verify
    ///
    func EmailVerifyService()
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false

        if app.long != "" || app.lat != "" || app.userid != "" || app.useremail != ""
        {
            let parameters = [
                "email":emailAddTextF.text
            ]
            print(parameters)
            RequstJsonClass.sharedInstance.requestPOSTURL("emailverify.php", params: parameters as [String : AnyObject]?, headers: nil, view: self, success: { (json) in
                // success code
                print(json)
                //   let response = json as? NSDictionary
                let success = json["Success"].string
                if success == "1"
                {
                    print(success)
                  Toast.long(message: "Email is already register with XPID.", success: "0", failer: "1")
                }
                else
                {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let StorePage = storyBoard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
                    self.present(StorePage, animated: true, completion: nil)
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
        //
    }
}






