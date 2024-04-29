//
//  PinInfoViewController.swift
//  Errands
//
//  Created by user256510 on 4/17/24.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class PinInfoViewController: UIViewController {

    @IBOutlet weak var pinTitle: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var coordinates: UILabel!
    @IBOutlet weak var distanceTo: UILabel!
    @IBOutlet weak var address: UILabel!
    
    var mapViewController: ViewController?
    
    //core data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var Title: String?
    var subTitle: String?
    var coord: CLLocationCoordinate2D?
    var dist: String?
    var pinAddress: String?
    
    var mapView: MKMapView?
    var pin: (any MKAnnotation)?
    
    var coreDataPin: MapPin?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        findCoreDataPin()

        // Do any additional setup after loading the view.
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLabels()
        findCoreDataPin()
    }
    
    func setLabels(){
        if let Title = Title, let subTitle = subTitle, let coord = coord, let dist = dist {
            pinTitle.text = Title
            subtitle.text = subTitle
            coordinates.text = String("Coordinates: \(coord.latitude), \(coord.longitude)")
            distanceTo.text = "Distance: \(dist) miles"
            address.text = pinAddress
            
        }
    }
    
    
    func findCoreDataPin() {
        guard let pin = pin else {return }
        
        if let pointAnnotation = pin as? MKPointAnnotation {
            
            let fetchRequest = MapPin.fetchRequest()
            let pins = try? context.fetch(fetchRequest)
            
            
            if let pins = pins{
                
                for pin in pins {
                    if pin.title == pointAnnotation.title && pin.subTitle == pointAnnotation.subtitle {
                        coreDataPin = pin
                        return
                    }
                }
            }
            
        }
    }
    
    @IBAction func deletePin(_ sender: UIButton) {
        //show an alert now, when deleting
        let alertController = UIAlertController(title: "Are you sure?", message: "Notes associated with this pin will be deleted", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
            if let coreDataPin = self.coreDataPin{
                self.context.delete(coreDataPin)
                try? self.context.save()
                guard let pin = self.pin else {return }
                
                if let pointAnnotation = pin as? MKPointAnnotation {
                    self.mapView?.removeAnnotation(pointAnnotation)
                }
            }
            
            self.dismiss(animated: true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
        
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
        
        if let coreDataPin {
            mapViewController?.segueToNotes(coreDataPin)
        }
        self.dismiss(animated: true)
    }
    
    
    
    

}
