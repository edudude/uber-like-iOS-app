//
//  LandingViewController.swift
//  ORBT
//
//  Created by Admin User on 4/17/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class CustomerSignUpVC: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var mFirstName: UITextField!
    @IBOutlet weak var mLastName: UITextField!
    @IBOutlet weak var mEmail: UITextField!
    @IBOutlet weak var mPassword: UITextField!
    @IBOutlet weak var mCPassword: UITextField!
    
    @IBOutlet weak var mCustomer: UIButton!
    @IBOutlet weak var mProvider: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mCustomer.isSelected = true;
        mProvider.isSelected = false;
    }
    
    @IBAction func onProvider(_ sender: UIButton) {
        mCustomer.isSelected = mProvider.isSelected;
        sender.isSelected = !sender.isSelected
    }
    @IBAction func onCustomer(_ sender: UIButton) {
        mProvider.isSelected = mCustomer.isSelected;
        sender.isSelected = !sender.isSelected
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onRegister(_ sender: Any) {
        if (mFirstName.text == "" || mLastName.text == "" || mEmail.text == "" || mPassword.text == "") {
            let alert = UIAlertController(title: "Error", message: "Fill in the form", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        if (mPassword.text != mCPassword.text) {
            let alert = UIAlertController(title: "Error", message: "Password doesn't match", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        var mIsCustomer = 1
        if (mCustomer.isSelected == false) {
            mIsCustomer = 0
        }
        let parameters: Parameters = [
            "firstname" : mFirstName.text,
            "lastname"  : mLastName.text,
            "email"     : mEmail.text,
            "password"  : mPassword.text,
            "isCustomer": mIsCustomer
        ]
        
        Alamofire.request("\(BASE_URL)/user/auth/signup", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            debugPrint(response)
            
            // make sure we got JSON and it's a dictionary
            guard let json = response.result.value as? [String: AnyObject] else {
                print("didn't get todo object as JSON from API")
                return
            }
            if ((json["success"] as? String) == "T") {
                let alert = UIAlertController(title: "Success", message: "New user register!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: (json["message"] as? String), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

