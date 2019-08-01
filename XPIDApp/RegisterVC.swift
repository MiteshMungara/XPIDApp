//
//  RegisterVC.swift
//  XPIDApp
//
//  Created by Mits on 6/6/18.
//  Copyright © 2018 MitTech. All rights reserved.
//
//{
//    "username":"ABC",
//    "fullname":"Mitesh",
//    "gender":"Male",
//    "dob":"05/02/1989",
//    "email":"mit123@gmil.com",
//    "address":"123 abc",
//    "currency_type":"INR",
//    "totalamount":"2000",
//    "is_married":"0",
//    "is_children":"0",
//    "noofchildren":"0"
//}
import UIKit
import SVProgressHUD
import DropDown

class RegisterVC: UIViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    let comm = commanfunctions()
    let dropDown = DropDown()
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
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
    
    var isImagePicker : Bool = false
    
    let imagePicker = UIImagePickerController()
    var filename : String = ""
    
    var ismarried : String = "0"
    var ischild : String = "0"
    var data = NSData()
    
    @IBOutlet var genderButton : UIButton!
    @IBOutlet var annualHouseHoldButton : UIButton!
    @IBOutlet var nochildrenButton : UIButton!
    @IBOutlet var typecurrencyButton : UIButton!
    @IBOutlet var imgV:UIImageView!
    var pickedImgV: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isImagePicker = false
        fullnameTextF.setLeftPaddingPoints(5)
        emailTextF.setLeftPaddingPoints(5)
        //addressTextF.setLeftPaddingPoints(5)
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
        // Do any additional setup after loading the view.
        
       // let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
     //   view.addGestureRecognizer(tap)
    }
    
//    func dismissKeyboard() {
//        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//      //
//
//        if genderTextF.isEditing == true
//        {
//         view.endEditing(true)
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextF.text = app.useremail
        
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

        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MyCell else { return }

            // Setup your custom UI components
            cell.suffixLabel.text = ""//Suffix \(index)"
        }

        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.genderTextF.text = item
        }
    }
    
    @IBAction func typeCurrencyBtnPressed(sender:Any)
    {
        dropDown.anchorView = currencyTypeTextF
        dropDown.dataSource = ["USD (US$)","EUR (€)","JPY (¥)","GBP (£)","AUD (A$)","CAD (C$)","CHF (Fr)","CNY (元)","SEK (kr)","NZD (NZ$)","MXN ($)","SGD (S$)","HKD (HK$)","NOK (kr)","KRW (₩)","TRY (₺)","RUB (₽)","INR (₹)","BRL (R$)","ZAR (R)"]

        dropDown.cellNib = UINib(nibName:"MyCell",bundle:nil)
        
        dropDown.direction = .any
        
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
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
        
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
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

        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
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


extension RegisterVC
{
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
       // let address = cityTextF.text!
        let currencyType = currencyTypeTextF.text!
        let totalamount = totalamountTextF.text!
        let nochild = noChildTextF.text!
        let gender = genderTextF.text!
        let city = cityTextF.text!
        let country = countryTextF.text!
        let state = stateTextF.text!
            //Parameter
            let parameters = [
                "username":username,
                "fullname":"",
                "gender":gender,
                "dob":"",//No Need
                "email":email,
                //"address":address,
                "currency_type":currencyType,
                "totalamount":totalamount,
                "is_married":ismarried,
                "is_children":ischild,
                "noofchildren":nochild,
                "city":city,
                "state":state,
                "country":country,
                "image":imageStr
            ]
            //print(parameters)
            RequstJsonClass.sharedInstance.requestPOSTURL("register.php", params: parameters as [String : AnyObject]?, headers: nil, view: self, success: { (json) in
                // success code
                print(json)
                //   let response = json as? NSDictionary
                let success = json["Success"].string
                if success == "1"
                {
                   // print(success)
                    //let posts = json["posts"].dictionary
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
                   // self.comm.showAlertOk("Success!", "Registeration is successfully.", view: self)
                    //self.dismiss(animated: true, completion: nil)
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let StorePage = storyBoard.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
                    self.present(StorePage, animated: true, completion: nil)
                    
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



//textField Left Space Before text
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}



