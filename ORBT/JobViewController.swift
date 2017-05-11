
import UIKit
import InteractiveSideMenu
import Alamofire

class Job {
    var mJobId: Int?
    var customerName: String?
    var providerName: String?
    var time: String?
    var latitude: Double?
    var longitude: Double?
    var status: Int?
    var feedback: String?
    var rating: Int?
    var price: Int?
    var categoryName: [String]?
    var imageList: [String]?
    
    init(mJson: [String:AnyObject]) {
        mJobId = mJson["id"] as! Int
        customerName = mJson["customername"] as! String
        providerName = mJson["providername"] as! String
        time = mJson["time"] as! String
        latitude = mJson["latitude"] as! Double
        longitude = mJson["longitude"] as! Double
        status = mJson["status"] as! Int
        price = mJson["price"] as! Int
        feedback = mJson["feedback"] as! String
        rating = mJson["rating"] as! Int
        categoryName = mJson["categoryName"] as! [String]
        imageList = mJson["imageList"] as! [String]
    }
}

class JobViewController: MenuItemContentViewController, UITableViewDelegate, UITableViewDataSource{
    
    // These strings will be the data for the table view cells
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "LiveJobItem"
    var mJobs = [Job]()
    var mStatus = 0
    var mIsCustomer = 1
    let mTitles = ["Pending requests", "Jobs in progress", "Past jobs"]
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var mTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mTitle.text = mTitles[mStatus]
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mJobs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var normalHeight:CGFloat = 300
        if (mStatus == 0) {
            if (mIsCustomer == 0) {
                return normalHeight
            } else {
                return normalHeight - 40
            }
        }
        if (mStatus == 1) {
            if (mIsCustomer == 0) {
                return normalHeight - 40
            } else {
                return normalHeight
            }
        }
        return 390
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = self.tableView.dequeueReusableCell(withIdentifier: "LiveJobItem") as! LiveJobItem
            cell.data = mJobs[indexPath.row]
            var data = cell.data
            cell.viewController = self

            cell.mCustomer.text = data?.customerName
            cell.mProvider.text = data?.providerName
            cell.mTime.text = data?.time
            cell.mPrice.text = "$\((data?.price)!)"
            cell.mJobId = data?.mJobId
            cell.mStatus = data?.status
            cell.collectionView.reloadData()

            if (mStatus == 0) {
                if (mIsCustomer == 1) {
                    cell.mButton.isHidden = true;
                } else {
                    cell.mButton.isHidden = false;
                    cell.mButton.setTitle("Accept", for: .normal)
                }
            } else {        //mStatus == 1 (progress)
                if (mIsCustomer == 0) {
                    cell.mButton.isHidden = true;
                } else {
                    cell.mButton.isHidden = false;
                    cell.mButton.setTitle("End", for: .normal)
                }
            }
        if (mStatus == 2) {
            cell.mFeedback.isHidden = false
            cell.mRating.isHidden = false
            cell.mRatingNum.isHidden = false
            cell.mButton.isHidden = true
            
            cell.mFeedback.text = data?.feedback
            cell.mRatingNum.text = "\((data?.rating)!).0"
            cell.mRating.rating = (data?.rating)!
        } else {
            cell.mFeedback.isHidden = true
            cell.mRating.isHidden = true
            cell.mRatingNum.isHidden = true
        }
            return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    @IBAction func didOpenMenu(_ sender: UIButton) {
        showMenu()
    }
    func getFromServer() {
        let parameters = [
            "status" : mStatus,
            "id" : mID,
            "iscustomer" : mIsCustomer
        ]
        Alamofire.request("\(BASE_URL)/service/getjobs", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            // make sure we got JSON and it's a dictionary
            guard let json = response.result.value as? [String: AnyObject] else {
                print("didn't get todo object as JSON from API")
                return
            }
            if ((json["success"] as? String) == "T") {
                print("success")
                guard let mJsonArray = json["job"] as? [[String: AnyObject]] else {
                    return
                }
                
                self.mJobs.removeAll()
                for var mOne in mJsonArray {
                    self.mJobs.append(Job(mJson: mOne))
                }
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            } else {
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFromServer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

