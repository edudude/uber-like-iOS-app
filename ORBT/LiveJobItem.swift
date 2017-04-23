import UIKit
import MapKit
import Alamofire

class LiveJobItem: UITableViewCell {
    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var mServiceName: UILabel!
    @IBOutlet weak var mCustomer: UILabel!
    @IBOutlet weak var mProvider: UILabel!
    @IBOutlet weak var mTime: UILabel!
    @IBOutlet weak var mPrice: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mButton: UIButton!
    var mJobId: Int?
    var mStatus: Int?
    var viewController : JobViewController?

    @IBAction func onButton(_ sender: Any) {
        if (mStatus == 0) {
            let refreshAlert = UIAlertController(title: "Job offer", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Cancel logic here")
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Accept", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Accept Logic here")
                let parameters = [
                    "id" : self.mJobId
                    ]
                
                Alamofire.request("\(BASE_URL)/service/acceptJob", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                    self.viewController?.getFromServer()
                }
            }))
            
            viewController?.present(refreshAlert, animated: true, completion: nil)
        } else {
            guard let menuContainerViewController = viewController?.parent as? CustomerViewController else { return }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
            vc.mJobId = mJobId!
            vc.mJobView = self.viewController
            menuContainerViewController.navigationController?.present(vc, animated: false)
        }
    }
}
class PastJobItem: UITableViewCell {
    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var mServiceName: UILabel!
    @IBOutlet weak var mCustomer: UILabel!
    @IBOutlet weak var mProvider: UILabel!
    @IBOutlet weak var mTime: UILabel!
    @IBOutlet weak var mPrice: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mButton: UIButton!
    @IBOutlet weak var mRating: UILabel!
    @IBOutlet weak var mFeedback: UILabel!
}
