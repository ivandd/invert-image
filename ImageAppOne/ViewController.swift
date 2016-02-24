//
//  ViewController.swift
//  ImageAppOne
//
//  Created by Ivan Davchev on 2/23/16.
//  Copyright © 2016 Ivan Davchev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageViewController: UIImageView!
    
    @IBOutlet weak var saveNewImageButton: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()
    
    // Create place to render
    let context = CIContext(options: nil)
    
    @IBAction func openImage(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveNewImage(sender: AnyObject) {
        let selectorAsString = "imageWasSavedSuccessfully:didFinishSavingWithError:context:"
        let selectorToCall = Selector(selectorAsString)
        
        if (imageViewController.image != nil) {
            UIImageWriteToSavedPhotosAlbum(
                imageViewController.image!,
                self,
                selectorToCall,
                nil)
        }
    }
    
    func imageWasSavedSuccessfully(image: UIImage,
        didFinishSavingWithError error: NSError!,
        context: UnsafeMutablePointer<()>) {
            
        if let theError = error {
            print("An error happened while saving the image = \(theError)")
        } else {
            print("Image was saved successfully")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func invertImage() {
        let inputImage = CIImage(image: imageViewController.image!)
        let filteredImage = inputImage!.imageByApplyingFilter("CIColorInvert", withInputParameters: nil)
        let renderedImage = context.createCGImage(filteredImage, fromRect: filteredImage.extent)
        imageViewController.image = UIImage(CGImage: renderedImage)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imageViewController.contentMode = .ScaleAspectFit //3
        imageViewController.image = chosenImage //4
        dismissViewControllerAnimated(true, completion: nil) //5
        invertImage()
        saveNewImageButton.enabled = true
    }

}

