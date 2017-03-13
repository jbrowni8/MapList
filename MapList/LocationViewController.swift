//
//  LocationViewController
//  MapList
//
//  Created by James Browning on 3/11/17.
//  Copyright © 2017 James Browning. All rights reserved.
//

import UIKit

var locationTypes = [
    "Street address",
    "Point of interest",
    "Real estate agency",
    "Pet store",
    "Furniture store",
    "Clothing store",
    "Lodging",
    "Parking",
    "Night club",
    "Store",
    "Department store",
    "Transit station",
    "Shoe store",
    "Subway station",
    "Shopping mall"
]

class LocationViewController: UITableViewController {
    
    var locationType : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return locationTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
        
        cell.textLabel?.text = locationTypes[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        self.locationType = locationTypes[indexPath.row]
        
        //print("LocationViewController: \(locationType)")

//        let title = "Nearby location type"
//        let message = "You have selected \(locationTypes[indexPath.row])"
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
//        alertController.addAction(okayAction)
//        present(alertController, animated: true, completion: nil)
//        self.tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "unwindToMain", sender: self)

    }
    
    // Pass the selected place to the new view controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToMain" {
            if let nextViewController = segue.destination as? Controller {
                nextViewController.selectedType = locationType
            }
        }
    }
    
}
