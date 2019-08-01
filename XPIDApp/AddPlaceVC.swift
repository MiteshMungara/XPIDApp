//
//  AddPlaceVC.swift
//  XPIDApp
//
//  Created by Mits on 12/17/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreLocation

class AddPlaceVC: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate,CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    let app = UIApplication.shared.delegate as! AppDelegate

    
    var isImagePicker : Bool = false
    @IBOutlet var imgV:UIImageView!
    var filename : String = ""
    
    static var imgArray = [UIImage]()
    let imagePicker = UIImagePickerController()
    var pickedImgV: UIImage!
    
    @IBOutlet var plancenameTextF:UITextField!
    @IBOutlet var addressTextF:UITextField!
    var data = NSData()
    var cityname = ""
    var countryname = ""
    var statename = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isImagePicker = false
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        self.view.isUserInteractionEnabled = true

        SVProgressHUD.dismiss()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        manager.stopUpdatingLocation()

        app.lat = "\(locValue.latitude)"
        app.long = "\(locValue.longitude)"
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                
                print("placemarks",placemarks!)
                let pm = placemarks?[0]
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            
            print("your location is:-",containsPlacemark)
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            self.cityname = locality!
            //postalCodeTxtField.text = postalCode
            //aAreaTxtField.text = administrativeArea
            self.countryname = country!
        }
        
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
                
                imgV.layer.cornerRadius = imgV.frame.size.width/2
                imgV.layer.masksToBounds = true
                
                if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
                {
                    imgV.image = getsmallimage
                    pickedImgV = getsmallimage
                    data = UIImageJPEGRepresentation(imgV.image!, 0.3)! as NSData
                }
                else
                {
                    pickedImgV = getsmallimage
                    imgV.image = getsmallimage
                    data = UIImageJPEGRepresentation(imgV.image!, 0.3)! as NSData
                }
            }
            
        }
        catch
        {
            
        }
        
        
        print(data)
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
    
    @IBAction func saveBtnPressed(sender:Any)
    {
        let placenametest = plancenameTextF.text!
        let placenametrimmed = placenametest.trimmingCharacters(in: .whitespaces)
        
        let addresstest = addressTextF.text!
        let addresstrimmed = addresstest.trimmingCharacters(in: .whitespaces)
        
        if placenametrimmed.isEmpty
        {
            Toast.long(message: "Place Name is required", success: "0", failer: "1")
        }
        else if addresstrimmed.isEmpty
        {
            Toast.long(message: "Address is required", success: "0", failer: "1")
        }
        else if isImagePicker == false
        {
            Toast.long(message: "Please Select Profile Image.", success: "0", failer: "1")
        }
        else
        {
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(savePlaceVC), userInfo: nil, repeats: false)
        }
    }
    
    @objc func savePlaceVC()
    {
        
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false

        //Parameter
        let date = NSDate()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy";
        let currentDate = dateformatter.string(from: date as Date)//"12/02/2019"
        
        let placename = plancenameTextF.text!
        let address = addressTextF.text!
        let imageData: Data? = UIImageJPEGRepresentation(imgV.image!, 0.2)
        let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        //print(strBase64)
        let parameters = [
            "placename":placename,
            "address":address,
            "date":currentDate,
            "image":filename,
            "picture":imageStr
            ] as [String : Any]
        print(parameters)
      
        RequstJsonClass.sharedInstance.requestPOSTURL("addplacename.php", params: parameters as [String : AnyObject]?, headers: nil, view: self, success: { (json) in
                print(json)
            let success = json["Success"].string
            if success == "1"
            {
                print(success)
                let imageurl = json["image_url"].string!
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let StorePage = storyBoard.instantiateViewController(withIdentifier: "PostMyXPVC") as! PostMyXPVC
                StorePage.uid = UserDefaults.standard.string(forKey: "userid")!
                StorePage.username = UserDefaults.standard.string(forKey: "username")!
                StorePage.placename = self.plancenameTextF.text!//data["name"].string!
                StorePage.address = self.addressTextF.text!//data["vicinity"].string!//"abcd abcd"
                StorePage.state = ""
                StorePage.city = self.cityname
                StorePage.country = self.countryname
                StorePage.long = String(format:"%@",self.app.long)
                StorePage.lat = String(format:"%@",self.app.lat)
                StorePage.ranking = "0"
                StorePage.img_url = imageurl
                StorePage.points = ""
                
                self.present(StorePage, animated: true, completion: nil)
            }
            else
            {
                Toast.long(message: "Something went wrong", success: "0", failer: "1")
            }
            self.view.isUserInteractionEnabled = false
            self.view.isUserInteractionEnabled = true

            SVProgressHUD.dismiss()
        }) { (error) in
            Toast.long(message: "Something went wrong", success: "0", failer: "1")
        }

    }
    
    @IBAction func backBtnPressed(sender:Any)
    {
        self.dismiss(animated: true, completion: nil)
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


//let data = JSON(jsonArr[(indexPath?.row)!])
//print(data)
//let photoRef = data["photos"][0]["photo_reference"].string
//print(photoRef)
//
//// DispatchQueue.global(qos: .background).async {
//print("This is run on the background queue")
//
////    DispatchQueue.main.async {
//print("This is run on the main queue, after the previous code in outer block")
//if photoRef != nil
//{
//
//    let firstObj1:String = String(format:"https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&key=AIzaSyAhBZsez76ZAwrMHb7MZP4PpkDbKCnCjkU&photoreference=%@",photoRef!)
//    // print(firstObj1)
//    StorePage.img_url = firstObj1
//    //cell.placeImage.sd_setImage(with: URL.init(string: firstObj1), placeholderImage: nil, options: .continueInBackground, completed: nil)
//}
////  }
//// }
//SVProgressHUD.dismiss()
//print(data["geometry"]["location"].dictionary)
//let location = data["geometry"]["location"].dictionary


