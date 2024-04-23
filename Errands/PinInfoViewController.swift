//
//  PinInfoViewController.swift
//  Errands
//
//  Created by user256510 on 4/17/24.
//

import UIKit
import CoreLocation
import MapKit

class PinInfoViewController: UIViewController {

    @IBOutlet weak var pinTitle: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var coordinates: UILabel!
    @IBOutlet weak var distanceTo: UILabel!
    
    var mapViewController: ViewController?
    
    var Title: String?
    var subTitle: String?
    var coord: CLLocationCoordinate2D?
    var dist: String?
    
    var mapView: MKMapView?
    var pin: (any MKAnnotation)?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("loaded")

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLabels()
    }
    
    func setLabels(){
        if let Title = Title, let subTitle = subTitle, let coord = coord, let dist = dist {
            pinTitle.text = Title
            subtitle.text = subTitle
            coordinates.text = String("\(coord.latitude), \(coord.longitude)")
            distanceTo.text = dist
        }
    }
    
    
    @IBAction func deletePin(_ sender: UIButton) {
        guard let pin = pin else {return }
        
        if let pointAnnotation = pin as? MKPointAnnotation {
            mapView?.removeAnnotation(pointAnnotation)
        }
        
        self.dismiss(animated: true)
    }
    
    @IBAction func sendToMaps(_ sender: UIButton) {
        guard let coord else { return }
        let placemark = MKPlacemark(coordinate: coord)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = Title
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        
        mapItem.openInMaps(launchOptions: launchOptions)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func sendToNote(_ sender: UIButton) {
        guard let Title = Title, let subTitle = subTitle else {return }
        mapViewController?.segueToNotes(Title: Title, subTitle: subTitle)
        self.dismiss(animated: true)
    }
    
    
    
    

}
