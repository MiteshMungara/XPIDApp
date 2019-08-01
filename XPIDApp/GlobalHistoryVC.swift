//
//  GlobalHistoryVC.swift
//  XPIDApp
//
//  Created by Mits on 9/27/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import SVProgressHUD

class GlobalHistoryVC: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate
 {

    let app = UIApplication.shared.delegate as! AppDelegate
    var jsonArr = NSArray()
    @IBOutlet var tbl_globalHistoryTableV:UITableView!

    var nameArr = [String]()
    var addressArr = [String]()
    var imageArr = [String]()
    var satisfyxpArr = [String]()
    var friendsfamilyArr = [String]()
    var rankingArr = [String]()
    var descArr = [String]()
    
    var cellHeight:CGFloat = 0.0
    var cellHeightArr = NSMutableArray()
    
    @IBOutlet var searchview: UISearchBar!
    
    //  var data:[String] = ["Dev","Hiren","Bhagyashree","Himanshu","Manisha","Trupti","Prashant","Kishor","Jignesh","Rushi"]
    
    var filternamedata : [String] = [String]()
    var filteraddressdata : [String] = [String]()
    var filterimagedata : [String] = [String]()
    var filtersatifyxpdata : [String] = [String]()
    var filterfriendfamilydata : [String] = [String]()
    var filterrankingdata : [String] = [String]()
    var filterdescdata : [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl_globalHistoryTableV.delegate = self
        tbl_globalHistoryTableV.dataSource = self
        
        searchview.delegate = self
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(historyList), userInfo: nil, repeats: false)
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func historyList()
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false

        //Parameter
        let uid = UserDefaults.standard.string(forKey: "userid")!
        let parameters = [
            "u_id":uid,
            "type":"myxp"
        ]
        print(parameters)
        RequstJsonClass.sharedInstance.requestPOSTURL("history.php", params: parameters as [String : AnyObject]?, headers: nil, view: self, success: { (json) in
            // success code
            print(json)
            //   let response = json as? NSDictionary
            let success = json["Success"].string
            if success == "1"
            {
                self.jsonArr = json["posts"].array as! NSArray
                self.cellHeightArr = NSMutableArray()
                for i in 0..<self.jsonArr.count
                {
                    self.cellHeightArr.add(0.0)
                }
                for i in 0..<self.jsonArr.count
                {
                    let data = JSON(self.jsonArr[i])
                    
                    let name = data["placename"].string
                    let address = data["address"].string
                    let image = data["image"].string
                    let satisfy = data["satisfy_xp"].string
                    let ranking = data["ranking"].string
                    let friendfamily = data["xp_friend_family"].string
                    let desc = data["xp_description"].string
                    
                    self.nameArr.append(name ?? "")
                    self.addressArr.append(address ?? "")
                    self.satisfyxpArr.append(satisfy ?? "")
                    self.rankingArr.append(ranking ?? "")
                    self.friendsfamilyArr.append(friendfamily ?? "")
                    self.imageArr.append(image ?? "")
                    self.descArr.append(desc ?? "")
                    print(self.nameArr)
                    print(self.addressArr)

                }
                self.filternamedata = self.nameArr
                self.filteraddressdata = self.addressArr
                self.filterimagedata = self.imageArr
                self.filtersatifyxpdata = self.satisfyxpArr
                self.filterfriendfamilydata = self.friendsfamilyArr
                self.filterrankingdata = self.rankingArr
                self.filterdescdata = self.descArr
                self.tbl_globalHistoryTableV.reloadData()
                self.tbl_globalHistoryTableV.reloadData()
                self.tbl_globalHistoryTableV.layoutIfNeeded()
                
                
            }
            else
            {
         //       Toast.long(message: "Login Invalid", success: "0", failer: "1")
            }
            self.view.isUserInteractionEnabled = true

            SVProgressHUD.dismiss()
            
        }, failure: { (error) in
            //error code
            
            print(error)
        })
    }
    
   
    @IBAction func backbtnPressed(sender:Any)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let StorePage = storyBoard.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
        self.present(StorePage, animated: true, completion: nil)
        
    //    self.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filternamedata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GlobalHistoryCell
        
        if filternamedata.count != 0
        {
            cell.nameLabel.text = filternamedata[indexPath.row]
            cell.nameLabel = resizeLabel(label: cell.nameLabel)
            
            cell.addressLabel.text = filteraddressdata[indexPath.row]
            cell.addressLabel = resizeLabel(label: cell.addressLabel)
            cell.addressLabel.frame.origin.y = cell.nameLabel.frame.origin.y + cell.nameLabel.frame.size.height + 7
            
            cell.satisfyXPLabel.text = String(format:"%@",filtersatifyxpdata[indexPath.row])
            cell.satisfyXPLabel = resizeLabel(label: cell.satisfyXPLabel)
            cell.satisfyXPLabel.frame.origin.y = cell.addressLabel.frame.origin.y + cell.addressLabel.frame.size.height + 7
            
             cell.satisfyXPTitleLabel.frame.origin.y = cell.addressLabel.frame.origin.y + cell.addressLabel.frame.size.height + 7
            
            let friendandfamily = Double(filterfriendfamilydata[indexPath.row])!
            cell.friendandfamilyXPLabel.text =  String(format:"%.0f",Double(friendandfamily))
            cell.friendandfamilyXPLabel = resizeLabel(label: cell.friendandfamilyXPLabel)
            cell.friendandfamilyXPLabel.frame.origin.y = cell.satisfyXPLabel.frame.origin.y + cell.satisfyXPLabel.frame.size.height + 7
            
             cell.friendandfamilyXPTitleLabel.frame.origin.y =  cell.satisfyXPLabel.frame.origin.y + cell.satisfyXPLabel.frame.size.height + 7
            
            cell.descriptionLabel.text =  filterdescdata[indexPath.row]
            cell.descriptionLabel = resizeLabel(label: cell.descriptionLabel)
            cell.descriptionLabel.frame.origin.y = cell.friendandfamilyXPLabel.frame.origin.y + cell.friendandfamilyXPLabel.frame.size.height + 7
            
            //print(filterimagedata)
//            if (filterimagedata[indexPath.row] != nil)
//            {
                let imageURL = filterimagedata[indexPath.row]
                cell.placeImage.sd_setImage(with: URL.init(string: imageURL), placeholderImage: #imageLiteral(resourceName: "ic_location_placeholder"), options: .continueInBackground, completed: nil)
//            }
           
            
           //            cell.textLabel?.text = filterdata[indexPath.row]
        }
        else{
            cell.nameLabel.text = nameArr[indexPath.row]
            cell.nameLabel = resizeLabel(label: cell.nameLabel)
            cell.addressLabel?.text = addressArr[indexPath.row]
            cell.addressLabel = resizeLabel(label: cell.addressLabel)
            cell.addressLabel.frame.origin.y = cell.nameLabel.frame.origin.y + cell.nameLabel.frame.size.height + 7
            
            cell.satisfyXPLabel.text = String(format:"%@",satisfyxpArr[indexPath.row])
            cell.satisfyXPLabel = resizeLabel(label: cell.satisfyXPLabel)
            cell.satisfyXPLabel.frame.origin.y = cell.addressLabel.frame.origin.y + cell.addressLabel.frame.size.height + 7
            
            cell.satisfyXPTitleLabel.frame.origin.y = cell.addressLabel.frame.origin.y + cell.addressLabel.frame.size.height + 7
            
            
            let friendandfamily = Double(friendsfamilyArr[indexPath.row])!
            cell.friendandfamilyXPLabel.text =  String(format:"%.0f",Double(friendandfamily))
            cell.friendandfamilyXPLabel = resizeLabel(label: cell.friendandfamilyXPLabel)
            cell.friendandfamilyXPLabel.frame.origin.y = cell.satisfyXPLabel.frame.origin.y + cell.satisfyXPLabel.frame.size.height + 7
            
             cell.friendandfamilyXPTitleLabel.frame.origin.y = cell.satisfyXPLabel.frame.origin.y + 7
            
            cell.descriptionLabel?.text = descArr[indexPath.row]
            cell.descriptionLabel = resizeLabel(label: cell.descriptionLabel)
            cell.descriptionLabel.frame.origin.y = cell.friendandfamilyXPLabel.frame.origin.y + cell.friendandfamilyXPLabel.frame.size.height + 7
          //  print(imageArr)
//            if (imageArr[indexPath.row] != nil)
//            {
                let imageURL = imageArr[indexPath.row]
                
            cell.placeImage.sd_setImage(with: URL.init(string: imageURL), placeholderImage: #imageLiteral(resourceName: "ic_location_placeholder"), options: .continueInBackground, completed: nil)
//            }
           
            
        } 
        cellHeight = CGFloat(cell.descriptionLabel.frame.origin.y + cell.descriptionLabel.frame.size.height + 25)
        
        //        let cellH = String(format:"%d",cellHeight)
        cellHeightArr.replaceObject(at: indexPath.row, with: cellHeight)
        

      /* let data = JSON(jsonArr[indexPath.row])
        
        cell.nameLabel.text = data["placename"].string
        cell.addressLabel.text = data["address"].string
        //cell.cityLabel.text = data["city"].string
        
        cell.satisfyXPLabel.text = String(format:"%@ Satisfy XP",data["satisfy_xp"].string!)
        
        let friendandfamily = Double(data["xp_friend_family"].string!)!
        cell.friendandfamilyXPLabel.text =  String(format:"%.1f Friend And Family XP",Double(friendandfamily))
        cell.descriptionLabel.text = data["xp_description"].string
       // cell.currentdateLabel.text = data["current_date"].string
        
        let ranking = Double(data["ranking"].string!)!
        cell.rankingLabel.text = String(format:"%.1f Ranking",ranking)
        let imageURL = data["image"].string
        cell.placeImage.sd_setImage(with: URL.init(string: imageURL!), placeholderImage: nil, options: .continueInBackground, completed: nil)
       */
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
                if cellheight1 < 150.0
                {
                    return 155
                }
                else
                {
                    return cellheight1
                }
            }
        }
        return 156
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // filterdata  = searchText.isEmpty ? data : data.filter {(item : String) -> Bool in
        
        filternamedata = searchText.isEmpty ? nameArr : nameArr.filter { $0.contains(searchText) }
        var currentIndex = 0
        filteraddressdata  = [String]()
        filterimagedata =  [String]()
        filtersatifyxpdata = [String]()
        filterfriendfamilydata = [String]()
        filterrankingdata = [String]()
        filterimagedata = [String]()
        filterdescdata = [String]()
        print(filternamedata)
        for i in 0..<nameArr.count
        {
            let searchValue = nameArr[i]
            
            for name in filternamedata
            {
                if name == searchValue {
                    print("Found \(name) for index \(currentIndex)")
                    filteraddressdata.append(addressArr[i])
                    filterimagedata.append(imageArr[i])
                    filtersatifyxpdata.append(satisfyxpArr[i])
                    filterfriendfamilydata.append(friendsfamilyArr[i])
                    filterrankingdata.append(rankingArr[i])
                    filterdescdata .append(descArr[i])
                    break
                }
                
                currentIndex += 1
            }
        }
        //return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        
        tbl_globalHistoryTableV.reloadData()
    }
    
    
    @IBAction func backBtnPressed(sender:Any)
    {
        self.dismiss(animated: false, completion: nil)
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
