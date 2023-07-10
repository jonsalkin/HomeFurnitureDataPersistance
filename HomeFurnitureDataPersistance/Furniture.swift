//
//  Furniture.swift
//  HomeFurnitureDataPersistance
//
//  Created by Jon Salkin on 7/9/23.
//
/*
 Defines the `Furniture` class, which represents a piece of furniture with a name, description, and optional image data.

 The `Furniture` class conforms to the `Codable` protocol, allowing instances of the class to be encoded and decoded to and from a property list format.

 The properties of the `Furniture` class include:

 - `name`: A `String` representing the name of the furniture.
 - `description`: A `String` describing the furniture.
 - `imageData`: An optional `Data` object that stores the image data of the furniture.

 The `Furniture` class also has an initializer that allows you to initialize a `Furniture` object with a name, description, and optional image data.

 Overall, the `Furniture` class provides a basic model for representing furniture objects in your app.
 
 */


import Foundation

class Furniture: Codable {
    let name: String
    let description: String
    var imageData: Data?
    
    init(name: String, description: String, imageData: Data? = nil) {
        self.name = name
        self.description = description
        self.imageData = imageData
    }

}
