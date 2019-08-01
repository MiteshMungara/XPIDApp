
//
//  commanfunctions.swift
//  BandiPlace
//
//  Created by Mits on 11/5/17.
//  Copyright © 2017 Mits. All rights reserved.
//

import UIKit
class commanfunctions: NSObject {

    
    func showInternetConnectionAlert(_ title:String,_ message:String, view:UIViewController)
    {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            print("ok")
            alert.dismiss(animated:true,completion:nil)
        }))
        view.present(alert, animated: true, completion: nil)
        
    }
    
    func showAlertOk(_ title:String,_ message:String, view:UIViewController)
    {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            print("ok")
            alert.dismiss(animated:true,completion:nil)
        }))
        view.present(alert, animated: true, completion: nil)
        
    }
    
    func alertShowOkCancle(_ titile:String,_ message:String, view: UIViewController)
    {
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            print("ok")
            alert.dismiss(animated:true,completion:nil)
        }))
      
        alert.addAction(UIAlertAction(title: "Cancle", style: .default, handler: { (action) in
            print("cancle")
            alert.dismiss(animated:true,completion:nil)
        }))
    alert.present(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func requiredTextField(_ textfield:UITextField)->Bool
    {
        let validtest = textfield.text!
        let textfieldtrimmed = validtest.trimmingCharacters(in: .whitespaces)
        
        if textfieldtrimmed.isEmpty {
            return false
        }
        return true
    }
    
    class TextField: UITextField {
        
        let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        override open func textRect(forBounds bounds: CGRect) -> CGRect {
            return UIEdgeInsetsInsetRect(bounds, padding)
        }
        
        override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return UIEdgeInsetsInsetRect(bounds, padding)
        }
        
        override open func editingRect(forBounds bounds: CGRect) -> CGRect {
            return UIEdgeInsetsInsetRect(bounds, padding)
        }
    }

}

//extension UITextField {
//    func setLeftPaddingPoints(_ amount:CGFloat){
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
//        self.leftView = paddingView
//        self.leftViewMode = .always
//    }
//    func setRightPaddingPoints(_ amount:CGFloat) {
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
//        self.rightView = paddingView
//        self.rightViewMode = .always
//    }
//}

extension String
{
    func monthConvertToNo(_ month:String) -> String
    {
        var manthno :String!
        if month == "JAN"
        {
            manthno = "01"
        }
        if month == "FEB"
        {
            manthno = "02"
        }
        if month == "MAR"
        {
            manthno = "03"
        }
        if month == "APR"
        {
            manthno = "04"
        }
        if month == "MAY"
        {
            manthno = "05"
        }
        if month == "JUN"
        {
            manthno = "06"
        }
        if month == "JUL"
        {
            manthno = "07"
        }
        if month == "AUG"
        {
            manthno = "08"
        }
        if month == "SEP"
        {
            manthno = "09"
        }
        if month == "OCT"
        {
            manthno = "10"
        }
        if month == "NOV"
        {
            manthno = "11"
        }
        if month == "DEC"
        {
            manthno = "12"
        }
        
        return manthno
    }
    
    
    
}

//
class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 6.0
    @IBInspectable var bottomInset: CGFloat = 6.0
    @IBInspectable var leftInset: CGFloat = 8.0
    @IBInspectable var rightInset: CGFloat = 8.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}




extension UIImage
{
    class func scaleImageToreSize(img: UIImage,size: CGSize)-> UIImage {
        UIGraphicsBeginImageContext(size)
        
        img.draw(in: CGRect(origin: CGPointFromString("0"), size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}

