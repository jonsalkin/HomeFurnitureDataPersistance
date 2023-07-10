//
//  FurnitureDetailViewController.swift
//  HomeFurnitureDataPersistance
//
//  Created by Jon Salkin on 7/9/23.
//
/*
 This file defines the `FurnitureDetailViewController` class, which is a subclass of `UIViewController`.
 It is responsible for displaying the details of a specific furniture item and allowing the user to choose a photo, perform actions, and share the furniture information.

 The properties and methods defined in the `FurnitureDetailViewController` class include:

 - `rooms`: An array of `Room` objects representing the rooms and associated furniture.
 The `didSet` property observer is used to save the updated room data to disk whenever the `rooms` array is modified.

 - `furniture`: An optional `Furniture` object representing the selected furniture item.

 - Outlets: `photoImageView`, `choosePhotoButton`, `furnitureTitleLabel`, and `furnitureDescriptionLabel`
 are outlets connected to the corresponding UI elements in the storyboard.

 - `init?(coder:furniture:)` and `required init?(coder:)`:
 These initializer methods handle the initialization of the view controller.

 - `viewDidLoad()`: This method is called when the view controller's view is loaded.
 It updates the view with the furniture details.

 - `updateView()`: This method updates the view elements with the details of the furniture object.

 - `choosePhotoButtonTapped(_:)`: This IBAction method is triggered when the choose photo button is tapped.
 It presents an action sheet with options to take a photo or choose from the photo library.

 - `imagePickerController(_:didFinishPickingMediaWithInfo:)`: This method is called when the user selects or captures an image using the image picker.
 It sets the selected image as the furniture's image data and dismisses the image picker.

 - `imagePickerControllerDidCancel(_:)`: This method is called when the user cancels the image picker.
 It dismisses the image picker.

 - `actionButtonTapped(_:)`: This IBAction method is triggered when the action button is tapped.
 It creates an activity controller to share the furniture information, including the optional photo.

 Overall, the `FurnitureDetailViewController` class handles the display and interaction with the furniture details, including choosing a photo, performing actions, and sharing the furniture information.
 */

import UIKit
import MessageUI

class FurnitureDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var rooms: [Room] = [] {
        didSet {
            Room.saveToFile(room: rooms)
        }
    }
    
    var furniture: Furniture?
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var choosePhotoButton: UIButton!
    @IBOutlet var furnitureTitleLabel: UILabel!
    @IBOutlet var furnitureDescriptionLabel: UILabel!
    
    init?(coder: NSCoder, furniture: Furniture?) {
        self.furniture = furniture
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        
    }
    

    
    func updateView() {
        guard let furniture = furniture else {return}
        if let imageData = furniture.imageData,
            let image = UIImage(data: imageData) {
            photoImageView.image = image
        } else {
            photoImageView.image = nil
        }
        
        furnitureTitleLabel.text = furniture.name
        furnitureDescriptionLabel.text = furniture.description
    }
    
    @IBAction func choosePhotoButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Take Photo", style: .default, handler: { (_) in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        furniture?.imageData = selectedImage.jpegData(compressionQuality: 0.9)
        
        
        dismiss(animated: true) {
            self.updateView()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func actionButtonTapped(_ sender: Any) {
        guard let furniture = furniture else {
            return
        }
        
        var items: [Any] = ["\(furniture.name): \(furniture.description)"]
        if let image = photoImageView.image {
            items.append(image)
        }
        
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    
}
