//
//
//  RequstJsonClass.swift
//  BandiPlace
//
//  Created by Mits on 11/10/17.
//  Copyright © 2017 Mits. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

//http://xpid.me

//let kDevelopmentURL             = "http://techspak.com/xpidapp/"
//let kProductionURL              = "http://techspak.com/xpidapp/"

let kDevelopmentURL             = "http://xpid.me/"
let kProductionURL              = "http://xpid.me/"

let kSiteURL                    = kDevelopmentURL
let kBasePath                   = kSiteURL + "app/"


// MARK:  Block
typealias WSBlock       = (_ json: Any?, _ flag: Int) -> ()
typealias WSFileBlock   = (_ path: URL, _ success: Bool) -> ()
typealias WSUploadBlock = (_ success: Bool) -> ()


let tab_color_title = UIColor(red: 252.0/255.0, green: 216.0/255.0, blue: 93.0/255.0, alpha: 1)
class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
class RequstJsonClass: NSObject {
    let lang = UserDefaults.standard.string(forKey: "Lang")
    var message: String = ""
    // Two Method for Service
    //1. encoding: JSONEncoding.default,
    //2. encoding: URLEncoding.default
    static let sharedInstance = RequstJsonClass()
    var alertShow = commanfunctions()
    //TODO :-
    /* Handle Time out request alamofire */
    
    func requestGETURL(_ strURL: String, view:UIViewController,success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void)
    {
        let reachability = Reachability()!
    
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
         
                Toast.long(message: "No Internet Connection Found", success: "0", failer: "1")
            // self.alertShow.showInternetConnectionAlert("","No Internet Connection Found", view: view)
            SVProgressHUD.dismiss()
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        reachability.stopNotifier()
        
        if Connectivity.isConnectedToInternet()
        {
            Alamofire.request(kBasePath + strURL,encoding: URLEncoding.default).responseJSON { (responseObject) -> Void in
                //print(responseObject)
                if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    //let title = resJson["title"].string
                    //print(title!)
                    success(resJson)
                }
                
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
            }
            print("Yes! internet is available.")
            // do some tasks..
        }
        else
        {
        }
    }
    
    
    func requestGETSingleURL(_ strURL: String, view:UIViewController,success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void)
    {
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            
                Toast.long(message: "No Internet Connection Found", success: "0", failer: "1")
            // self.alertShow.showInternetConnectionAlert("","No Internet Connection Found", view: view)
            SVProgressHUD.dismiss()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        reachability.stopNotifier()
        
        if Connectivity.isConnectedToInternet()
        {
            Alamofire.request(strURL,encoding: URLEncoding.default).responseJSON { (responseObject) -> Void in
                //print(responseObject)
                if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    //let title = resJson["title"].string
                    //print(title!)
                    success(resJson)
                }
                
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
            }
            print("Yes! internet is available.")
            // do some tasks..
        }
        else
        {
        }
    }
    
    
    func requestPOSTSingleURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, view:UIViewController, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        let fullURL = strURL
        let reachability = Reachability()!
        print(fullURL)
        print(params)
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
         
                Toast.long(message: "No Internet Connection Found", success: "0", failer: "1")
            //self.alertShow.showInternetConnectionAlert("","No Internet Connection Found", view: view)
            SVProgressHUD.dismiss()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        reachability.stopNotifier()
//        let header = [
//            "Accept": "application/json",
//            "Content-Type": "multipart/form-data",
//            "Authorization": "(type) "+token
//        ]
//        let headers = ["Content-Type": "application/json"]
        //application/x-www-form-urlencoded
//       "Content-Type" = "text/html; charset=UTF-8";
        if Connectivity.isConnectedToInternet()
        {
            Alamofire.request(fullURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
                print(responseObject)
                if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    success(resJson)
                }
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
            }
        }
        else
        {
        }
    }
    
    func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, view:UIViewController, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        let fullURL = kBasePath + strURL
        let reachability = Reachability()!
        print(fullURL)
        print(params)
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
           
                Toast.long(message: "No Internet Connection Found", success: "0", failer: "1")
            //self.alertShow.showInternetConnectionAlert("","No Internet Connection Found", view: view)
            SVProgressHUD.dismiss()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        reachability.stopNotifier()
        //        let header = [
        //            "Accept": "application/json",
        //            "Content-Type": "multipart/form-data",
        //            "Authorization": "(type) "+token
        //        ]
        //        let headers = ["Content-Type": "application/json"]
        //application/x-www-form-urlencoded
        //       "Content-Type" = "text/html; charset=UTF-8";
        if Connectivity.isConnectedToInternet()
        {
            Alamofire.request(fullURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
                print(responseObject)
                if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    success(resJson)
                }
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
            }
        }
        else
        {
        }
    }
    
    func request1POSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, view:UIViewController, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        let fullURL = kBasePath + strURL
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            
                Toast.long(message: "No Internet Connection Found", success: "0", failer: "1")
            //self.alertShow.showInternetConnectionAlert("","No Internet Connection Found", view: view)
            SVProgressHUD.dismiss()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        reachability.stopNotifier()
       // let headers = ["Content-Type" :"application/json","forHTTPHeaderField":"Authorization"]
        
        if Connectivity.isConnectedToInternet()
        {
            Alamofire.request(fullURL, method: .post, parameters: params, encoding:     URLEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
                //print(responseObject)
                if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    success(resJson)
                }
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
            }
        }
        else
        {
        }
    }
    
    
    
    func requestPOSTSTRINGURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, view:UIViewController, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
//            self.alertShow.showInternetConnectionAlert("","No Internet Connection Found", view: view)
           
                Toast.long(message: "No Internet Connection Found", success: "0", failer: "1")
            SVProgressHUD.dismiss()
            
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        reachability.stopNotifier()
        
        if Connectivity.isConnectedToInternet()
        {
            let fullURL = kBasePath + strURL
           // let headers = [
           //     "Content-Type": "text/html"
          //  ]
            Alamofire.request(fullURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
                //print(responseObject)
                if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    success(resJson)
                    
                }
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
            }
        }
        else
        {
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func uploadImagesAndData(_ strURL : String,imagesparamater: String,imagesArr: NSArray, params : [String : AnyObject]?, headers : [String : String]?, view:UIViewController,progressive:@escaping (CGFloat)->Void, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        if Connectivity.isConnectedToInternet()
        {
            // let fullURL = "http://miteshpatel.orgfree.com/FileUpload/UploadImage/UploadImages.php"
            //"http://miteshpatel.orgfree.com/FileUpload/UploadImage/UploadImages.php"//
            
            let fullURL = kBasePath + strURL
            let reachability = Reachability()!
            
            reachability.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
            reachability.whenUnreachable = { _ in
                print("Not reachable")
              //  self.alertShow.showInternetConnectionAlert("","No Internet Connection Found", view: view)
               
                    Toast.long(message: "No Internet Connection Found", success: "0", failer: "1")
                SVProgressHUD.dismiss()
                
            }
            
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
            reachability.stopNotifier()
            
            NSLog("\(imagesArr.count)")
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    for (key,value) in params! {
                        if let value = value as? String {
                            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                            
                         //   NSLog("key: \(key) || value :  \(value)")
                        }
                    }
                    
                    var i : Int = 0
                    if imagesArr.count > 0
                    {
                        for (image) in imagesArr {
                            if  let imageData = UIImageJPEGRepresentation(image as! UIImage, 0.2) {
                                
                                multipartFormData.append(imageData, withName: imagesparamater, fileName: "image" + "\(i)" + ".png", mimeType: "image/png")
                            }
                            
                            i += 1
                        }
                    }
            },
                
                to: fullURL,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            if let responseObject = response.result.value as? [String: Any] {
                               // print(jsonResponse)
                                let resJson = JSON(responseObject)
                                
                                NSLog("\(resJson)")
                                success(resJson)
                            }
                            }
                            .uploadProgress { progress in // main queue by default
                                print("Upload Progress: \(progress.fractionCompleted * 100)")
                               // let progressComplete = "\(progress.fractionCompleted * 100)"
                                let processcomplete = CGFloat(progress.fractionCompleted * 100)
                                if processcomplete != 100
                                {
                                    progressive(processcomplete)
                                }
                                else
                                {
                                    progressive(1)
                                }
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        
                    }
            })
        }
        else
        {
        }
    }
    
    
    //  EditStore
    func uploadEditImagesAndData(_ strURL : String,imagePosition:NSArray,coverIndex:Int,imageId:NSArray, params : [String : AnyObject]?, headers : [String : String]?, view:UIViewController,progressive:@escaping (CGFloat)->Void, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        if Connectivity.isConnectedToInternet()
        {
            // let fullURL = "http://miteshpatel.orgfree.com/FileUpload/UploadImage/UploadImages.php"
            //"http://miteshpatel.orgfree.com/FileUpload/UploadImage/UploadImages.php"//
            
            let fullURL = kBasePath + strURL
            let reachability = Reachability()!
            
            reachability.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
            reachability.whenUnreachable = { _ in
                print("Not reachable")
                //  self.alertShow.showInternetConnectionAlert("","No Internet Connection Found", view: view)
                
                    Toast.long(message: "No Internet Connection Found", success: "0", failer: "1")
                SVProgressHUD.dismiss()
                
            }
            
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
            reachability.stopNotifier()
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    for (key,value) in params! {
                        if let value = value as? String {
                            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                            
                               NSLog("key: \(key) || value :  \(value)")
                        }
                    }
                    for i in 0..<imageId.count
                    {
                        
                        let value = imageId[i] as! String
                        let key = "image_id[\(i)]"
                        
                        
                    if i == coverIndex
                    {
                        multipartFormData.append("1".data(using: String.Encoding.utf8)!, withName:"is_cover[\(i)]")
                    }
                    else
                    {
                        multipartFormData.append("0".data(using: String.Encoding.utf8)!, withName:"is_cover[\(i)]")
                        
                    }
                        
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                        
                        
                        // multipartFormData.append(imgid.data(using: String.Encoding.utf8)!, withName: "image_id[\(i)]")
                        let imageposvalue = imagePosition[i] as! String
                        let imageposkey = "image_position[\(i)]"
                        
                        multipartFormData.append("\(imageposvalue)".data(using: String.Encoding.utf8)!, withName: imageposkey as String)
                      
                        
                        // let imgpos = imagePosition[i] as! String
                        //multipartFormData.append(imgpos.data(using: String.Encoding.utf8)!, withName: "image_position[\(i)]")
                        
                        NSLog("pos: image_position[\(i)] : \(value) \(imageposvalue) || image_id[\(i)]")
                        NSLog("pos: image_position[\(i)] : \(value) \(imageposvalue) || image_id[\(i)]")
                        
                    }

                   
                    
                    
            },
                
                
                to: fullURL,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            if let responseObject = response.result.value as? [String: Any] {
                                // print(jsonResponse)
                                let resJson = JSON(responseObject)
                                
                                NSLog("\(resJson)")
                                success(resJson)
                            }
                            }
                            .uploadProgress { progress in // main queue by default
                                print("Upload Progress: \(progress.fractionCompleted * 100)")
                                // let progressComplete = "\(progress.fractionCompleted * 100)"
                              //  let processcomplete = CGFloat(progress.fractionCompleted * 100)
                               // if processcomplete != 100
                               // {
                                 //   progressive(processcomplete)
                               // }
                                //else
                                //{
                                    progressive(1)
                                //}
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        
                    }
            })
        }
        else
        {
        }
    }
    
    
    // Single
    func uploadSingleImageAndData(_ strURL : String,image: UIImage,imageparam: String, params : [String : AnyObject]?, headers : [String : String]?, view:UIViewController,progressive:@escaping (CGFloat)->Void, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        if Connectivity.isConnectedToInternet()
        {
            let fullURL = kBasePath + strURL
            let reachability = Reachability()!
            print(fullURL)
            reachability.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
            reachability.whenUnreachable = { _ in
                print("Not reachable")
               // self.alertShow.showInternetConnectionAlert("","No Internet Connection Found", view: view)
                
                    Toast.long(message: "No Internet Connection Found", success: "0", failer: "1")
                SVProgressHUD.dismiss()
                
            }
            
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
            reachability.stopNotifier()
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    for (key,value) in params! {
                        if let value = value as? String {
                            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                        }
                    }
                    if imageparam != "noimage"
                    {
                        if  let imageData = UIImageJPEGRepresentation(image , 0.25) {
                            
                            multipartFormData.append(imageData, withName: imageparam, fileName: "image" + "profile" + ".png", mimeType: "image/png")
                        }
                    }
                    
                    
            },
                
                to: fullURL,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            if let responseObject = response.result.value as? [String: Any] {
                                // print(jsonResponse)
                                let resJson = JSON(responseObject)
                                
                                NSLog("\(resJson)")
                                success(resJson)
                            }
                            }
                            .uploadProgress { progress in // main queue by default
                                print("Upload Progress: \(progress.fractionCompleted * 100)")
                                // let progressComplete = "\(progress.fractionCompleted * 100)"
                                let processcomplete = CGFloat(progress.fractionCompleted * 100)
                                if processcomplete != 100
                                {
                                    progressive(processcomplete)
                                }
                                else
                                {
                                    progressive(1)
                                }
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        
                    }
            })
        }
        else
        {
        }
    }
    
    //=========================
    //  Build Coupon
    func requestFollowerListPOSTSTRINGURL(_ strURL : String,followeridArr:NSArray, params : [String : AnyObject]?,allfollower: String, headers : [String : String]?, view:UIViewController,progressive:@escaping (CGFloat)->Void, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        if Connectivity.isConnectedToInternet()
        {
            let fullURL = kBasePath + strURL
            let reachability = Reachability()!
            
            reachability.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
            reachability.whenUnreachable = { _ in
                print("Not reachable")
                    //  self.alertShow.showInternetConnectionAlert("","No Internet Connection Found", view: view)  
               
                    Toast.long(message: "No Internet Connection Found", success: "0", failer: "1")
                SVProgressHUD.dismiss()
                
            }
            
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
            reachability.stopNotifier()
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    for (key,value) in params! {
                        if let value = value as? String {
                            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                            
                               NSLog("key: \(key) || value :  \(value)")
                        }
                    }
                    if followeridArr.count != 0
                    {
                        for i in 0..<followeridArr.count
                        {
                            
                            let followerId = followeridArr.object(at: i) as! String
                           
                            let value = String(format: "%@", followerId)
                            let key = String(format:"follower_id[%d]",i)
                            
                            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                           NSLog("key: \(key) || value: \(value)")
                            // multipartFormData.append(followerId.data(using: String.Encoding.utf8)!, withName: "follower_id[\(i)]")
                            
                        }
                    }
            },
                
                
                to: fullURL,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            if let responseObject = response.result.value as? [String: Any] {
                                // print(jsonResponse)
                                let resJson = JSON(responseObject)
                                
                                NSLog("\(resJson)")
                                success(resJson)
                            }
                            }
                            .uploadProgress { progress in // main queue by default
                                print("Upload Progress: \(progress.fractionCompleted * 100)")
                                
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        
                    }
            })
        }
        else
        {
        }
    }
 
    
    
    
    
    
    func uploadSubmitReviewImagesAndData(_ strURL : String,imageArr: NSArray,imageparam: String, params : [String : AnyObject]?, headers : [String : String]?, view:UIViewController,progressive:@escaping (CGFloat)->Void, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        if Connectivity.isConnectedToInternet()
        {
            let fullURL = kBasePath + strURL
            let reachability = Reachability()!
            
            reachability.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
            reachability.whenUnreachable = { _ in
                print("Not reachable")
                //  self.alertShow.showInternetConnectionAlert("","No Internet Connection Found", view: view)
               
                    Toast.long(message: "No Internet Connection Found", success: "0", failer: "1")
                SVProgressHUD.dismiss()
                
            }
            
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
            reachability.stopNotifier()
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    for (key,value) in params! {
                        if let value = value as? String {
                            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                            
                               NSLog("key: \(key) || value :  \(value)")
                        }
                    }
                    
                    var i : Int = 0
                    if imageArr.count > 0
                    {
                        for (image) in imageArr {
                            if  let imageData = UIImageJPEGRepresentation(image as! UIImage, 0.1) {
                                multipartFormData.append(imageData, withName: imageparam, fileName: "image" + "\(i)" + ".png", mimeType: "image/png")
                            }
                            
                            i += 1
                        }
                    }
            },
                
                to: fullURL,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            if let responseObject = response.result.value as? [String: Any] {
                                // print(jsonResponse)
                                let resJson = JSON(responseObject)
                                
                                NSLog("\(resJson)")
                                success(resJson)
                            }
                            }
                            .uploadProgress { progress in // main queue by default
                                print("Upload Progress: \(progress.fractionCompleted * 100)")
                                
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        
                    }
            })
        }
        else
        {
        }
    }
}

//=============



//
/*
 
 
 
 
 
 /*
 
 
 
 func uploadImagesAndData(_ strURL : String,imagesArr: NSArray, params : [String : AnyObject]?, headers : [String : String]?,progress:@escaping (String)->Void, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
 //   let fullURL = kBasePath + strURL
 let fullURL = "http://miteshpatel.orgfree.com/FileUpload/UploadImage/UploadImages.php"
 
 // let parameters = ["user":"Sol", "password":"secret1234"]
 
 // Image to upload:
 // let imageToUploadURL = Bundle.main.url(forResource: "tree", withExtension: "png")
 
 // Server address (replace this with the address of your own server):
 // let url = "http://localhost:8888/upload_image.php"
 
 
 // Use Alamofire to upload the image
 /*  Alamofire.upload(
 multipartFormData: { multipartFormData in
 // On the PHP side you can retrive the image using $_FILES["image"]["tmp_name"]
 
 for image in imagesa
 {
 multipartFormData.append(image!, withName: "image")
 }
 
 for (key, val) in params! {
 multipartFormData.append(val.data(using: String.Encoding.utf8.rawValue)!, withName: key)
 }
 },
 */
 
 
 
 /*let parameters = [
 "service_request_id" : "",
 "status_id" : "4",
 ]*/
 Alamofire.upload(
 multipartFormData: { multipartFormData in
 
 for (key,value) in params! {
 if let value = value as? String {
 multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
 }
 }
 var i : Int = 0
 for (image) in imagesArr {
 if  let imageData = UIImageJPEGRepresentation(image as! UIImage, 0.25) {
 
 multipartFormData.append(imageData, withName: "images[]", fileName: "image" + "\(i)" + ".jpeg", mimeType: "image/jpeg")
 
 
 }
 
 i += 1
 }
 },
 
 to: fullURL,
 encodingCompletion: { encodingResult in
 switch encodingResult {
 case .success(let upload, _, _):
 upload.responseJSON { response in
 if let jsonResponse = response.result.value as? [String: Any] {
 print(jsonResponse)
 }
 }
 .uploadProgress { progress in // main queue by default
 print("Upload Progress: \(progress.fractionCompleted * 100)")
 
 }
 case .failure(let encodingError):
 print(encodingError)
 }
 })
 }
 
 
 
 let parameters = [
 "service_request_id" : servicesID,
 "status_id" : "4",
 ]
 Alamofire.upload(
 multipartFormData: { multipartFormData in
 
 for (key,value) in parameters {
 if let value = value as? String {
 multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
 }
 }
 
 for (image) in self.imagesArray {
 if  let imageData = UIImageJPEGRepresentation(image, 1) {
 multipartFormData.append(imageData, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
 }
 }
 },
 to: ConnectionWS.UpdateServicesURL,
 method: .put,
 encodingCompletion: { encodingResult in
 switch encodingResult {
 case .success(let upload, _, _):
 
 upload.uploadProgress(closure: { (progress) in
 print(progress)
 })
 
 upload.responseJSON { response in
 
 // If the request to get activities is succesfull, store them
 if response.result.isSuccess{
 print(response.debugDescription)
 alert.dismiss(animated: true, completion:
 {
 self.dismiss(animated: true, completion:
 {
 self.delegate?.statusChanged(IsFinish: false)
 })
 
 })
 
 // Else throw an error
 } else {
 
 
 var errorMessage = "ERROR MESSAGE: "
 if let data = response.data {
 // Print message
 let responseJSON = JSON(data: data)
 if let message: String = responseJSON["error"]["message"].string {
 if !message.isEmpty {
 errorMessage += message
 }
 }
 }
 print(errorMessage) //Contains General error message or specific.
 print(response.debugDescription)
 }
 
 alert.dismiss(animated: true, completion:
 {
 self.dismiss(animated: true, completion:nil)
 
 })
 }
 case .failure(let encodingError):
 print("FALLE ------------")
 print(encodingError)
 }
 }
 )
 */
 
 
 
 /*
 func uploadImagesAndData(params:[String : AnyObject]?,image1: UIImage,image2: UIImage,image3: UIImage,image4: UIImage, completionHandler:@escaping CompletionHandler) -> Void {
 let fullURL = "http://miteshpatel.orgfree.com"//kBasePath + strURL
 
 let imageData1 = UIImageJPEGRepresentation(image1, 0.5)!
 let imageData2 = UIImageJPEGRepresentation(image2, 0.5)!
 
 let imageData3 = UIImageJPEGRepresentation(image3, 0.5)!
 
 let imageData4 = UIImageJPEGRepresentation(image4, 0.5)!
 
 
 Alamofire.upload(multipartFormData: { multipartFormData in
 
 for (key, value) in params! {
 if let data = value.data(using: String.Encoding.utf8.rawValue) {
 multipartFormData.append(data, withName: key)
 }
 }
 
 multipartFormData.append(imageData1, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
 multipartFormData.append(imageData2, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
 multipartFormData.append(imageData3, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
 multipartFormData.append(imageData4, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
 
 },
 to: fullURL, encodingCompletion: { encodingResult in
 switch encodingResult {
 case .success(let upload, _, _):
 upload
 .validate()
 .responseJSON { response in
 switch response.result {
 case .success(let value):
 print("responseObject: \(value)")
 case .failure(let responseError):
 print("responseError: \(responseError)")
 }
 }
 case .failure(let encodingError):
 print("encodingError: \(encodingError)")
 }
 })
 }*/
 
 
 Post Request
 
 //        let parameters = [
 //            "action": "view"
 //        ]
 
 
 AFWrapper.sharedInstance.requestPOSTURL(HttpsUrl.Address, params: dict as [String : AnyObject]?, headers: nil, success: { (json) in
 // success code
 print(json)
 }, failure: { (error) in
 //error code
 print(error)
 })
 
 
 Get Request
 
 
 RequstJsonClass.sharedInstance.requestGETURL("", success: { (json) in
 // success code
 print(json)
 }, failure: { (error) in
 //error code
 print(error)
 })
 
 
 
 
 
 //        do{
 //            RequstJsonClass.sharedInstance.requestGETURL("admin_settings.php", success: { (json) in
 //                // success code
 //                print(json)
 //            }, failure: { (error) in
 //                //error code
 //                print(error)
 //            })
 //        }
 //        catch Default
 //        {
 //            print("Doo..")
 //        }
 
 
 
 
 
 // Getting a double from a JSON Array
 let name = json[0].double
 // Getting an array of string from a JSON Array
 let arrayNames =  json["users"].arrayValue.map({$0["name"].stringValue})
 // Getting a string from a JSON Dictionary
 let name = json["name"].stringValue
 // Getting a string using a path to the element
 let path: [JSONSubscriptType] = [1,"list",2,"name"]
 let name = json[path].string
 // Just the same
 let name = json[1]["list"][2]["name"].string
 // Alternatively
 let name = json[1,"list",2,"name"].string
 // With a hard way
 let name = json[].string
 // With a custom way
 let keys:[SubscriptType] = [1,"list",2,"name"]
 let name = json[keys].string
 Loop
 
 // If json is .Dictionary
 for (key,subJson):(String, JSON) in json {
 // Do something you want
 }
 The first element is always a String, even if the JSON is an Array
 
 // If json is .Array
 // The `index` is 0..<json.count's string value
 for (index,subJson):(String, JSON) in json {
 // Do something you want
 }
 
 
 
 
 
 let json = JSON(["name", "age"])
 if let name = json[999].string {
 // Do something you want
 } else {
 print(json[999].error!) // "Array[999] is out of bounds"
 }
 let json = JSON(["name":"Jack", "age": 25])
 if let name = json["address"].string {
 // Do something you want
 } else {
 print(json["address"].error!) // "Dictionary["address"] does not exist"
 }
 let json = JSON(12345)
 if let age = json[0].string {
 // Do something you want
 } else {
 print(json[0])       // "Array[0] failure, It is not an array"
 print(json[0].error!) // "Array[0] failure, It is not an array"
 }
 
 if let name = json["name"].string {
 // Do something you want
 } else {
 print(json["name"])       // "Dictionary[\"name"] failure, It is not an dictionary"
 print(json["name"].error!) // "Dictionary[\"name"] failure, It is not an dictionary"
 }
 Optional getter
 
 // NSNumber
 if let id = json["user"]["favourites_count"].number {
 // Do something you want
 } else {
 // Print the error
 print(json["user"]["favourites_count"].error!)
 }
 // String
 if let id = json["user"]["name"].string {
 // Do something you want
 } else {
 // Print the error
 print(json["user"]["name"].error!)
 }
 // Bool
 if let id = json["user"]["is_translator"].bool {
 // Do something you want
 } else {
 // Print the error
 print(json["user"]["is_translator"].error!)
 }
 // Int
 if let id = json["user"]["id"].int {
 // Do something you want
 } else {
 // Print the error
 print(json["user"]["id"].error!)
 }
 ...
 Non-optional getter
 
 Non-optional getter is named xxxValue
 
 // If not a Number or nil, return 0
 let id: Int = json["id"].intValue
 // If not a String or nil, return ""
 let name: String = json["name"].stringValue
 // If not an Array or nil, return []
 let list: Array<JSON> = json["list"].arrayValue
 // If not a Dictionary or nil, return [:]
 let user: Dictionary<String, JSON> = json["user"].dictionaryValue
 Setter
 
 json["name"] = JSON("new-name")
 json[0] = JSON(1)
 json["id"].int =  1234567890
 json["coordinate"].double =  8766.766
 json["name"].string =  "Jack"
 json.arrayObject = [1,2,3,4]
 json.dictionaryObject = ["name":"Jack", "age":25]
 Raw object
 
 let rawObject: Any = json.object
 let rawValue: Any = json.rawValue
 //convert the JSON to raw NSData
 do {
	let rawData = try json.rawData()
 //Do something you want
 } catch {
	print("Error \(error)")
 }
 //convert the JSON to a raw String
 if let rawString = json.rawString() {
 //Do something you want
 } else {
	print("json.rawString is nil")
 }
 Existence
 
 // shows you whether value specified in JSON or not
 if json["name"].exists()
 Literal convertibles
 
 For more info about literal convertibles: Swift Literal Convertibles
 
 // StringLiteralConvertible
 let json: JSON = "I'm a json"
 / /IntegerLiteralConvertible
 let json: JSON =  12345
 // BooleanLiteralConvertible
 let json: JSON =  true
 // FloatLiteralConvertible
 let json: JSON =  2.8765
 // DictionaryLiteralConvertible
 let json: JSON =  ["I":"am", "a":"json"]
 // ArrayLiteralConvertible
 let json: JSON =  ["I", "am", "a", "json"]
 // With subscript in array
 var json: JSON =  [1,2,3]
 json[0] = 100
 json[1] = 200
 json[2] = 300
 json[999] = 300 // Don't worry, nothing will happen
 // With subscript in dictionary
 var json: JSON =  ["name": "Jack", "age": 25]
 json["name"] = "Mike"
 json["age"] = "25" // It's OK to set String
 json["address"] = "L.A." // Add the "address": "L.A." in json
 // Array & Dictionary
 var json: JSON =  ["name": "Jack", "age": 25, "list": ["a", "b", "c", ["what": "this"]]]
 json["list"][3]["what"] = "that"
 json["list",3,"what"] = "that"
 let path: [JSONSubscriptType] = ["list",3,"what"]
 json[path] = "that"
 // With other JSON objects
 let user: JSON = ["username" : "Steve", "password": "supersecurepassword"]
 let auth: JSON = [
 "user": user.object, // use user.object instead of just user
 "apikey": "supersecretapitoken"
 ]
 
 
 
 
 
 let original: JSON = [
 "first_name": "John",
 "age": 20,
 "skills": ["Coding", "Reading"],
 "address": [
 "street": "Front St",
 "zip": "12345",
 ]
 ]
 
 let update: JSON = [
 "last_name": "Doe",
 "age": 21,
 "skills": ["Writing"],
 "address": [
 "zip": "12342",
 "city": "New York City"
 ]
 ]
 
 let updated = original.merge(with: update)
 // [
 //     "first_name": "John",
 //     "last_name": "Doe",
 //     "age": 21,
 //     "skills": ["Coding", "Reading", "Writing"],
 //     "address": [
 //         "street": "Front St",
 //         "zip": "12342",
 //         "city": "New York City"
 //     ]
 // ]
 String representation
 
 There are two options available:
 
 use the default Swift one
 use a custom one that will handle optionals well and represent nil as "null":
 let dict = ["1":2, "2":"two", "3": nil] as [String: Any?]
 let json = JSON(dict)
 let representation = json.rawString(options: [.castNilToNSNull: true])
 // representation is "{\"1\":2,\"2\":\"two\",\"3\":null}", which represents {"1":2,"2":"two","3":null}
 Work with Alamofire
 
 SwiftyJSON nicely wraps the result of the Alamofire JSON response handler:
 
 Alamofire.request(url, method: .get).validate().responseJSON { response in
 switch response.result {
 case .success(let value):
 let json = JSON(value)
 print("JSON: \(json)")
 case .failure(let error):
 print(error)
 }
 }
 We also provide an extension of Alamofire for serializing NSData to SwiftyJSON's JSON.
 
 See: Alamofire-SwiftyJSON
 
 Work with Moya
 
 SwiftyJSON parse data to JSON:
 
 let provider = MoyaProvider<Backend>()
 provider.request(.showProducts) { result in
 switch result {
 case let .success(moyaResponse):
 let data = moyaResponse.data
 let json = JSON(data: data) // convert network data to json
 print(json)
 case let .failure(error):
 print("error: \(error)")
 }
 }
 */


