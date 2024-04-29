//
//  PinTableViewController.swift
//  Errands
//
//  Created by user256510 on 4/23/24.
//

import UIKit
import MapKit
import CoreLocation

class PinTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var pins: [MapPin] = []
    var mapView: MKMapView?
    
    var sortingIndex = 0
    
    var handleMapSearchDelegate:ViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? context.save()
        getAllItems()
        
        let sortMenu = UIMenu(title: "Sort By", image: UIImage(systemName: "arrow.up.arrow.down"), options: .singleSelection, children: [
            UIAction(title: "Recent", handler: recentAction),
            UIAction(title: "Alphabetical", handler: alphabeticalAction)
        
        ])
        
        
        let sortSelectionButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"),primaryAction: nil, menu: sortMenu)
        
        navigationItem.rightBarButtonItem = sortSelectionButton
        
        
        
    }
    
    //menu methods
    func recentAction(action: UIAction) {
        getAllItems()
    }
    
    func alphabeticalAction(action: UIAction){
        pins.sort { $0.title!.lowercased() < $1.title!.lowercased()}
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateView()
        }
        
        sortingIndex = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        try? context.save()
        handleMapSearchDelegate = tabBarController?.viewControllers?[0] as? ViewController
        getAllItems()
        
        if sortingIndex == 1 {
            alphabeticalAction(action: UIAction(title: "") {_ in })
        }
        
        
    }
    
    
    
    //core data functions
    func getAllItems() {
        do {
            pins = try context.fetch(MapPin.fetchRequest())
            pins.reverse()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.updateView()
            }
        } catch {
            
        }
    }
    
    func updateView() {
        if pins.isEmpty {
            
            var configuration = UIContentUnavailableConfiguration.empty()
            configuration.image = UIImage(systemName: "mappin.slash")
            configuration.text = "No Pins Made"
            configuration.secondaryText = "Pins you have added will appear here."
            let contentUnavailableView = UIContentUnavailableView(configuration: configuration)
                        
            tableView.backgroundView = contentUnavailableView
            tableView.separatorStyle = .none
        } else  {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pins.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pin = pins[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "pinTableReuse", for: indexPath)
        
        
        var content = cell.defaultContentConfiguration()
        let img = UIImage(systemName: "mappin.square")
        
        content.image = img
        content.imageProperties.tintColor = .purple
        content.imageProperties.maximumSize = CGSize(width: 100, height: 100)
        
        content.text = pin.title!
        content.secondaryText = pin.subTitle!
        
        // Configure the cell...
        
        cell.contentConfiguration = content
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "notesFromTable", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedPath = tableView.indexPathForSelectedRow else {return}
        
        let destinationVC = segue.destination as! NotesViewController
        destinationVC.mapPin = pins[selectedPath.row]
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let copyAction = UIContextualAction(style: .normal, title: "Copy Coords") { (action,srcView,completion) in
            UIPasteboard.general.string = "\(self.pins[indexPath.row].latitude),\(self.pins[indexPath.row].longitude)"
            completion(true)
        }
        copyAction.backgroundColor = UIColor.systemBlue
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action,srcView,completion) in
            let alertController = UIAlertController(title: "Are you sure?", message: "Notes associated with this pin will be deleted", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                let deletePin = self.pins[indexPath.row]
                //now have to remove from map itself
    //            removeAnnotation(withLatitude: deletePin.latitude, longitude: deletePin.longitude)
                self.context.delete(deletePin)
                
                
                
                do {
                    try self.context.save()
                } catch {
                    print("context was not able to save within the delete function of tableview")
                }
                
                self.pins.remove(at: indexPath.row)
                
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            
            }
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            completion(true)
        }
        deleteAction.backgroundColor = UIColor.systemRed
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [copyAction,deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = true
        return swipeConfiguration
    }
}
