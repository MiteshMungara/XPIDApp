//
//  ExtensionDelegate.swift
//  XPIDApp WatchKit Extension
//
//  Created by Mits on 6/6/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    var long = ""
    var lat = ""
    
    
    func applicationDidFinishLaunching() {
//        UserDefaults.standard.set("1", forKey: "login")
        let login = UserDefaults.standard.string(forKey:"login")
        if login == "1"
        {
       //     guard let  WKExtension.shared().rootInterfaceController as? NearLocationInterfaceController else{
           // return
       // }
            //prese.pushController(withName: "Location", context: self)
        }
        locationget()
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    func locationget()
    {
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://xpid.me/app/getlocation.php")! as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        let params = ["uid":"1"] as Dictionary<String, String>
        
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
                    let jsonDict = json!["post"] as? [String:AnyObject]
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
            
        })
        
        task.resume()
    }
}
