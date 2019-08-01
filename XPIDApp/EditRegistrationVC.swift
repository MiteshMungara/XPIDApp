//
//  EditRegistrationVC.swift
//  XPIDApp
//
//  Created by Mits on 03/06/19.
//  Copyright © 2019 MitTech. All rights reserved.
//

import UIKit
import SVProgressHUD
import DropDown
import SwiftyJSON
import DropDown

class EditRegistrationVC: UIViewController ,UIImagePickerControllerDelegate , UINavigationControllerDelegate{

  
    let comm = commanfunctions()
    let dropDown = DropDown()
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    let Index : DropDown! = nil
    @IBOutlet var scrollV:UIScrollView!
    @IBOutlet var getStartedButton : UIButton!
    @IBOutlet var usernameTextF:UITextField!
    @IBOutlet var fullnameTextF:UITextField!
    @IBOutlet var emailTextF:UITextField!
    @IBOutlet var addressTextF:UITextField!
    @IBOutlet var cityTextF:UITextField!
    @IBOutlet var countryTextF:UITextField!
    @IBOutlet var currencyTypeTextF:UITextField!
    @IBOutlet var noChildTextF:UITextField!
    @IBOutlet var genderTextF:UITextField!
    @IBOutlet var totalamountTextF: UITextField!
    @IBOutlet var stateTextF: UITextField!
    @IBOutlet var profileImage: UIImageView!
    
    var jsonArr = NSArray()
    
    var isImagePicker : Bool = false
    
    let imagePicker = UIImagePickerController()
    var filename : String = ""
    var typeimage : String = ""
    var ismarried : String = "0"
    var ischild : String = "0"
    var data = NSData()
    
    var typeSendImage : String = "0"
    
    @IBOutlet var genderButton : UIButton!
    @IBOutlet var annualHouseHoldButton : UIButton!
    @IBOutlet var nochildrenButton : UIButton!
    @IBOutlet var typecurrencyButton : UIButton!
    
    @IBOutlet var ismarriedSwitch : UISwitch!
    @IBOutlet var isChildSwitch : UISwitch!
    
    @IBOutlet var imgV:UIImageView!
    var pickedImgV: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isImagePicker = false
        fullnameTextF.setLeftPaddingPoints(5)
        emailTextF.setLeftPaddingPoints(5)
        addressTextF.setLeftPaddingPoints(5)
        genderTextF.setLeftPaddingPoints(5)
        cityTextF.setLeftPaddingPoints(5)
        countryTextF.setLeftPaddingPoints(5)
        stateTextF.setLeftPaddingPoints(5)
        
        noChildTextF.text = "0"
        genderTextF.isUserInteractionEnabled = false
        totalamountTextF.isUserInteractionEnabled = false
        //        cityTextF.isUserInteractionEnabled = false
        //        countryTextF.isUserInteractionEnabled = false
        
        noChildTextF.isUserInteractionEnabled = false
        currencyTypeTextF.isUserInteractionEnabled = false
        emailTextF.isUserInteractionEnabled = false
        nochildrenButton.isUserInteractionEnabled = false
        
        let height = getStartedButton.frame.origin.y + getStartedButton.frame.size.height + 30
        //print(height)
        scrollV.contentSize = CGSize(width: self.view.frame.size.width, height: height)//getStartedButton.frame.size.height + 20)
        
        getRegisterWithSNSServiceCall()
//        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(getRegisterWithSNSServiceCall), userInfo: nil, repeats: false)
        emailTextF.text = app.useremail
        isImagePicker = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openCamera()
    {
        isImagePicker = false
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        isImagePicker = false
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        isImagePicker = true
        // let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        do
        {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                let convertedImageDate = UIImageJPEGRepresentation(pickedImage, 0.5)
                
                let getsmallimage = UIImage(data: convertedImageDate!, scale: 0.2)
                
                //                if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
                //                    let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                //                    let asset = result.firstObject
                //                    print(asset?.value(forKey: "filename"))
                //                    filename = asset?.value(forKey: "filename") as! String
                //
                //                }
                filename = "abc.jpg"//asset?.value(forKey: "filename") as! String
                
                profileImage.layer.cornerRadius = profileImage.frame.size.width/2
                profileImage.layer.masksToBounds = true
                
                self.typeSendImage = "1"
                if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
                {
                    profileImage.image = getsmallimage
                    pickedImgV = getsmallimage
                    data = UIImageJPEGRepresentation(profileImage.image!, 0.3)! as NSData
                }
                else
                {
                    pickedImgV = getsmallimage
                    profileImage.image = getsmallimage
                    data = UIImageJPEGRepresentation(profileImage.image!, 0.3)! as NSData
                }
            }
            
        }
        catch
        {
            
        }
        
        
        // print(data)
        dismiss(animated:true, completion: nil) //5
    }
    
    @IBAction func TakeImageBtnPressed(sender:Any)
    {
        isImagePicker = false
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func backBtnPressed(sender:Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func genderBtnPressed(sender:Any)
    {
        dropDown.anchorView = genderButton
        dropDown.dataSource = ["Male","Female","Non-Binary"]
        dropDown.cellNib = UINib(nibName:"MyCell",bundle:nil)
        
        dropDown.direction = .any
        
        dropDown.customCellConfiguration = { (index, item:String, cell:DropDownCell) -> Void in
            
            guard let cell = cell as? MyCell else {
                return
            }
            cell.suffixLabel.text = ""//Suffix \(index)"
            
        }
//        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
//            guard let cell = cell as? MyCell else { return }
//
//            // Setup your custom UI components
//            cell.suffixLabel.text = ""//Suffix \(index)"
//        }
        
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.genderTextF.text = item
        }
    }
    
    @IBAction func typeCurrencyBtnPressed(sender:Any)
    {
        dropDown.anchorView = currencyTypeTextF
        dropDown.dataSource = ["INR","$"]
        dropDown.cellNib = UINib(nibName:"MyCell",bundle:nil)
        
        dropDown.direction = .any
        
        dropDown.customCellConfiguration = { (index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MyCell else { return }
            
            // Setup your custom UI components
            cell.suffixLabel.text = ""//Suffix \(index)"
        }
        
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.currencyTypeTextF.text = item
        }
    }
    
    @IBAction func annualHouseHoldBtnPressed(sender:Any)
    {
        dropDown.anchorView = annualHouseHoldButton
        dropDown.dataSource = ["0 - 20k","20K-40K", "40K-60K", "60K-80K", "> 100K"]
        dropDown.cellNib = UINib(nibName:"MyCell",bundle:nil)
        
        dropDown.direction = .any
        
        dropDown.customCellConfiguration = { (index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MyCell else { return }
            
            // Setup your custom UI components
            cell.suffixLabel.text = ""//Suffix \(index)"
        }
        
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.totalamountTextF.text = item
        }
    }
    //
    @IBAction func noChildBtnPressed(sender:Any)
    {
        dropDown.anchorView = nochildrenButton
        dropDown.dataSource = ["0","1","2","3","4","5","6","7","8","9","10"]
        dropDown.cellNib = UINib(nibName:"MyCell",bundle:nil)
        
        dropDown.direction = .any
        
        dropDown.customCellConfiguration = { (index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MyCell else { return }
            
            // Setup your custom UI components
            cell.suffixLabel.text = ""//Suffix \(index)"
        }
        
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.noChildTextF.text = item
        }
    }
    
    @IBAction func isMerriedBtnPressed(sender:Any)
    {
        if ismarried == "0"
        {
            ismarried = "1"
        }
        else
        {
            ismarried = "0"
        }
    }
    
    @IBAction func ischildBtnPressed(sender:Any)
    {
        if ischild == "0"
        {
            ischild = "1"
            nochildrenButton.isUserInteractionEnabled = true
        }
        else
        {
            self.noChildTextF.text = "0"
            nochildrenButton.isUserInteractionEnabled = false
            ischild = "0"
        }
    }
    
    @IBAction func getStarted(sender:Any)
    {
        
        let usernametest = fullnameTextF.text!
        let usernametrimmed = usernametest.trimmingCharacters(in: .whitespaces)
        
        let emailtest = emailTextF.text!
        let emailtrimmed = emailtest.trimmingCharacters(in: .whitespaces)
        
        let totalamounttest = totalamountTextF.text!
        let totalamounttrimmed = totalamounttest.trimmingCharacters(in: .whitespaces)
        
        let statetest = stateTextF.text!
        let statetrimmed = statetest.trimmingCharacters(in: .whitespaces)
        
        let currencytypetest = currencyTypeTextF.text!
        let currencytypetrimmed = currencytypetest.trimmingCharacters(in: .whitespaces)
        
        let gendertest = genderTextF.text!
        let gendertrimmed = gendertest.trimmingCharacters(in: .whitespaces)
        
        let citytest = cityTextF.text!
        let citytrimmed = citytest.trimmingCharacters(in: .whitespaces)
        
        let countrytest = countryTextF.text!
        let countrytrimmed = countrytest.trimmingCharacters(in: .whitespaces)
        
        
        let emailValid = comm.isValidEmail(testStr: emailTextF.text!)
        
        
        if usernametrimmed.isEmpty
        {
            Toast.long(message: "Username is required", success: "0", failer: "1")
        }
        else if emailtrimmed.isEmpty
        {
            Toast.long(message: "Email Address is required", success: "0", failer: "1")
        }
        else if emailValid == false
        {
            Toast.long(message: "Email Address is invalid", success: "0", failer: "1")
        }
        else if statetrimmed.isEmpty
        {
            Toast.long(message: "State is required", success: "0", failer: "1")
        }
        else if citytrimmed.isEmpty
        {
            Toast.long(message: "City is required", success: "0", failer: "1")
        }
        else if countrytrimmed.isEmpty
        {
            Toast.long(message: "Country is required", success: "0", failer: "1")
        }
        else if currencytypetrimmed.isEmpty
        {
            Toast.long(message: "Currency is required", success: "0", failer: "1")
        }
        else if totalamounttrimmed.isEmpty
        {
            Toast.long(message: "Total amount is required", success: "0", failer: "1")
        }
        else if gendertrimmed.isEmpty
        {
            Toast.long(message: "Gender is required", success: "0", failer: "1")
        }
        else if isImagePicker == false
        {
            Toast.long(message: "Please Select Profile Image.", success: "0", failer: "1")
        }
        else
        {
            RegisterWithSNSServiceCall()
        }
        
        
        //self.performSegue(withIdentifier: "homescreenVC", sender: self)
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


extension EditRegistrationVC
{
    @objc func getRegisterWithSNSServiceCall()
    {
//        let imageData: Data? = UIImageJPEGRepresentation(pickedImgV!, 0.2)
//        let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
//
//        SVProgressHUD.show()
//        self.view.isUserInteractionEnabled = false
//        scrollV.isUserInteractionEnabled = false
        let appDel = UIApplication.shared.delegate as! AppDelegate
//
        let userid = UserDefaults.standard.object(forKey: "userid") ?? nil
        print(userid as Any)
        
        //Parameter
        let parameters = [
            "uid":userid
        ]
        //print(parameters)
        //username,fullname,gender,dob,email,address,city,country,currency_type,totalamount,is_married,is_children,noofchildren,image

        RequstJsonClass.sharedInstance.requestPOSTURL("getregister.php", params: parameters as [String : AnyObject]?, headers: nil, view: self, success: { (json) in
            // success code
            print(json)
            //   let response = json as? NSDictionary
            let success = json["success"].string
            if success == "1"
            {
                self.jsonArr = json["posts"].array! as NSArray
                let data = JSON(self.jsonArr[0])
                print(data)
//                print(data["username"].string)
                //  self.nameLabel.text = data["username"].string
                self.fullnameTextF.text = data["username"].string
                self.fullnameTextF.text = data["username"].string
                self.emailTextF.text = data["email"].string
                self.stateTextF.text = data["state"].string
                self.cityTextF.text = data["city"].string
                self.countryTextF.text = data["country"].string
                self.currencyTypeTextF.text = data["currency_type"].string
                self.noChildTextF.text = data["noofchildren"].string
                self.genderTextF.text = data["gender"].string
                self.totalamountTextF.text = data["totalamount"].string
                let ismarried = data["is_married"].string
                if ismarried == "0"
                {
                    self.ismarriedSwitch.isOn = false
                }
                else
                {
                    self.ismarriedSwitch.isOn = true
                }
                
                
                let ischild = data["is_children"]
                if ischild == "0"
                {
                    self.nochildrenButton.isUserInteractionEnabled = false
                    self.ischild = "0"
                    self.isChildSwitch.isOn = false
                    self.noChildTextF.text = "0"
                    
                }
                else
                {
                     self.ischild = "1"
                    self.nochildrenButton.isUserInteractionEnabled = true
                    self.isChildSwitch.isOn = true
                }
                let imageURL = data["image"].string
                self.profileImage.sd_setImage(with: URL.init(string: imageURL!), placeholderImage: #imageLiteral(resourceName: "ic_location_placeholder"), options: .continueInBackground, completed: nil)
               self.pickedImgV = self.profileImage.image
                
            }
            else
            {
                //self.comm.showAlertOk("Warning", "Something want wrong.", view: self)
                Toast.long(message: "Something want wrong.", success: "1", failer: "0")
            }
            self.view.isUserInteractionEnabled = true
            self.scrollV.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
        }, failure: { (error) in
            //error code
            self.comm.showAlertOk("Warning", "Something want wrong.", view: self)
            self.view.isUserInteractionEnabled = true
            self.scrollV.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
            print(error)
        })
        
    }
    
    
    
    func RegisterWithSNSServiceCall()
    {
        let imageData: Data? = UIImageJPEGRepresentation(pickedImgV!, 0.2)
        let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        scrollV.isUserInteractionEnabled = false
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let username = fullnameTextF.text!
        //let fullname = fullnameTextF.text!
        let email = emailTextF.text!
        let state = stateTextF.text!
        let currencyType = currencyTypeTextF.text!
        let totalamount = totalamountTextF.text!
        let nochild = noChildTextF.text!
        let gender = genderTextF.text!
        let city = cityTextF.text!
        let country = countryTextF.text!
        
        if self.ismarriedSwitch.isOn == true
        {
            ismarried = "1"
        }
        else
        {
            ismarried = "0"
        }
        
        if self.isChildSwitch.isOn == true
        {
            ischild = "1"
        }
        else
        {
            ischild = "0"
        }
        
        //Parameter
        let parameters = [
            "username":username,
            "fullname":"",
            "gender":gender,
            "dob":"",//No Need
            "email":email,
            "state":state,
            "currency_type":currencyType,
            "totalamount":totalamount,
            "is_married":ismarried,
            "is_children":ischild,
            "noofchildren":nochild,
            "city":city,
            "country":country,
            "image":imageStr,
            "type_image":self.typeSendImage
        ]
        print(parameters)
        RequstJsonClass.sharedInstance.requestPOSTURL("register.php", params: parameters as [String : AnyObject]?, headers: nil, view: self, success: { (json) in
            // success code
            print(json)
            //   let response = json as? NSDictionary
            let success = json["Success"].string
            if success == "1"
            {
                // print(success)
                //let posts = json["posts"].dictionary
                self.typeSendImage = "0"
                let name = json["name"].string
                let email = json["posts"][0]["email"].string
                appDel.useremail = email!
                appDel.userid = json["posts"][0]["id"].string!
                print(appDel.userid)
                //  UserDefaults.standard.set(json, forKey: "userprofile")
                UserDefaults.standard.set(appDel.useremail, forKey: "email")
                UserDefaults.standard.set(json["posts"][0]["id"].string!, forKey: "userid")
                UserDefaults.standard.set("\(name)", forKey: "username")
                appDel.username = name!
                Toast.long(message: "Registeration is successfully.", success: "1", failer: "0")
                
//                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let StorePage = storyBoard.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
//                self.present(StorePage, animated: true, completion: nil)
                
            }
            else
            {
                //self.comm.showAlertOk("Warning", "Something want wrong.", view: self)
                Toast.long(message: "Something want wrong.", success: "1", failer: "0")
            }
            self.view.isUserInteractionEnabled = true
            self.scrollV.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
        }, failure: { (error) in
            //error code
            self.comm.showAlertOk("Warning", "Something want wrong.", view: self)
            self.view.isUserInteractionEnabled = true
            self.scrollV.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
            print(error)
        })
        
    }
    
}




