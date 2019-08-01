//
//  HomeScreenVC.swift
//  XPIDApp
//
//  Created by Mits on 6/6/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SwiftyJSON
import SDWebImage
import SVProgressHUD

class HomeScreenVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var myXPView:UIView!
    @IBOutlet var myGlobalHistoryView:UIView!
    @IBOutlet var myPromotionsInAreaView:UIView!
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var firstObj : String = ""
    var citystr = ""
    var countrystr = ""
    @IBOutlet var placeImgV : UIImageView!
    @IBOutlet var placename : UIImageView!
    
    @IBOutlet var myxpView : UIView!
    @IBOutlet var historyView : UIView!
    @IBOutlet var watchView : UIView!
    @IBOutlet var postxpView : UIView!
    
    @IBOutlet var connectBtn : UIButton!
    
    var jsonArr = NSArray()
    
    let app = UIApplication.shared.delegate as! AppDelegate
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        myxpView.layer.cornerRadius = 10
        postxpView.layer.cornerRadius = 10
        historyView.layer.cornerRadius = 10
        watchView.layer.cornerRadius = 10
        connectBtn.layer.cornerRadius = 10
        
        // For use in foreground
      
        // Do any additional setup after loading the view.
        
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        nearestLocation()
    }
    
    
    @IBAction func gotoLocationBtnPressed(sender:Any)
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        nearestLocation()
        self.view.isUserInteractionEnabled = true

        SVProgressHUD.dismiss()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        app.lat = "\(locValue.latitude)"
        app.long = "\(locValue.longitude)"
        nearestLocation()
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
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
    }
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            
            print("your location is:-",containsPlacemark)
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            var country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            citystr = locality!
            //postalCodeTxtField.text = postalCode
            //aAreaTxtField.text = administrativeArea
            countrystr = country!
        }
        
    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if locations.count == 0
//        {
//            return
//        }
//        self.currentLocation = locations.first!
//        let message = ["lat":self.currentLocation.coordinate.latitude,"long":self.currentLocation.coordinate.longitude]
//        //        WatchConnector.shared.sendMessage(message, withIdentifier: "sendCurrentLocation") { (error) in
//        //   print("error in send message to watch\(error.localizedDescription)")
//        //}
//        
//    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    /*
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if locations.first != nil {
            print("location:: (location)")
        }

    }
*/
    
   
    
    
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
    @IBAction func SettingBtnPressed(sender:Any)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let StorePage = storyBoard.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        self.present(StorePage, animated: true, completion: nil)
    }

    @IBAction func postmyxpBtnPressed(sender:Any)
    {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let StorePage = storyBoard.instantiateViewController(withIdentifier: "LocationListVC") as! LocationListVC
        StorePage.city = citystr
        StorePage.country = countrystr
        self.present(StorePage, animated: true, completion: nil)
        
        //self.performSegue(withIdentifier: "LocationListVC", sender: self)
    }

    @IBAction func applewatchConnectBtnPressed(sender:Any)
    {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let StorePage = storyBoard.instantiateViewController(withIdentifier: "AppleWatchConnectVC") as! AppleWatchConnectVC
        self.present(StorePage, animated: true, completion: nil)
        
        //self.performSegue(withIdentifier: "LocationListVC", sender: self)
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


extension HomeScreenVC
{
    func nearestLocation()
    {
        if app.long != "" && app.lat != ""{
            
            //SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false

            let urlLink = String(format:"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=5000&key=AIzaSyDBGAAMADwCNKqGclqwNyWWNKTdGEszd4I",app.lat,app.long)
            //https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=72.9890,28.9878&radius=5000&key=AIzaSyDBGAAMADwCNKqGclqwNyWWNKTdGEszd4I
            // trail : AIzaSyAhBZsez76ZAwrMHb7MZP4PpkDbKCnCjkU
            //AIzaSyDBGAAMADwCNKqGclqwNyWWNKTdGEszd4I
            //&keyword=starbucks
            RequstJsonClass.sharedInstance.requestGETSingleURL(urlLink, view: self, success: { (json) in
                //            print(json)
                //   let response = json as? NSDictionary
                if json != nil
                {
                    let isDataExist = json["results"].array
                    if (isDataExist?.count)! < 0 || isDataExist == nil
                    {
                        return
                    }
                    let dataAr = JSON(json["results"].array as Any)
                    print(dataAr)
                    print(dataAr.count)
                    let photoRef = dataAr[0]["photos"][0]//["photo_reference"] as? String
                    
                    if dataAr.count != 0 || photoRef != nil
                    {
                        self.jsonArr = dataAr.array as! NSArray
                        
                        let photoRef = dataAr[0]["photos"][0]//["photo_reference"] as? String
                        
                        print(JSON(photoRef["photo_reference"]))
                        if let mm:String = photoRef["photo_reference"].string
                        {
                            
                        print(mm)
                        print(photoRef["photo_reference"])
                        self.firstObj = String(format:"https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photoreference=%@&key=AIzaSyDBGAAMADwCNKqGclqwNyWWNKTdGEszd4I",mm)
                            
                            // trail :AIzaSyAhBZsez76ZAwrMHb7MZP4PpkDbKCnCjkU
                            //AIzaSyDBGAAMADwCNKqGclqwNyWWNKTdGEszd4I
                        print(self.firstObj)
                        self.placeImgV.sd_setImage(with: URL.init(string: self.firstObj), placeholderImage: nil, options: .continueInBackground, completed: nil)
                        }
                    }
                }
                self.view.isUserInteractionEnabled = true
                self.view.isUserInteractionEnabled = true

                SVProgressHUD.dismiss()
                SVProgressHUD.dismiss()
            }) { (error) in
                self.view.isUserInteractionEnabled = true

                SVProgressHUD.dismiss()
                print(error)
                
            }
        }
        
    }
}
