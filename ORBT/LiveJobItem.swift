import UIKit
import MapKit
import Alamofire
class ServiceListCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var txtServiceName: UILabel!
}
class LiveJobItem: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var mCustomer: UILabel!
    @IBOutlet weak var mProvider: UILabel!
    @IBOutlet weak var mTime: UILabel!
    @IBOutlet weak var mPrice: UILabel!
    @IBOutlet weak var mButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mRating: RatingControl!
    @IBOutlet weak var mRatingNum: UILabel!
    @IBOutlet weak var mFeedback: UITextView!
    fileprivate var collectionViewLayout: LGHorizontalLinearFlowLayout!

    var data:Job?
    var mJobId: Int?
    var mStatus: Int?
    
    var viewController : JobViewController?
    
    override func awakeFromNib() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        
        self.collectionViewLayout = LGHorizontalLinearFlowLayout.configureLayout(self.collectionView, itemSize: CGSize(width: 150, height: 130), minimumLineSpacing: 10)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (data?.categoryName!.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceListCell", for: indexPath)
            as! ServiceListCell
        
        cell.layer.shouldRasterize = true;
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        cell.image.ImageFromURL(url: "\(BASE_URL)/images/\((data?.imageList?[indexPath.item])!)", indicatorColor: .gray, errorImage: UIImage(), imageView: cell.image)
        cell.txtServiceName.text = data?.categoryName?[indexPath.item]
        return cell
    }

    @IBAction func onSend(_ sender: Any) {
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
