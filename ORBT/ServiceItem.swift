import UIKit
class ServiceItem: UITableViewCell {
    @IBOutlet weak var myCellLabel: UILabel!
    @IBOutlet weak var mCheck: UIButton!
    @IBAction func onClick(_ sender: Any) {
    }
}

class AvailabilityItem: UITableViewCell {
    @IBOutlet weak var mDay: UILabel!
    @IBOutlet weak var mFrom: UIButton!
    @IBOutlet weak var mTo: UIButton!
}
