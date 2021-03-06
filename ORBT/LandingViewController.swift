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
import CoreLocation
import CircularSpinner

var mID = -1
var mIsCustomer = 0
var mLatitude = 1.1;
var mLongitude = 1.1;
var mName : String?

class LandingViewController: UIViewController , UITextFieldDelegate , CLLocationManagerDelegate {
    
    @IBOutlet weak var mEmail: UITextField!
    @IBOutlet weak var mPassword: UITextField!
    @IBOutlet weak var mLogIn: UIButton!
    
    var locationManager:CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        CircularSpinner.trackPgColor = UIColor(red: 255.0 / 255.0, green: 100.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignUpButton(_ sender: Any) {
    }
    
    @IBAction func onLogIn(_ sender: Any) {
        mLogIn.isUserInteractionEnabled = false

        let parameters = [
            "email"     : mEmail.text,
            "password"  : mPassword.text,
            "device"    : deviceTokenString
        ] as [String:Any]
        
        CircularSpinner.show("Log in", animated: true, type: .indeterminate, showDismissButton: false, delegate: nil)
        Alamofire.request("\(BASE_URL)/user/auth/login", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            CircularSpinner.hide()
            
            // make sure we got JSON and it's a dictionary
            self.mLogIn.isUserInteractionEnabled = true;
            
            guard let json = response.result.value as? [String: AnyObject] else {
                let alert = UIAlertController(title: "Error", message: "Failed to connect server", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                print("didn't get todo object as JSON from API")
                return
            }
            if ((json["success"] as? String) == "T") {
                let mUserInfo = json["userInfo"] as? [String: AnyObject]

                if ((mUserInfo?["active"] as? Int)! == 0) {
                    let alert = UIAlertController(title: "Error", message: "You are blocked!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                mID = (mUserInfo?["id"] as? Int)!
                mName = "\((mUserInfo!["firstname"] as! String!)!) \((mUserInfo!["lastname"] as! String!)!)"
                
                if (mUserInfo?["isCustomer"] as? Int == 1) {
                    mIsCustomer = 1
                    print("Customer")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "CustomerViewController") as! CustomerViewController
                    self.navigationController?.pushViewController(vc, animated: false)
                } else {
                    mIsCustomer = 0
                    print("Provider")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ProviderViewController") as! ProviderViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                let alert = UIAlertController(title: "Error", message: (json["message"] as? String), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                print(json["message"] as? String);
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.allowsBackgroundLocationUpdates = true;
            
            locationManager.startUpdatingLocation()
            
            
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        mLatitude = userLocation.coordinate.latitude
        mLongitude = userLocation.coordinate.longitude
        if (mID == -1 || mIsCustomer == 1) {
            return;
        }
        let parameters: Parameters = [
            "latitude"  : "\(userLocation.coordinate.latitude)",
            "longitude" : "\(userLocation.coordinate.longitude)",
            "id"        : mID
        ]
        
        // Both calls are equivalent
        Alamofire.request("\(BASE_URL)/service/upload/pos", method: .post, parameters: parameters, encoding: JSONEncoding.default)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        determineMyCurrentLocation()
    }
}

