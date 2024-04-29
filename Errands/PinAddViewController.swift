//
//  PinAddViewController.swift
//  Errands
//
//  Created by user256510 on 4/19/24.
//

import CoreData
import UIKit
import MapKit

class PinAddViewController: UIViewController {

    @IBOutlet weak var pinTitle: UITextField!
    @IBOutlet weak var pinDescription: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var mapView: MKMapView?
    var placeHolder: (any MKAnnotation)?
    
    //core data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButtonState()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //removes placeholder annotation when view dissapears
        if let placeHolder = placeHolder {
            if let title = placeHolder.title, let subtitle = placeHolder.subtitle {
                if title == "Title" {
                    mapView?.removeAnnotation(placeHolder)
                } else {
                    //adding to coredata
                    let newItem = MapPin(context: context)
                    newItem.latitude = placeHolder.coordinate.latitude
                    newItem.longitude = placeHolder.coordinate.longitude
                    newItem.id = UUID()
                    newItem.title = title
                    newItem.subTitle = subtitle
                    newItem.note = NSAttributedString(string: "")
                    newItem.address = ""
                    
                }
            }
        }
    }
    
    
    
    @IBAction func addPin(_ sender: UIButton) {
        
        guard let placeHolder = placeHolder else {return }
        
        if let pointAnnotation = placeHolder as? MKPointAnnotation {
            pointAnnotation.title = pinTitle.text
            pointAnnotation.subtitle = pinDescription.text
        }
        
        clearPinInfoHelper()
        self.dismiss(animated: true)
        
    }
    
    
    @IBAction func clearPinInfo(_ sender: UIButton) {
        clearPinInfoHelper()
    }
    
    func clearPinInfoHelper() {
        pinTitle.text = ""
        pinDescription.text = ""
        addButton.isEnabled = false
    }
    
    @IBAction func pinTitleFieldChanged(_ sender: UITextField) {
        updateButtonState()
    }
    

    @IBAction func pinDescriptionDidChange(_ sender: UITextField) {
        updateButtonState()
    }
    
    func updateButtonState() {
        let title = pinTitle.text ?? ""
        let desc = pinDescription.text ?? ""
        
        addButton.isEnabled = !title.isEmpty && !desc.isEmpty
    }
    

}
