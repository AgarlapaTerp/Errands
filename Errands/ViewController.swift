//
//  ViewController.swift
//  Errands
//
//  Created by user256510 on 4/16/24.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class ViewController: UIViewController, MKMapViewDelegate{
    fileprivate let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    let annotationInfoView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PinInfoViewController") as! PinInfoViewController
    let annotationAddView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PinAddViewController") as! PinAddViewController
    let locationSearchTable = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
    
    //for PinInfoViewController
    var Title: String?
    var subTitle: String?
    
    //searchBar
    var resultSearchController: UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //location config
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.setRegion(MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)), animated: false)
        
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:))))
        
        annotationAddView.mapView = self.mapView
        annotationInfoView.mapView = self.mapView
        annotationInfoView.mapViewController = self
        
        //adding search bar
        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"
        resultSearchController!.searchBar.searchTextField.backgroundColor = .white
        navigationItem.searchController = resultSearchController
        
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        
    }
    
    //not sure why its an array?
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        //code to come when an annotation is added to the mapview
        let annotation = views[0].annotation
        guard annotation is MKPointAnnotation else { return }
        guard let title = views[0].annotation?.title else {return }
        
        if title == "My Location"{
            return
        }
        if (annotation as? MKPointAnnotation)?.accessibilityLabel == "DONTADD"{
            return
        }
        
        //we have an actual annotation now
        
        annotationAddView.placeHolder = annotation
        
        if let sheet = annotationAddView.sheetPresentationController {
            sheet.detents = [.medium()]
                sheet.largestUndimmedDetentIdentifier = .large
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersEdgeAttachedInCompactHeight = true
                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            }
            
            print("does the pin add subsheet work")
        self.present(annotationAddView, animated: true)
        
        
        
    }
    
    //when didAdd gets called, its a placeholder annotation
    //this method will show a sheet just like the other
    //At the end of the sheet, it will either add the annotation or not
    //at the end of the didAdd method, we want to remove the placeholder annotation
    //Questions: can we pass iboutlet objects from viewcontroller to view controller
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

            let identifier = "Annotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
            } else {
                annotationView!.annotation = annotation
            }

            return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        guard annotation is MKPointAnnotation else {
            print("Not an MKPointAnnotation")
            return
        }
        
        let distance = MKMapPoint(annotation.coordinate).distance(to: MKMapPoint(mapView.userLocation.coordinate))
        
        if let annotationTitle = annotation.title, let annotationSubTitle = annotation.subtitle {
            annotationInfoView.Title = annotationTitle
            annotationInfoView.subTitle = annotationSubTitle
            annotationInfoView.coord = annotation.coordinate
            annotationInfoView.dist = String(distance)
            annotationInfoView.pin = annotation
            
            
            
            if let sheet = annotationInfoView.sheetPresentationController {
                sheet.detents = [.custom(resolver: { context in
                    0.25 * context.maximumDetentValue
                }), .medium()]
                    sheet.largestUndimmedDetentIdentifier = .large
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersEdgeAttachedInCompactHeight = true
                    sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
                }
                
                print("does this work")
            self.present(annotationInfoView, animated: true)
        }
        
    }
    
    
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "Title"
            annotation.subtitle = "Subtitle"
            
            mapView.addAnnotation(annotation)

        }
    }
    
    


}

//handling Search Bar results
extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        guard let selectedPin = selectedPin else {return }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        let address = "\(selectedPin.thoroughfare ?? ""), \(selectedPin.locality ?? ""), \(selectedPin.subLocality ?? ""), \(selectedPin.administrativeArea ?? ""), \(selectedPin.postalCode ?? ""), \(selectedPin.country ?? "")"
        annotation.subtitle = address
        
        //to make the didAdd method not show sheet
        annotation.accessibilityLabel = "DONTADD"
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        
        
    }
}


extension ViewController : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("location:: \(location)") //debugging purposes
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    
    
}

extension ViewController {
    
    func segueToNotes(Title: String, subTitle: String) {
        self.Title = Title
        self.subTitle = subTitle
        performSegue(withIdentifier:"toTheNotes" ,sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? NotesViewController {
            destinationVC.pTitle = Title
            destinationVC.pDescription = "Description: \(subTitle ?? "")"
        }
    }
}

