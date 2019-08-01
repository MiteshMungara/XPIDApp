//
//  InterfaceController.swift
//  XPIDApp WatchKit Extension
//
//  Created by Mits on 6/6/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation

class InterfaceController: WKInterfaceController , CLLocationManagerDelegate{
   
    let locationManager = CLLocationManager()
    let extDel = ExtensionDelegate.self
    
    @IBOutlet var loader: WKInterfaceImage!
    @IBOutlet var logoImgV: WKInterfaceImage!
    @IBOutlet var infoLabel: WKInterfaceLabel!
    @IBOutlet var lineSap: WKInterfaceSeparator!
    @IBOutlet var postBtn: WKInterfaceButton!
    
    
    //===========
    func showLoader() {
        self.setLoader(hidden: false)
        loader.setImageNamed("loader")
        loader.startAnimatingWithImages(in: NSRange(location: 1,
                                                    length: 8), duration: 0.8, repeatCount: -1)
    }
  
    func HomeHide()
    {
        postBtn.setHidden(true)
        lineSap.setHidden(true)
        infoLabel.setHidden(true)
        logoImgV.setHidden(true)
    }

    func HomeShow()
    {
        postBtn.setHidden(false)
        lineSap.setHidden(false)
        infoLabel.setHidden(false)
        logoImgV.setHidden(false)
    }
    
    func stopLoader() {
        self.loader.stopAnimating()
        self.setLoader(hidden: true)
    }
    private func setLoader(hidden:Bool) {
        self.loader.setHidden(hidden)
      //  self.button.setHidden(!hidden)
    }
    
    
   //=====================
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.locationManager.requestWhenInUseAuthorization()
        HomeShow()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
       // self.allmapView.showsUserLocation = true
        //        self.appDel.locationManagerDel.startUpdatingLocation()
        
        // Check for Location Services
        
//        if CLLocationManager.locationServicesEnabled() {
//            self.locationManager.requestWhenInUseAuthorization()
//            self.locationManager.startUpdatingLocation()
//        }
 //       self.allmapView.layer.borderColor = UIColor.gray.cgColor
   //     self.allmapView.layer.borderWidth = 1
    }
    
    
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func postXPBtnPressed(sender:Any)
    {
       let email = UserDefaults.standard.string(forKey: "email")
        if email == "" || email == nil
        {
             self.pushController(withName: "ConnectToIphoneVC", context: self)
            //loginVC()
        }
        else
        {
             self.pushController(withName: "Location", context: self)
        }
    }

    
    func loginVC()
    {
        HomeHide()
      //  let url = NSURL(string: "http://techspak.com/xpidapp/app/connectapplewatch.php")
         self.showLoader()
        let request = NSMutableURLRequest(url: NSURL(string: "http://xpid.me/app/connectapplewatch.php")! as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        let params = ["date":"19-10-2018","iphone_active":"0","applewatch_active":"1","u_id":"0","u_email":""] as Dictionary<String, String>
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            //print("Response: \(response)")
            
//            let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print("Body: \(strData)")
            
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
                    let code = json!["code"] as? String
                    let active = json!["active_pin"] as? String
                    UserDefaults.standard.set(code, forKey: "code")
                    UserDefaults.standard.set(active, forKey: "activa_code")
                    
                    self.pushController(withName: "ConnectToIphoneVC", context: self)
                }
      
                } catch {
                    print(error.localizedDescription)
                }
            self.HomeShow()
            self.stopLoader()
        })
      
    task.resume()
        
        
//        let is_URL: String = "http://techspak.com/xpidapp/app/connectapplewatch.php"
//        let postString = String(format: "date=%@", arguments: ["13-03-2019"])
//
//
//        let lobj_Request = NSMutableURLRequest(url: NSURL(string: is_URL)! as URL)
//        let session = URLSession.shared
//        var err: NSError?
//
//        lobj_Request.httpMethod = "POST"
//        lobj_Request.httpBody = postString.data(using: String.Encoding.utf8, allowLossyConversion: true)
//
//        // lobj_Request.HTTPBody = is_SoapMessage.dataUsingEncoding(NSUTF8StringEncoding)
//        // lobj_Request.addValue("www.cgsapi.com", forHTTPHeaderField: "Host")
//        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        // lobj_Request.addValue(String(count(is_SoapMessage)), forHTTPHeaderField: "Content-Length")
//        //lobj_Request.addValue("223", forHTTPHeaderField: "Content-Length")
//        //  lobj_Request.addValue("http://www.cgsapi.com/GetSystemStatus", forHTTPHeaderField: "SOAPAction")
//
//        let task = session.dataTask(with: lobj_Request as URLRequest, completionHandler: {data, response, error -> Void in
//            //print("Response: \(response)")
//            let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print("Body: \(strData)")
//
//            if error != nil
//            {
//                print("Error: " + error.debugDescription)
//                return
//            }
//             self.pushController(withName: "Location", context: self)
//        })
//        task.resume()
    }
    
  
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let location:CLLocation = locations.last!
        //        app.lat = "\(locValue.longitude)"
        //        app.long = "\(locValue.latitude)"
        //        nearestLocation()
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let long = String(format: "%f", location.coordinate.longitude)//(jsonDict!["lng"] as? String)!
        let lat = String(format: "%f", location.coordinate.latitude) //(locValue.latitude as? String)!
        //let long = UserDefaults.standard.string(forKey: "long")
        //let lat = UserDefaults.standard.string(forKey: "lat")
        
        UserDefaults.standard.set(long, forKey: "long")
        UserDefaults.standard.set(lat, forKey: "lat")
        let userid = UserDefaults.standard.string(forKey: "login")
        if userid == "1"
        {
          //  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(webservice), userInfo: nil, repeats: false)
        }
       
        
     //  let location = String(format:"%@ %@",long,lat)
        UserDefaults.standard.set(long, forKey:"long")
        UserDefaults.standard.set(lat, forKey:"lat")
//        UserDefaults.standard.set(uid, forKey:"uid")
//        UserDefaults.standard.set(uname, forKey:"uname")
        
    }
    
    
    
    @objc func webservice()
    {
        HomeHide()
        self.showLoader()
        let long = UserDefaults.standard.string(forKey:"long")//self.currentLocation.coordinate.longitude
        let lat = UserDefaults.standard.string(forKey:"lat")//self.currentLocation.coordinate.latitude
     
        let date = NSDate()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy";
        let currentDate = dateformatter.string(from: date as Date)//"12/02/2019"
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://xpid.me/app/uploadlocation.php")! as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        let params = ["uid":"NO","status":"update","uname":"mitesh","long":String(format: "%@", long!),"lat":String(format: "%@", lat!),"datetime":currentDate] as Dictionary<String, String>
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            //print("Response: \(response)")
            
            //            let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //            print("Body: \(strData)")
            
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
                    
                    print(success)
                    //                    let uid = (jsonDict!["uid"] as? String)!
                    //                    let uname = (jsonDict!["uname"] as? String)!
                    //                    self.long = (jsonDict!["lng"] as? String)!
                    //                    self.lat = (jsonDict!["lat"] as? String)!
                    //                    let location = String(format:"%@ %@",self.long,self.lat)
                    //                    UserDefaults.standard.set(self.long, forKey:"long")
                    //                    UserDefaults.standard.set(self.lat, forKey:"lat")
                    //                    UserDefaults.standard.set(self.long, forKey:"long")
                    //                    UserDefaults.standard.set(uid, forKey:"uid")
                    //                    UserDefaults.standard.set(uname, forKey:"uname")
                    
                    //                    let code = json!["code"] as? String
                    //                    let active = json!["active_pin"] as? String
                    //                    UserDefaults.standard.set(code, forKey: "code")
                    //                    UserDefaults.standard.set(active, forKey: "activa_code")
                    //
                    //                    self.pushController(withName: "ConnectToIphoneVC", context: self)
                }
                
            } catch {
                print(error.localizedDescription)
            }
            
            self.HomeShow()
               self.stopLoader()
        })
        
        task.resume()
        
        
        //
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
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isMember(of: MKUserLocation.self) {
            return nil
        }
        
        let reuseId = "ProfilePinView"
        
        pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            // pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        pinView.image = UIImage(named: "pin")
        
        //
        pinView.canShowCallout = true
        pinView.isDraggable = true
        
        //let img = #imageLiteral(resourceName: "ic_map_pin")//UIImage(named: "ic_map_pin")
        //img.size = CGSize(width: 18, height: 18)//CGRect(x: 0, y: 0, width: 18, height: 18)
        // pinView.image =
        
        
        return pinView
        
    }
    */
    /*
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        
        if newState == MKAnnotationViewDragState.ending {
            if let coordinate = view.annotation?.coordinate {
                
                //  let coordinate = view.annotation?.coordinate
                print(coordinate.latitude)
                //allmapView.removeAnnotations(allmapView.annotations)
                
                self.longlocation = "\(coordinate.longitude)"
                self.latilocation = "\(coordinate.latitude)"
                view.dragState = MKAnnotationViewDragState.none
                
            }
        }
    }
 */
 
   /* func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count != 0
        {
            return
        }
        let location = locations.last! as CLLocation
        let coordinates:CLLocationCoordinate2D = location.coordinate
        //self.longlocation = "\(coordinates.longitude)"
       // self.latilocation = "\(coordinates.latitude)"
        print("long: \(coordinates.longitude)")
        print("lat : \(coordinates.latitude)")
        
        //
      /*  if self.annotation != nil
        {
            self.allmapView.removeAnnotations(self.allmapView.annotations)
        }
        let location = locations.last! as CLLocation
        let coordinates:CLLocationCoordinate2D = location.coordinate
        self.longlocation = "\(coordinates.longitude)"
        self.latilocation = "\(coordinates.latitude)"
        // 3)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        allmapView.setRegion(region, animated: true)
        
        // 4)
        
        self.annotation = MKPointAnnotation()
        self.annotation.coordinate = coordinates
        self.annotation.title = "Current Location"
        // self.annotation.subtitle = "User"
        allmapView.addAnnotation(self.annotation)
        allmapView.showsUserLocation = false
        self.locationManager.stopUpdatingLocation()
        */
    }*/
    /*
    func mapView(_ rendererFormapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 2
        return renderer
    }
 */
}



//
//extension WKInterfaceController
//{
//
//    func loginVC()
//    {
//
//
//
//        //Parameter
////        let parameters = [
////            "email":""//emailAddTextF.text
////        ]
////        print(parameters)
////        RequestWebService.sharedInstance.requestPOSTURL("login.php", params: parameters as [String : AnyObject]?, headers: nil, view: self, success: { (json) in
////            // success code
////            print(json)
////            //   let response = json as? NSDictionary
////            let success = json["Success"].string
////            if success == "1"
////            {
////                print(success)
////                Toast.long(message: "Login Successfully", success: "1", failer: "0")
////
////                //   self.performSegue(withIdentifier: "HomeScreenVC", sender: self)
////                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
////                let StorePage = storyBoard.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
////                self.present(StorePage, animated: true, completion: nil)
////            }
////            else
////            {
////                Toast.long(message: "Login Invalid", success: "0", failer: "1")
////            }
////
////        }, failure: { (error) in
////            //error code
////
////            print(error)
////        })
//        //
//    }
//}
