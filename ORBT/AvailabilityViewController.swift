
import UIKit
import InteractiveSideMenu
import Alamofire
import CircularSpinner
import SwiftyJSON

class AvailabilityViewController: MenuItemContentViewController, UITableViewDelegate, UITableViewDataSource{
    
    // These strings will be the data for the table view cells
    let animals: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    // These are the colors of the square views in our table view cells.
    // In a real project you might use UIImages.
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "AvailabilityItem"
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var btnCheck: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    @IBAction func onClickCheck(_ sender: Any) {
        btnCheck.isSelected = !btnCheck.isSelected
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animals.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:AvailabilityItem = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AvailabilityItem

        cell.mDay.text = self.animals[indexPath.row]
        cell.mFrom.setTitle("09:00 AM", for: .normal)
        cell.mTo.setTitle("05:00 PM", for: .normal)
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    @IBAction func didOpenMenu(_ sender: UIButton) {
        showMenu()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let parameters = [
            "id"     : mID
        ]
        CircularSpinner.show("Loading...", animated: true, type: .indeterminate, showDismissButton: false, delegate: nil)
        Alamofire.request("\(BASE_URL)/user/auth/getuserinfo", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
            CircularSpinner.hide()
            
            if((resData.result.value) != nil) {
                let swiftyJsonVar = JSON(resData.result.value!)
                
                if swiftyJsonVar["success"].stringValue == "T" {
                    if (swiftyJsonVar["userInfo"]["canWork"].intValue == 1) {
                        self.btnCheck.isSelected = true
                    } else {
                        self.btnCheck.isSelected = false
                    }
                }
                else {
                    let alert = UIAlertController(title: "ORBT", message: swiftyJsonVar["message"].stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Failed to connect server!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func onAskForApproval(_ sender: Any) {
        var canWork:Int = 0
        if (self.btnCheck.isSelected == true) {
            canWork = 1
        }
        let parameters = [
            "id"     : mID,
            "canWork": canWork
        ]
        CircularSpinner.show("Updating...", animated: true, type: .indeterminate, showDismissButton: false, delegate: nil)
        Alamofire.request("\(BASE_URL)/user/canWork", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
            CircularSpinner.hide()
            
            if((resData.result.value) != nil) {
                let swiftyJsonVar = JSON(resData.result.value!)
                
                let alert = UIAlertController(title: "ORBT", message: swiftyJsonVar["message"].stringValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "Failed to connect server!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
