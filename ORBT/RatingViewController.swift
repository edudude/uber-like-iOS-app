import UIKit
import CoreLocation
import Alamofire
import Foundation

class RatingViewController: UIViewController {
    var mJobId = 0
    var mJobView : JobViewController?

    @IBOutlet weak var mRating: RatingControl!
    @IBOutlet weak var mFeedback: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func onOK(_ sender: Any) {
        let parameters = [
            "id" : mJobId,
            "rating" : mRating.rating,
            "feedback" : mFeedback.text
        ] as [String : Any]
        
        Alamofire.request("\(BASE_URL)/service/endJob", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            self.mJobView?.getFromServer()
            self.dismiss(animated: false, completion: nil)
        }
    }
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
