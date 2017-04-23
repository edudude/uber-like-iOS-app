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

var mID = -1
var mIsCustomer = 0
var mLatitude = 1.1;
var mLongitude = 1.1;
var mName : String?
var mMajor = -1

class LandingViewController: UIViewController , UITextFieldDelegate , CLLocationManagerDelegate {
    
    @IBOutlet weak var mEmail: UITextField!
    @IBOutlet weak var mPassword: UITextField!
    
    var locationManager:CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignUpButton(_ sender: Any) {
    }
    @IBAction func onLogIn(_ sender: Any) {
        let parameters = [
            "email"     : mEmail.text,
            "password"  : mPassword.text
        ]
        
        
        Alamofire.request("\(BASE_URL)/user/auth/login", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
//            debugPrint(response)
            
            // make sure we got JSON and it's a dictionary
            guard let json = response.result.value as? [String: AnyObject] else {
                print("didn't get todo object as JSON from API")
                return
            }
            if ((json["success"] as? String) == "T") {
                print("success")
                let mUserInfo = json["userInfo"] as? [String: AnyObject]
                print(mUserInfo)
                mID = (mUserInfo?["id"] as? Int)!
                mName = "\(mUserInfo!["firstname"] as! String!) \(mUserInfo!["lastname"] as! String!)"
                
                mMajor = -1
                var ta = (mUserInfo?["servicelist"] as! [Int])
                if (ta.count == 0) {
                    mMajor = -1
                } else {
                    mMajor = ta[0]
                }
                
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
        if (mID == -1 || mIsCustomer == 1 || mMajor == -1) {
            return;
        }
        let parameters: Parameters = [
            "latitude"  : "\(userLocation.coordinate.latitude)",
            "longitude" : "\(userLocation.coordinate.longitude)",
            "id"        : mID,
            "major"     : mMajor
        ]
        
        // Both calls are equivalent
        Alamofire.request("\(BASE_URL)/service/upload/pos", method: .post, parameters: parameters, encoding: JSONEncoding.default)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        determineMyCurrentLocation()
    }
}

