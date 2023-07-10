//
//  Room.swift
//  HomeFurnitureDataPersistance
//
//  Created by Jon Salkin on 7/9/23.
//
/*
 This file defines the `Room` class, which represents a room containing furniture objects.

 The `Room` class conforms to the `Codable` protocol, allowing instances of the class to be encoded and decoded to and from a property list format.

 The properties of the `Room` class include:

 - `name`: A `String` representing the name of the room.
 - `furniture`: An array of `Furniture` objects representing the furniture in the room.

 The `Room` class also has an initializer that allows you to initialize a `Room` object with a name and an array of furniture objects.

 Additionally, the `Room` class includes static properties and methods for managing the persistence of room data.
 The `archiveURL` property defines the URL where the room data will be stored as a property list.
 The `sampleRooms` property provides a set of sample rooms for testing purposes.
 The `saveToFile(room:)` method is used to encode and save room data to the specified archive URL,
 and the `loadFromFile()` method is used to load and decode room data from the archive URL.

 Overall, the `Room` class provides a way to represent rooms with associated furniture objects and offers methods for persisting and retrieving room data.
 */

import Foundation

class Room: Codable {
    let name: String
    let furniture: [Furniture]
    
    init(name: String, furniture: [Furniture]) {
        self.name = name
        self.furniture = furniture
    }
    
    static var archiveURL: URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsURL.appendingPathComponent("rooms").appendingPathExtension("plist")
        
        return archiveURL
    }
    
    static var sampleRooms: [Room] {
        return [
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
                             Furniture(name: "Closet", description: "Hang up your clothes to keep them unwrinkled.")])
        ]
    }
    
    static func saveToFile(room: [Room]) {
        let encoder = PropertyListEncoder()
        do {
            let encodedRooms = try encoder.encode(room)
            try encodedRooms.write(to: Room.archiveURL)
        } catch {
            print("Error encoding rooms: \(error)")
        }
    }
    
    static func loadFromFile() -> [Room]? {
        guard let roomData = try? Data(contentsOf: Room.archiveURL) else {
            return nil
        }
        
        do {
            let decoder = PropertyListDecoder()
            let decodedRooms = try decoder.decode([Room].self, from: roomData)
            
            return decodedRooms
        } catch {
            print("Error decoding rooms: \(error)")
            return nil
        }
    }
    
}
