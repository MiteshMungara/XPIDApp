//
//  SettingVC.swift
//  XPIDApp
//
//  Created by Mits on 9/27/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    @IBOutlet var myXPIDLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let privacyKey = UserDefaults.standard.string(forKey: "privacyCode")
        if privacyKey == "" || privacyKey == nil
        {
            var fourDigitNumber: String {
                var result = ""
                repeat {
                    // Create a string with a random number 0...9999
                    result = String(format:"%04d", fabs(Double(arc4random_uniform(10000))))
                } while result.count < 4
                return result
            }//MY XPID:### 00000 ## XXX ###
            UserDefaults.standard.set(privacyKey, forKey:"privacyCode")
            myXPIDLabel.text = String(format:"MY XPID:### %d ## XXX ###",fourDigitNumber)
        }
        else
        {
            myXPIDLabel.text = String(format:"MY XPID:### %d ## XXX ###",privacyKey!)
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(sender:Any)
    {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func termsAndConditionBtnPressed(sender:Any)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let StorePage = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionVC") as! TermsAndConditionVC
        self.present(StorePage, animated: true, completion: nil)
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
