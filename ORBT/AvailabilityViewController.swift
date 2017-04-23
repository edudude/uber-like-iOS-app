
import UIKit
import InteractiveSideMenu

class AvailabilityViewController: MenuItemContentViewController {
    
    @IBOutlet weak var mMonF: UIButton!
    @IBOutlet weak var mMonT: UIButton!
    @IBOutlet weak var mTueF: UIButton!
    @IBOutlet weak var mTueT: UIButton!
    @IBOutlet weak var mWedF: UIButton!
    @IBOutlet weak var mWedT: UIButton!
    @IBOutlet weak var mThuF: UIButton!
    @IBOutlet weak var mThuT: UIButton!
    @IBOutlet weak var mFriF: UIButton!
    @IBOutlet weak var mFriT: UIButton!
    @IBOutlet weak var mSatF: UIButton!
    @IBOutlet weak var mSatT: UIButton!
    @IBOutlet weak var mSunF: UIButton!
    @IBOutlet weak var mSunT: UIButton!
    
    var mFrom = [UIButton]()
    var mTo = [UIButton]()
    @IBAction func didOpenMenu(_ sender: UIButton) {
        showMenu()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // From buttons
        mFrom.append(mMonF)
        mFrom.append(mTueF)
        mFrom.append(mWedF)
        mFrom.append(mThuF)
        mFrom.append(mFriF)
        mFrom.append(mSatF)
        mFrom.append(mSunF)
        // To buttons
        mTo.append(mMonT)
        mTo.append(mTueT)
        mTo.append(mWedT)
        mTo.append(mThuT)
        mTo.append(mFriT)
        mTo.append(mSatT)
        mTo.append(mSunT)

        for i in 0..<7  {
            mFrom[i].setTitle("09:00 AM", for: .normal)
            mFrom[i].sizeToFit()
            mTo[i].setTitle("05:00 PM", for: .normal)
            mTo[i].sizeToFit()
        }
    }

}
