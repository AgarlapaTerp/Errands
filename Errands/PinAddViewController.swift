//
//  PinAddViewController.swift
//  Errands
//
//  Created by user256510 on 4/19/24.
//

import UIKit
import MapKit

class PinAddViewController: UIViewController {

    @IBOutlet weak var pinTitle: UITextField!
    @IBOutlet weak var pinDescription: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var mapView: MKMapView?
    var placeHolder: (any MKAnnotation)?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButtonState()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //removes placeholder annotation when view dissapears
        if let placeHolder = placeHolder {
            if let title = placeHolder.title {
                if title == "Title" { mapView?.removeAnnotation(placeHolder) }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
