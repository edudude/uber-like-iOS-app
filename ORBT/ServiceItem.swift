import UIKit
class ServiceItem: UITableViewCell {
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var mCheck: UIButton!
    @IBOutlet weak var txtPrice: UILabel!
    @IBOutlet weak var imgService: UIImageView!
    @IBAction func onClick(_ sender: Any) {
        mCheck.isSelected = !mCheck.isSelected
        data?.isSelected = mCheck.isSelected
    }
    var data: ServiceCategory?
}

class AvailabilityItem: UITableViewCell {
    @IBOutlet weak var mDay: UILabel!
    @IBOutlet weak var mFrom: UIButton!
    @IBOutlet weak var mTo: UIButton!
}
