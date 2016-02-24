//
//  ViewController.swift
//  Invert Image
//
//  Created by Ivan Davchev on 2/23/16.
//  Copyright © 2016 Ivan Davchev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    // @IBOutlet weak var imageViewControllerz: UIImageView!
    
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
        
        if (imageView.image != nil) {
            UIImageWriteToSavedPhotosAlbum(
                imageView.image!,
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
        let inputImage = CIImage(image: imageView.image!)
        let filteredImage = inputImage!.imageByApplyingFilter("CIColorInvert", withInputParameters: nil)
        let renderedImage = context.createCGImage(filteredImage, fromRect: filteredImage.extent)
        imageView.image = UIImage(CGImage: renderedImage)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        
/*        // reset the imageview to size of image
        let rect = CGRect(
            origin: CGPoint(x: 0, y: 0),
            size: chosenImage.size
        )
        imageView.bounds = rect
*/
        imageView.contentMode = .ScaleAspectFit //3
        imageView.image = chosenImage //4
        print ("Picked an image")
        dismissViewControllerAnimated(true, completion: nil) //5
        invertImage()
        print ("Inverted the image")
        saveNewImageButton.enabled = true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    

}

