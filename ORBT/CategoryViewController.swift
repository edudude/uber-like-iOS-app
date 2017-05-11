
import UIKit
import InteractiveSideMenu
import Alamofire
import SwiftyJSON
import CircularSpinner
import KImageView

class ServiceCategory {
    var id:Int = 0
    var image:String = ""
    var price:Int = 0
    var name:String = ""
    var isSelected:Bool = false
    
    init(mJson: JSON) {
        id = mJson["id"].intValue
        image = mJson["image"].stringValue
        price = mJson["price"].intValue
        name  = mJson["name"].stringValue
        isSelected = false
    }
}

class CategoryViewController: MenuItemContentViewController, UITableViewDelegate, UITableViewDataSource{
    let colors = [UIColor.blue, UIColor.yellow, UIColor.magenta, UIColor.red, UIColor.brown]
    @IBOutlet var tableView: UITableView!
    var allService = [ServiceCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print (allService.count)
        return allService.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ServiceItem") as! ServiceItem

        cell.imgService.ImageFromURL(url: "\(BASE_URL)/images/\(allService[indexPath.item].image)", indicatorColor: .gray, errorImage: UIImage(), imageView: cell.imgService)
        cell.txtPrice.text = "$\(allService[indexPath.item].price)"
        cell.txtName.text = allService[indexPath.item].name
        cell.mCheck.isSelected = allService[indexPath.item].isSelected
        cell.data = allService[indexPath.item]
        return cell
    }
    @IBAction func didOpenMenu(_ sender: UIButton) {
        showMenu()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CircularSpinner.show("Loading...", animated: true, type: .indeterminate, showDismissButton: false, delegate: nil)
        
        let parameters = [
            "id"     : mID
        ]
        Alamofire.request("\(BASE_URL)/user/servicelist/getbyid", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
            CircularSpinner.hide()
            
            if((resData.result.value) != nil) {
                let swiftyJsonVar = JSON(resData.result.value!)
                
                if swiftyJsonVar["success"].stringValue == "T" {
                    let jsonArray = swiftyJsonVar["allService"].arrayValue
                    
                    self.allService.removeAll()
                    for one in jsonArray {
                        self.allService.append(ServiceCategory(mJson: one))
                    }

                    let jsonIDs = swiftyJsonVar["servicelist"].arrayValue
                    for oneID in jsonIDs {
                        for oneService in self.allService {
                            if (oneService.id == oneID.intValue) {
                                oneService.isSelected = true
                            }
                        }
                    }
                    self.tableView.reloadData()
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
        var myServiceList = [Int]()
        for oneService in allService {
            if (oneService.isSelected) {
                myServiceList.append(oneService.id)
            }
        }
        let parameters = [
            "id"          : mID,
            "newList"     : myServiceList
        ] as [String:Any]
        CircularSpinner.show("Updating...", animated: true, type: .indeterminate, showDismissButton: false, delegate: nil)
        Alamofire.request("\(BASE_URL)/user/servicelist/setbyid", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
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
