//
//  AppDelegate.swift
//  XPIDApp
//
//  Created by Mits on 6/6/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

//com.mittech.hanumanchalisaapp.XPIDApp
//
// Indoor map : AIzaSyB8TShJMnUGY5I3b0EZVwbQRQn6Qn3-3Z8

import UIKit
import CoreLocation
import MapKit
import CoreLocation
import FBSDKLoginKit
import GoogleSignIn
import IQKeyboardManagerSwift

//1977913369178892
//659813211086837

@UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate ,CLLocationManagerDelegate{

    var window: UIWindow?
    let locationManager:CLLocationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var long : String = ""
    var lat : String = ""
    let facebookURL:String = "fb617712668684841"
    var userid : String = ""
    var useremail : String = ""
    var username  = ""
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//
//        return true
//    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        WatchConnector.shared.activateSession()
        IQKeyboardManager.shared.enable = true
        

        let userid = UserDefaults.standard.object(forKey: "userid") ?? nil
        print(userid as Any)
        if userid != nil
        {
            //UserDefaults.standard.set(self.app?.username, forKey: "username")
           // UserDefaults.standard.removeObject(forKey: "username")
           // UserDefaults.standard.removeObject(forKey: "username")
            username = UserDefaults.standard.string(forKey: "username")!
            print(username)
            let app = UIApplication.shared.delegate as? AppDelegate
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeScreenVC")

            app?.window?.rootViewController = initialViewController
            app?.window?.makeKeyAndVisible()
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let StorePage = storyBoard.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
//            self.present(StorePage, animated: true, completion: nil)

        }
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestLocation()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.allowsBackgroundLocationUpdates = true
        //webservice()
//        WatchConnector.shared.activateSession()
//
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.requestLocation()
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
        GIDSignIn.sharedInstance().clientID = "329879034839-c7cek8rpl42p8vv6quv7jvn48qp6nvjq.apps.googleusercontent.com"
        //        GIDSignIn.sharedInstance().delegate = self
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)//93//
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let urlstring:String = url.absoluteString
        if urlstring.contains(facebookURL) {
            
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options [UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
            
        }
        
        return GIDSignIn.sharedInstance().handle(url as URL!,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count == 0
        {
            return
        }
        
        self.currentLocation = locations.first!
            let message = ["lat":self.currentLocation.coordinate.latitude,"long":self.currentLocation.coordinate.longitude]
            WatchConnector.shared.sendMessage(message, withIdentifier: "sendCurrentLocation") { (error) in
                print("error in send message to watch\(error.localizedDescription)")
                
                DispatchQueue.global(qos: .background).async {
                    print("This is run on the background queue")
                    
                    DispatchQueue.main.async {
                        print("This is run on the main queue, after the previous code in outer block")
                        do
                        {
                            let userid = UserDefaults.standard.object(forKey: "userid") ?? nil
                            print(userid as Any)
                            if userid != nil
                            {
                                self.webservice()
                            }
                        }
                        catch
                        {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Fail to load location")
        print(error.localizedDescription)
    }
    
    
    func webservice()
    {
        
        let long = self.currentLocation.coordinate.longitude
        let lat = self.currentLocation.coordinate.latitude
        
        let parameters = [
            "status":"update",
            "uid":"2",
            "uname":"mitesh",
            "long":String(format: "%f", long),
            "lat":String(format: "%f", lat),
            "datetime":"19-09-2019"
        ]
        print(parameters)
        RequstJsonClass.sharedInstance.requestPOSTURL("uploadlocation.php", params: parameters as [String : AnyObject]?, headers: nil, view: (window?.rootViewController)!, success: { (json) in
            // success code
           // print(json)
            //   let response = json as? NSDictionary
            
            let success = json["Success"].string
            if success == "1"
            {
                //print(success)
//                Toast.long(message: "Login Successfully", success: "1", failer: "0")
//
//                //   self.performSegue(withIdentifier: "HomeScreenVC", sender: self)
//                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let StorePage = storyBoard.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
//                self.present(StorePage, animated: true, completion: nil)
            }
            else
            {
//                Toast.long(message: "Login Invalid", success: "0", failer: "1")
            }
            
        }, failure: { (error) in
            //error code
            
            print(error)
        })
        //
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

