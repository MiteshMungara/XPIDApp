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



class NearLocationInterfaceController: WKInterfaceController, CLLocationManagerDelegate {
    var currentLocation = CLLocation()
    var lat:Double = 0.0
    var long:Double = 0.0
    
    @IBOutlet weak var tableV: WKInterfaceTable!
    //var dataar = ["654","862","860","862","860","862","860","862","860","862","860"]//,802,774,716,892,775,748,886,835]
    var placenameArr = [String]()
    var addressArr = [String]()
    var placeimageArr = [String]()
    
    @IBOutlet weak var lblLocation : WKInterfaceLabel!
    
    //Loader
    @IBOutlet var loader: WKInterfaceImage!
    @IBOutlet var lblTopHeader : WKInterfaceLabel!
    
    
    func connectShow()
    {
        lblTopHeader.setHidden(false)
    }
    
    func connectHide()
    {
        lblTopHeader.setHidden(true)
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
    
    override func awake(withContext context: Any?)  {
        super.awake(withContext: context)
        nearestLocation()
        
    }
    func tableRefresh(){
        
//        self.tableV.setNumberOfRows(dataar.count, withRowType: "locationcell")
//        for i in 0..<dataar.count
//        {
//            let row = self.tableV.rowController(at: i) as! RowController //TableRowController
//            //            var rowString = String(format: "Split:%02i miles", index + 1)
//            //            let paceString = "Pace:" + paceSeconds(data[index])
//           // let data = recordArr[i]
//            let rowString = dataar[i]//["name"]as! String
//            row.splits.setText(rowString)
//            //row.time.setText(paceString)
//        }
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
                self.tableRefresh()
        WatchConnector.shared.listenToMessageBlock({ (message) in
    
            self.lat = message["lat"] as! Double
            self.long = message["long"] as! Double
            print(self.lat)
            print(self.long)
            
            self.currentLocation = CLLocation(latitude: self.lat as! CLLocationDegrees, longitude: self.long as! CLLocationDegrees)
            
            let mylocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: mylocation, span: span)
           // self.mapView.setRegion(region)
          //  self.mapView.addAnnotation(mylocation, with: .red)
        }, withIdentifier: "sendCurrentLocation")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func btnFindLocation()
    {
      //  self.lblLatitude.setText("\(self.lat)")
        //self.lbllongitude.setText("\(self.long)")
    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        
//        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) in
//            
//            if (placemarks?.count)! > 0
//            {
//                let cPlacemarks = placemarks![0]
//                self.displayLocation(placemark: cPlacemarks)
//            }
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = locations[0]
        let lat = currentLocation.coordinate.latitude
        let long = currentLocation.coordinate.longitude
        print(long)
        print(lat)
       // self.mapLocation = CLLocationCoordinate2DMake(lat, long)
        
       // let span = MKCoordinateSpanMake(0.1, 0.1)
        
       // let region = MKCoordinateRegionMake(self.mapLocation!, span)
        //self.mapObject.setRegion(region)
        
        //self.mapObject.addAnnotation(self.mapLocation!,
                                   //  withPinColor: .Red)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
       // print(error.description)
    }
    
    
//    func displayLocation(placemark:CLPlacemark)
//    {
//        locationManager.stopUpdatingLocation()
//        let locality = placemark.locality
//        let postalCode = placemark.postalCode
//        let adminstrativeArea = placemark.administrativeArea
//        let country = placemark.country
//        
//        lblLocation.setText("locality : \(locality) country \(country) administrativeArea \(adminstrativeArea)")
//    }
    
    @IBAction func enrterLocationBtnPressed(sender:Any)
    {
        self.pushController(withName: "RatingVC", context: self)
    }

    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
        let placename = self.placenameArr[rowIndex]
     
        let address = self.addressArr[rowIndex]
        let placeimage = self.placeimageArr[rowIndex]
        
        UserDefaults.standard.set(placename, forKey: "placename")
        UserDefaults.standard.set(address, forKey: "address")
        UserDefaults.standard.set(placeimage, forKey: "placeimage")
         self.pushController(withName: "RatingVC", context: self)
    }
    
    func nearestLocation()
    {
        showLoader()
        connectHide()
        let long = UserDefaults.standard.string(forKey: "long")
        let lat = UserDefaults.standard.string(forKey: "lat")
        if long != "" && lat != ""
        {
            
            
           // let request = NSMutableURLRequest(url: NSURL(string: String(format:"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=5000&keyword=starbucks&key=AIzaSyAhBZsez76ZAwrMHb7MZP4PpkDbKCnCjkU",long!,lat!))! as URL)
            let url = URL(string: String(format:"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=5000&key=AIzaSyDBGAAMADwCNKqGclqwNyWWNKTdGEszd4I",String(format: "%@", lat!),String(format: "%@", long!)))
            
            //trail : AIzaSyAhBZsez76ZAwrMHb7MZP4PpkDbKCnCjkU
            //AIzaSyDBGAAMADwCNKqGclqwNyWWNKTdGEszd4I
            //&keyword=starbucks
            print(url)
            URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
                guard let data = data, error == nil else { return }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    print(json)
                    var firstObj:String = ""
                    if error != nil
                    {
                        print("Error: " + error.debugDescription)
                        return
                    }
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        print(json)
                        if json != nil
                        {
                            let isDataExist = json!["results"]
                            if ((isDataExist as AnyObject).count)! < 0 || isDataExist == nil
                            {
                                return
                            }
                            
                            let dataAr = json!["results"]! as? [[String : AnyObject]]
                            
                            print(dataAr)
                            print(dataAr?.count)
                           
                            if dataAr?.count != 0 //|| photoRef != nil
                            {
                                let photoRef = dataAr![0]["photos"]![0]//["photo_reference"] as? String
                                
                                
                                self.placenameArr = [String]()
                                self.addressArr = [String]()
                                self.placeimageArr = [String]()
                                
                                let recordArr = json!["results"]! as! [[String : AnyObject]]
                                self.tableV.setNumberOfRows(recordArr.count, withRowType: "locationcell")
                                for i in 0..<recordArr.count
                                {
                                    let row = self.tableV.rowController(at: i) as! RowController //TableRowController
                                    
                                    let data = recordArr[i]
                                    let address = data["vicinity"] as! String
                                    let rowString = data["name"] as! String
                                    
                                    row.splits.setText(rowString)
                                    //row.time.setText(paceString)
                                    if dataAr![i]["photos"] != nil
                                    {
                                        if let photoRef = dataAr![i]["photos"]![0] as? [String:AnyObject]//["photo_reference"] as? String
                                            
                                        {
                                            
                                            let mm = photoRef["photo_reference"] as? String
                                            firstObj = String(format:"https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photoreference=%@&key=AIzaSyDBGAAMADwCNKqGclqwNyWWNKTdGEszd4I",(mm!))
                                            print(firstObj)
                                            //trail : AIzaSyBLoPujJRpBq3FYge80p-Tbh4_tPOEkiyo
                                            //trail : AIzaSyAhBZsez76ZAwrMHb7MZP4PpkDbKCnCjkU
                                            //AIzaSyDBGAAMADwCNKqGclqwNyWWNKTdGEszd4I
                                            self.placenameArr.append(rowString)
                                            self.addressArr.append(address)
                                            self.placeimageArr.append(firstObj)
                                        }
                                    }
                                   else
                                    {
                                        self.placenameArr.append(rowString)
                                        self.addressArr.append(address)
                                        self.placeimageArr.append("")
                                    }
                                    
                                }
                                
                            }
                        }
                      
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                    // let posts = json["posts"] as? [[String: Any]] ?? []
                    //print(posts)
                } catch let error as NSError {
                    print(error)
                }
                
                self.connectShow()
                self.stopLoader()
            }).resume()
        }
        
    }
}


