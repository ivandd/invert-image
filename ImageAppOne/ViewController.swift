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
    
    @IBOutlet weak var rotateImageButton: UIBarButtonItem!
    
    @IBOutlet weak var saveNewImageButton: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()
    
    // Create place to render
    let context = CIContext(options: nil)
    
    var rotations: CGFloat = 0.0
    var imageSize = CGSize (width: 0,height: 0)
    var imageOrientation: UIImageOrientation = UIImageOrientation(rawValue: 0)!
    
    @IBAction func openImage(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func rotateImage(sender: AnyObject) {
        rotations += 90.0
        let rotate = CGAffineTransformMakeRotation((rotations * CGFloat(M_PI)) / 180.0)
        var scale = CGAffineTransformMakeScale(1, 1)
        if rotations % 180 > 0 {
            switch imageOrientation {
            case .Up:
                scale = CGAffineTransformMakeScale(imageSize.width/imageSize.height, imageSize.width/imageSize.height)
            case .Down:
                scale = CGAffineTransformMakeScale(imageSize.width/imageSize.height, imageSize.width/imageSize.height)
            default:
                if (imageSize.height > imageSize.width) {
                    scale = CGAffineTransformMakeScale(imageSize.height/imageSize.width, imageSize.height/imageSize.width)
                } else {
                    scale = CGAffineTransformMakeScale(imageSize.width/imageSize.height, imageSize.width/imageSize.height)
                }
                print ("Image not UP upon rotation")
            }
        }
        imageView.transform = CGAffineTransformConcat(rotate, scale)
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
        saveNewImageButton.enabled = false
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
        imageSize = chosenImage.size
        
        imageOrientation = chosenImage.imageOrientation
        imageView.transform = CGAffineTransformMakeScale(1, 1)
        
        switch chosenImage.imageOrientation {
        case .Up:
            print("Up")
        case .Down:
            print("Down")
        case .Left:
            print("Left")
        case .Right:
            print("Right")
        case .UpMirrored:
            print("UpMirrored")
        case .DownMirrored:
            print("DownMirrored")
        case .LeftMirrored:
            print("LeftMirrored")
        case .RightMirrored:
            print("RightMirrored")
        default:
            print("Unknown orientation")
        }
        
        imageView.contentMode = .ScaleAspectFit //3
        imageView.image = chosenImage //4
        print ("Picked an image")
        dismissViewControllerAnimated(true, completion: nil) //5
        invertImage()
        print ("Inverted the image")
        saveNewImageButton.enabled = true
        rotateImageButton.enabled = true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    

}

