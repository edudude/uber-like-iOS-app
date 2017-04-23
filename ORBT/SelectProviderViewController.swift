
import UIKit
import Alamofire
import Foundation
import CoreLocation
import MapKit

class ServiceProvider {
    var firstName: String?
    var lastName: String?
    var email: String?
    var id: Int?
    init(mJson: [String:AnyObject]) {
        firstName = mJson["firstname"] as! String
        lastName = mJson["lastname"] as! String
        email = mJson["email"] as! String
        id = mJson["id"] as! Int
    }
}

class SelectProviderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , MKMapViewDelegate {
    
    var mSelectService = 0
    var mIndex = -1

    var mCandidates = [ServiceProvider]()
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "ProviderItem"
    let annotation = MKPointAnnotation()

    @IBOutlet weak var mDate: UIDatePicker!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    func handleLongPress(_ getstureRecognizer : UIGestureRecognizer){
        if getstureRecognizer.state != .began { return }
        
        let touchPoint = getstureRecognizer.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        annotation.coordinate = touchMapCoordinate
    }
    
    @IBAction func onSendToServer(_ sender: Any) {
        if mIndex == -1 {
            let alert = UIAlertController(title: "Alert", message: "Select a service provider", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        var timeFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.short
        timeFormatter.dateStyle = DateFormatter.Style.short
        
        var strDate = timeFormatter.string(from: mDate.date)
        
        let parameters = [
            "customerid" : mID,
            "customername" : mName,
            "providerid" : mCandidates[mIndex].id,
            "providername" : "\(mCandidates[mIndex].firstName!) \(mCandidates[mIndex].lastName!)",
            "serviceid": mSelectService,
            "time" : strDate,
            "latitude" : annotation.coordinate.latitude,
            "longitude" : annotation.coordinate.longitude
        ] as [String : Any]
        Alamofire.request("\(BASE_URL)/service/newrequest", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            // make sure we got JSON and it's a dictionary
            guard let json = response.result.value as? [String: AnyObject] else {
                print("didn't get todo object as JSON from API")
                return
            }
            if ((json["success"] as? String) == "T") {
                let alert = UIAlertController(title: "Alert", message: "Request sent to provider", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(SelectProviderViewController.handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 0.3
        mapView.addGestureRecognizer(longPressRecogniser)
        
        annotation.coordinate = CLLocationCoordinate2DMake(mLatitude, mLongitude)
        mapView.addAnnotation(annotation)

        let parameters = [
            "serviceid": mSelectService
        ]
        Alamofire.request("\(BASE_URL)/service/candidates", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            // make sure we got JSON and it's a dictionary
            guard let json = response.result.value as? [String: AnyObject] else {
                print("didn't get todo object as JSON from API")
                return
            }
            if ((json["success"] as? String) == "T") {
                print("success")
                guard let mJsonArray = json["candidates"] as? [[String: AnyObject]] else {
                    return
                }
                
                for var mOne in mJsonArray {
                    self.mCandidates.append(ServiceProvider(mJson: mOne))
                }
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            } else {
            }
        }

        tableView.delegate = self
        tableView.dataSource = self
    }
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mCandidates.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ProviderItem = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ProviderItem
        
        cell.mLabel.text = self.mCandidates[indexPath.row].firstName! + " " + self.mCandidates[indexPath.row].lastName!
        cell.mLabel.sizeToFit()
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).\(mIndex)")
        mIndex = indexPath.row
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
