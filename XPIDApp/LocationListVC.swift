//
//  LocationListVC.swift
//  XPIDApp
//
//  Created by Mits on 6/6/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import SVProgressHUD

class LocationListVC: UIViewController, UITextViewDelegate,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //var locationArr = NSArray()
    let app = UIApplication.shared.delegate as! AppDelegate
    var jsonArr = NSArray()
    var city = ""
    var country = ""

    var nameArr = [String]()
    var addressArr = [String]()
    var imageArr = [String]()

    @IBOutlet var searchview: UISearchBar!
    
    var cellHeight:CGFloat = 0.0
    var cellHeightArr = NSMutableArray()
    
    var filternamedata : [String] = [String]()
    var filteraddressdata : [String] = [String]()
    var filterimagedata : [String] = [String]()
    
    @IBOutlet var tbl_locationTableV:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl_locationTableV.delegate = self
        tbl_locationTableV.dataSource = self
        nearestLocation()
        searchview.delegate = self
       // filterdata = data
        
       // tbl_locationTableV.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    @IBAction func backbtnPressed(sender:Any)
    {
        self.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filternamedata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationNearestCell
        
        if filternamedata.count != 0
        {
            cell.nameLabel.text = filternamedata[indexPath.row]
            cell.nameLabel = resizeLabel(label: cell.nameLabel)
            cell.addressLabel.text = filteraddressdata[indexPath.row]
            cell.addressLabel = resizeLabel(label: cell.addressLabel)
            
            let imageURL = filterimagedata[indexPath.row]
            cell.placeImage.sd_setImage(with: URL.init(string: imageURL), placeholderImage: #imageLiteral(resourceName: "ic_location_placeholder"), options: .continueInBackground, completed: nil)
            
            
//            cell.textLabel?.text = filterdata[indexPath.row]
        }
        else{
            cell.nameLabel.text = nameArr[indexPath.row]
            cell.nameLabel = resizeLabel(label: cell.nameLabel)
            
            cell.addressLabel?.text = addressArr[indexPath.row]
            cell.addressLabel = resizeLabel(label: cell.addressLabel)
            
            let imageURL = imageArr[indexPath.row]
            cell.placeImage.sd_setImage(with: URL.init(string: imageURL), placeholderImage: #imageLiteral(resourceName: "ic_location_placeholder"), options: .continueInBackground, completed: nil)
        }
       cell.addressLabel.frame.origin.y = cell.nameLabel.frame.origin.y + cell.nameLabel.frame.size.height + 7
        cellHeight = CGFloat(cell.addressLabel.frame.origin.y + cell.addressLabel.frame.size.height + 20)
        
        //        let cellH = String(format:"%d",cellHeight)
        cellHeightArr.replaceObject(at: indexPath.row, with: cellHeight)
        
        cell.postxpButton.layer.cornerRadius = 8
        cell.postxpButton.layer.masksToBounds = true
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellHeightArr.count > 0
        {
            print(cellHeightArr)
            let cellheight1 = cellHeightArr.object(at: indexPath.row) as! CGFloat
            if cellheight1 != 0.0
            {
                print(cellheight1)
                if cellheight1 < 75
                {
                    return 77
                }
                else
                {
                    return cellheight1
                }
            }
        }
        
        return 75
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // filterdata  = searchText.isEmpty ? data : data.filter {(item : String) -> Bool in
        
        filternamedata = searchText.isEmpty ? nameArr : nameArr.filter { $0.contains(searchText) }
        var currentIndex = 0
        filteraddressdata  = [String]()
        filterimagedata =  [String]()
        do
        {
            for i in 0..<nameArr.count
            {
                let searchValue = nameArr[i]
                
                for name in filternamedata
                {
                    if name == searchValue {
                        print("Found \(name) for index \(currentIndex)")
                        filteraddressdata.append(addressArr[i])
                        filterimagedata.append(imageArr[i])
                        
                        break
                    }
                    
                    currentIndex += 1
                }
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
       
        //return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        
        tbl_locationTableV.reloadData()
    }
    
    
    func resizeLabel(label:UILabel) -> UILabel
    {
        label.numberOfLines = 0
        let maximumLabelSize: CGSize = CGSize(width: 280, height: 9999)
        let expectedLabelSize: CGSize = label.sizeThatFits(maximumLabelSize)
        // create a frame that is filled with the UILabel frame data
        var newFrame: CGRect = label.frame
        // resizing the frame to calculated size
        newFrame.size.height = expectedLabelSize.height
        // put calculated frame into UILabel frame
        label.frame = newFrame
        
        return label
    }
    
    @IBAction func dealBtnPressed(sender:Any)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let StorePage = storyBoard.instantiateViewController(withIdentifier: "DealVC") as! DealVC
        self.present(StorePage, animated: true, completion: nil)
        
    }
    
    @IBAction func addPlaceVCBtnPressed(sender:Any)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let StorePage = storyBoard.instantiateViewController(withIdentifier: "AddPlaceVC") as! AddPlaceVC
        self.present(StorePage, animated: true, completion: nil)
    }
    
    
    @IBAction func myPostXPBtnPressed(sender:Any)
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false

        if let cell = (sender as AnyObject).superview??.superview as? LocationNearestCell {
            let indexPath = tbl_locationTableV.indexPath(for: cell)
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let StorePage = storyBoard.instantiateViewController(withIdentifier: "PostMyXPVC") as! PostMyXPVC
            let data = JSON(jsonArr[(indexPath?.row)!])
            print(data)
            //if let photoRef = data["photos"][0]["photo_reference"].string
           // {
             //   print(photoRef)

            // DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")

            //    DispatchQueue.main.async {
            print("This is run on the main queue, after the previous code in outer block")
//            if photoRef != nil
//            {
//                var firstObj1 : String = ""
//                if (indexPath?.row)! % 2 == 0
//                {
//
//                    firstObj1 = String(format:"https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&key=AIzaSyAhBZsez76ZAwrMHb7MZP4PpkDbKCnCjkU&photoreference=%@",photoRef)
//                }
//                else
//                {
//                    firstObj1 = String(format:"https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&key=AIzaSyBLoPujJRpBq3FYge80p-Tbh4_tPOEkiyo&photoreference=%@",photoRef)
//                    //AIzaSyBLoPujJRpBq3FYge80p-Tbh4_tPOEkiyo
//                }
//                //let firstObj1:String = String(format:"https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&key=AIzaSyBLoPujJRpBq3FYge80p-Tbh4_tPOEkiyo&photoreference=%@",photoRef)
//                // print(firstObj1)
//                StorePage.img_url = firstObj1
//                //cell.placeImage.sd_setImage(with: URL.init(string: firstObj1), placeholderImage: nil, options: .continueInBackground, completed: nil)
//            }
            //  }
            // }
                
            self.view.isUserInteractionEnabled = true
 
            SVProgressHUD.dismiss()
            print(data["geometry"]["location"].dictionary)
//                var filternamedata : [String] = [String]()
//                var filteraddressdata : [String] = [String]()
//                var filterimagedata : [String] = [String]()

                
            let location = data["geometry"]["location"].dictionary

            StorePage.uid = UserDefaults.standard.string(forKey: "userid")!
                
            StorePage.placename = filternamedata[indexPath?.row ?? 0]

            StorePage.address = filteraddressdata[indexPath?.row ?? 0]//data["vicinity"].string!//"abcd abcd"
            StorePage.img_url = filterimagedata[indexPath?.row ?? 0]
            StorePage.state = ""
            StorePage.city = city
            StorePage.country = country
            StorePage.username = UserDefaults.standard.string(forKey: "username")!
            StorePage.long = String(format:"%d",(location!["lng"]?.int!)!)
            StorePage.lat = String(format:"%d",(location!["lat"]?.int!)!)
          //  StorePage.ranking = String(format:"%d",(data["rating"].int!))
            print(String(format:"%d",(location!["lng"]?.int!)!))
            print(String(format:"%d",(location!["lat"]?.int!)!))
           // print(String(format:"%d",(data["rating"].int!)))

            StorePage.points = ""

            self.present(StorePage, animated: true, completion: nil)
      //  }
        }
        
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


extension LocationListVC
{
    func nearestLocation()
    {
        if app.long != "" && app.lat != ""
        {
            SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false

            let urlLink = String(format:"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=5000&key=AIzaSyDBGAAMADwCNKqGclqwNyWWNKTdGEszd4I",app.lat,app.long)
            print(urlLink)//&keyword=starbucks
            
            // trail : AIzaSyAhBZsez76ZAwrMHb7MZP4PpkDbKCnCjkU
            //AIzaSyDBGAAMADwCNKqGclqwNyWWNKTdGEszd4I
            RequstJsonClass.sharedInstance.requestGETSingleURL(urlLink, view: self, success: { (json) in
                            print(json)
                //   let response = json as? NSDictionary
                if json != nil
                {
                    self.jsonArr = (json["results"].array as? NSArray)!
                    
                    
                    self.cellHeightArr = NSMutableArray()
                    for i in 0..<self.jsonArr.count
                    {
                        self.cellHeightArr.add(0.0)
                    }
                    for i in 0..<self.jsonArr.count
                    {
                        let data = JSON(self.jsonArr[i])
                        let name = data["name"].string
                        let address = data["vicinity"].string
                        self.nameArr.append(name ?? "")
                        self.addressArr.append(address ?? "")
                        print(self.nameArr)
                        print(self.addressArr)
                        
                        let photoRef = data["photos"][0]["photo_reference"].string
                        print(photoRef)
                        
                       // DispatchQueue.global(qos: .background).async {
                         //   print("This is run on the background queue")
                          //  sleep(2)
                          //  DispatchQueue.main.async {
                          //      print("This is run on the main queue, after the previous code in outer block")
                                if photoRef != nil
                                {
                                    var firstObj1 : String = ""
                                    if i % 2 == 0
                                    {
                                        
                                        firstObj1 = String(format:"https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&key=AIzaSyDBGAAMADwCNKqGclqwNyWWNKTdGEszd4I&photoreference=%@",photoRef!)
                                        
                                        // Trail : AIzaSyAhBZsez76ZAwrMHb7MZP4PpkDbKCnCjkU
                                        //AIzaSyDBGAAMADwCNKqGclqwNyWWNKTdGEszd4I
                                    }
                                    else
                                    {
                                        firstObj1 = String(format:"https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&key=AIzaSyDBGAAMADwCNKqGclqwNyWWNKTdGEszd4I&photoreference=%@",photoRef!)
                                        
                                        // Trail :AIzaSyBLoPujJRpBq3FYge80p-Tbh4_tPOEkiyo
                                        //AIzaSyDBGAAMADwCNKqGclqwNyWWNKTdGEszd4I
                                        // trail : AIzaSyBLoPujJRpBq3FYge80p-Tbh4_tPOEkiyo
                                    }
                                    self.imageArr.append(firstObj1)
                                    // print(firstObj1)
                                   // cell.placeImage.sd_setImage(with: URL.init(string: firstObj1), placeholderImage: #imageLiteral(resourceName: "ic_location_placeholder"), options: .continueInBackground, completed: nil)
                                }
                                else
                                {
                                    self.imageArr.append("")
                                }
                            }
                     //   }
                 //   }
//
                    self.filternamedata = self.nameArr
                    self.filteraddressdata = self.addressArr
                    self.filterimagedata = self.imageArr
                    self.tbl_locationTableV.reloadData()
                    
                    
                    //                    print(dataAr)
                    //                    print(dataAr.count)
                    //                    let photoRef = dataAr[0]["photos"][0]//["photo_reference"] as? String
                    
                    //                    if dataAr.count != 0 || dataAr != nil || photoRef != nil
                    //                    {
                    //self.jsonArr = dataAr.array as! NSArray
                    
                    //                        let photoRef = dataAr[0]["photos"][0]//["photo_reference"] as? String
                    //                        let mm = JSON(photoRef["photo_reference"])
                    //                        print(mm)
                    //                        print(photoRef["photo_reference"])
                    //                        self.firstObj = String(format:"https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photoreference=%@&key=AIzaSyAhBZsez76ZAwrMHb7MZP4PpkDbKCnCjkU",mm.string!)
                    //                        print(self.firstObj)
                    //                        cell.plac.sd_setImage(with: URL.init(string: self.firstObj), placeholderImage: nil, options: .continueInBackground, completed: nil)
                    
                    
                    //                    }
                }
                self.view.isUserInteractionEnabled = true

                SVProgressHUD.dismiss()
                
            }) { (error) in
                
                print(error)
                
            }
        }
        
    }
}


/*
 target 'XPIDApp' do
 # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
 use_frameworks!
 
 # Pods for XPIDApp
 
 end
 
 target 'XPIDApp WatchKit App' do
 # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
 use_frameworks!
 
 # Pods for XPIDApp WatchKit App
 
 end
 
 target 'XPIDApp WatchKit Extension' do
 # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
 use_frameworks!
 
 # Pods for XPIDApp WatchKit Extension
 
 end
 
 */
