
import UIKit
import InteractiveSideMenu
import Alamofire

class AvailabilityViewController: MenuItemContentViewController, UITableViewDelegate, UITableViewDataSource{
    
    // These strings will be the data for the table view cells
    let animals: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    // These are the colors of the square views in our table view cells.
    // In a real project you might use UIImages.
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "AvailabilityItem"
    
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
    }
    @IBAction func onAskForApproval(_ sender: Any) {
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
