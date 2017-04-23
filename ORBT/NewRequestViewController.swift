import UIKit
import CoreLocation
import Alamofire
import Foundation
import MapKit
import InteractiveSideMenu

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

class NewRequestViewController: MenuItemContentViewController , MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    //Collection
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mServiceRequest: UIButton!
    
    fileprivate var collectionViewLayout: LGHorizontalLinearFlowLayout!
    
    var stringArray: [String] = ["Service1", "Service2", "Service3", "Service4", "Service5", "Service6", "Service7"]
    var selectedCell: Int! = 0
    //End

    var mMine = MKPointAnnotation()
    var mProviders = [CustomPointAnnotation]()
    var mFlag = 1
    
    @IBAction func onAskNewRequest(_ sender: Any) {
        guard let menuContainerViewController = self.parent as? CustomerViewController else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectProviderViewController") as! SelectProviderViewController
        vc.mSelectService = selectedCell
        menuContainerViewController.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Collection
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        
        selectedCell = 0
        
        self.collectionViewLayout = LGHorizontalLinearFlowLayout.configureLayout(self.collectionView, itemSize: CGSize(width: 90, height: 90), minimumLineSpacing: 10)
        //End
        
        // Do any additional setup after loading the view, typically from a nib.
        setMyLocation()
        
        var i = 1
        for i in 0..<100 {
            mProviders += [CustomPointAnnotation()]
            mProviders[i].coordinate = CLLocationCoordinate2DMake(10000, 10000)
            mProviders[i].title = "Service"
            mProviders[i].subtitle = "Provider"
            mProviders[i].imageName = "Service3.png"
            self.mapView.addAnnotation(mProviders[i])
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.canShowCallout = true
        }
        else {
            anView?.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        anView?.image = resizeImage(image:UIImage(named:cpa.imageName)!, targetSize: CGSize(width:100, height:100))
        return anView
    }
    func setMyLocation() {
        var latDelta:CLLocationDegrees = 0.01
        
        var longDelta:CLLocationDegrees = 0.01
        
        var theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        var pointLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(mLatitude, mLongitude)
        
        var region:MKCoordinateRegion = MKCoordinateRegionMake(pointLocation, theSpan)
        self.mapView.setRegion(region, animated: true)

        var pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(mLatitude, mLongitude)
        mMine.coordinate = pinLocation
        mMine.title = "me"
        self.mapView.addAnnotation(mMine)
    }
    
    func getLocationFromServer() {
        if (mFlag == 0) {
            return
        }
        
        Alamofire.request("\(BASE_URL)/service/locations").responseJSON { response in
            
            // make sure we got JSON and it's a dictionary
            guard let json = response.result.value as? [String: AnyObject] else {
                print("didn't get todo object as JSON from API")
                return
            }
            if ((json["success"] as? String) == "T") {
                print("success")
                guard let mLocations = json["locations"] as? [[String: AnyObject]] else {
                    return
                }
                print(mLocations)

                self.mMine.coordinate = CLLocationCoordinate2DMake(mLatitude, mLongitude)

                var i = 0
                for var mTmp in mLocations {
                    var mLat = mTmp["latitude"] as? String
                    var mLon = mTmp["longitude"] as? String
                    self.mProviders[i].coordinate = CLLocationCoordinate2DMake(Double(mLat!)!, Double(mLon!)!)
                    
                    var mMajor = mTmp["major"] as? Int
                    if self.mProviders[i].imageName != "Service\(mMajor!)" {
                        self.mProviders[i].imageName = "Service\(mMajor!)"
                        self.mapView.removeAnnotation(self.mProviders[i])
                        self.mapView.addAnnotation(self.mProviders[i])
                    }
                    i = i + 1
                }
                while i < 100 {
                    self.mProviders[i].coordinate = CLLocationCoordinate2DMake(10000, 10000)
                    i = i + 1
                }
            } else {
            }
            self.getLocationFromServer();
        }

    }
    @IBAction func didOpenMenu(_ sender: UIButton) {
        showMenu()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mFlag = 1
        getLocationFromServer()
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        mFlag = 0
        super.viewWillDisappear(animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stringArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
            as! collectionViewCell
        
        cell.layer.shouldRasterize = true;
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        if(selectedCell != nil){
            if(indexPath.item == selectedCell){
                cell.image.image = UIImage(named: stringArray[indexPath.item])!
            }
            else{
                cell.image.image = UIImage(named: stringArray[indexPath.item])!
            }
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        findCenterIndex(scrollView)
    }
    
    func findCenterIndex(_ scrollView: UIScrollView) {
        let collectionOrigin = collectionView!.bounds.origin
        let collectionWidth = collectionView!.bounds.width
        var centerPoint: CGPoint!
        var newX: CGFloat!
//        if collectionOrigin.x > 0
//        {
            newX = collectionOrigin.x + collectionWidth / 2
            centerPoint = CGPoint(x: newX, y: collectionOrigin.y)
//        }
//        else {
//            newX = collectionWidth / 2
//            centerPoint = CGPoint(x: newX, y: collectionOrigin.y)
//        }
//        
        print(centerPoint)
        let index = collectionView!.indexPathForItem(at: centerPoint)
        let cell = collectionView!.cellForItem(at: IndexPath(item: 0, section: 0)) as? collectionViewCell
        
        if(index != nil){
            for cell in self.collectionView.visibleCells   {
                let currentCell = cell as! collectionViewCell
//                currentCell.image.image = UIImage(named: "EmptyCircle")!
            }
            
            let cell = collectionView.cellForItem(at: index!) as? collectionViewCell
            if(cell != nil) {
//                cell!.image.image = UIImage(named: "FullCircle")!
                selectedCell = collectionView.indexPath(for: cell!)?.item
            }
        }
        else if(cell != nil){
            let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
            for cellView in self.collectionView.visibleCells   {
                let currentCell = cellView as? collectionViewCell
//                currentCell!.image.image = UIImage(named: "EmptyCircle")!
                
                if(currentCell == cell! && (selectedCell == 0 || selectedCell == 1) && actualPosition.x > 0){
//                    cell!.image.image = UIImage(named: "FullCircle")!
                    selectedCell = collectionView.indexPath(for: cell!)?.item
                }
            }
        }
    }
}


class collectionViewCell: UICollectionViewCell {
    @IBOutlet var image: UIImageView!
}

