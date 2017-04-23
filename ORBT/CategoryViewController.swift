
import UIKit
import InteractiveSideMenu
import Alamofire

class CategoryViewController: MenuItemContentViewController, UITableViewDelegate, UITableViewDataSource{
    
    // These strings will be the data for the table view cells
    let animals: [String] = ["Service1", "Service2", "Service3", "Service4", "Service5", "Service6", "Service7"]
    // These are the colors of the square views in our table view cells.
    // In a real project you might use UIImages.
    let colors = [UIColor.blue, UIColor.yellow, UIColor.magenta, UIColor.red, UIColor.brown]
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "ServiceItem"
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animals.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ServiceItem = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ServiceItem
        
        cell.myCellLabel.text = self.animals[indexPath.row]
        cell.myCellLabel.sizeToFit()
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        let cell = tableView.cellForRow(at: indexPath) as! ServiceItem
        cell.mCheck.isSelected = !cell.mCheck.isSelected

    }
    @IBAction func didOpenMenu(_ sender: UIButton) {
        showMenu()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mID = 14
        let parameters = [
            "id"        : mID
        ]
        
        // Both calls are equivalent
        Alamofire.request("\(BASE_URL)/user/servicelist/getbyid", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            // make sure we got JSON and it's a dictionary
            guard let json = response.result.value as? [String: AnyObject] else {
                print("didn't get todo object as JSON from API")
                return
            }
            if ((json["success"] as? String) == "T") {
                print("success")
                guard let mJsonArray = json["servicelist"] as? [Int] else {
                    return
                }
                
                for i in 0..<self.animals.count {
                    let indexPath = IndexPath(row: i, section: 0)
                    let cell = self.tableView.cellForRow(at: indexPath) as! ServiceItem
                    cell.mCheck.isSelected = false
                }
                for var mIndex in mJsonArray {
                    let indexPath = IndexPath(row: mIndex, section: 0)
                    let cell = self.tableView.cellForRow(at: indexPath) as! ServiceItem
                    cell.mCheck.isSelected = true
                }
            } else {
            }
        }
    }
    @IBAction func onAskForApproval(_ sender: Any) {
        var mServiceArray = [Int]()
        for i in 0..<self.animals.count {
            let indexPath = IndexPath(row: i, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as! ServiceItem
            if cell.mCheck.isSelected {
                mServiceArray.append(i)
            }
        }
        let parameters = [
            "id"          : mID,
            "servicelist" : mServiceArray
        ] as [String : Any]
        
        // Both calls are equivalent
        Alamofire.request("\(BASE_URL)/user/servicelist/setbyid", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            // make sure we got JSON and it's a dictionary
            guard let json = response.result.value as? [String: AnyObject] else {
                print("didn't get todo object as JSON from API")
                return
            }
            if ((json["success"] as? String) == "T") {
                print("success")
            } else {
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
