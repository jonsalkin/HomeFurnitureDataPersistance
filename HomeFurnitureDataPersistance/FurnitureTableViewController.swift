//
//  FurnitureTableViewController.swift
//  HomeFurnitureDataPersistance
//
//  Created by Jon Salkin on 7/9/23.
//
/*
 This file defines the `FurnitureTableViewController` class, which is a subclass of `UITableViewController`.
 It acts as the table view controller responsible for displaying the furniture data.

 The properties and methods defined in the `FurnitureTableViewController` class include:

 - `PropertyKeys`: A struct that defines a property for the table view cell reuse identifier.

 - `rooms`: An array of `Room` objects representing the rooms and associated furniture.
 The initial value is set to a predefined array of sample rooms.
 The `didSet` property observer is used to save the updated room data to disk whenever the `rooms` array is modified.

 - `viewDidLoad()`: This method is called when the view controller's view is loaded.
 It checks if there is any saved room data available and loads it if present.
 Otherwise, it initializes the `rooms` array with the sample rooms.

 - `viewWillDisappear(_:)`: This method is called when the view controller's view is about to disappear.
 It saves the current room data to disk.

 - Table view data source methods: The table view data source methods are implemented to provide the necessary data for displaying the rooms and furniture in the table view.

 - `showFurnitureDetail(_:sender:)`: This IBAction method is triggered when a table view cell is selected.
 It retrieves the selected room and furniture, and prepares the `FurnitureDetailViewController` for presentation.

 Overall, the `FurnitureTableViewController` class handles the display and management of the furniture data in the table view, including loading and saving the data to disk.
 */

import UIKit

class FurnitureTableViewController: UITableViewController {
    
    
    struct PropertyKeys {
        static let furnitureCell = "FurnitureCell"
    }
    
    var rooms: [Room] = [
        Room(name: "Living Room",
             furniture: [Furniture(name: "Couch", description: "A comfy place to sit down."),
                         Furniture(name: "Television", description: "Entertainment for all to watch."),
                         Furniture(name: "Coffee Table", description: "A great place to set down your drink.")]),
        Room(name: "Kitchen",
             furniture: [Furniture(name: "Stove", description: "Warm and cook your food here."),
                         Furniture(name: "Oven", description: "Bake a delicious treat for your friends."),
                         Furniture(name: "Sink", description: "Don't forget to clean the dishes!")]),
        Room(name: "Bedroom",
             furniture: [Furniture(name: "Bed", description: "A place to sleep during the night."),
                         Furniture(name: "Desk", description: "Study to keep your mind sharp."),
                         Furniture(name: "Closet", description: "Hang up your clothes to keep them unwrinkled.")])] {
                             didSet {
                                 Room.saveToFile(room: rooms)
                             }
                         }
    
    override func viewDidLoad() {
        if let savedRooms = Room.loadFromFile() {
            rooms = savedRooms
        } else {
            rooms = Room.sampleRooms
        }
    }
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            
            Room.saveToFile(room: rooms)
    }

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return rooms.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let room = rooms[section]
        return room.furniture.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.furnitureCell, for: indexPath)
        
        let room = rooms[indexPath.section]
        let furniture = room.furniture[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = furniture.name
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return rooms[0].name
        case 1:
            return rooms[1].name
        case 2:
            return rooms[2].name
        default:
            return "Oops!"
        }
    }
    
    @IBSegueAction func showFurnitureDetail(_ coder: NSCoder, sender: Any?) -> FurnitureDetailViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }
        
        let selectedRoom = rooms[indexPath.section]
        let selectedFurniture = selectedRoom.furniture[indexPath.row]
        
        return FurnitureDetailViewController(coder: coder, furniture: selectedFurniture)
    }

    
}
