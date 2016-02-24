//
//  ViewController.swift
//  Invert Image
//
//  Created by Ivan Davchev on 2/23/16.
//  Copyright © 2016 Ivan Davchev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    // @IBOutlet weak var imageViewControllerz: UIImageView!
    
    @IBOutlet weak var saveNewImageButton: UIBarButtonItem!
    
    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var scrollViewTop: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    
    var lastZoomScale: CGFloat = -1
    
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
        // imageView.contentMode = .ScaleAspectFit //3
        imageView.image = chosenImage //4
        print ("Picked an image")
        dismissViewControllerAnimated(true, completion: nil) //5
        invertImage()
        print ("Inverted the image")
        saveNewImageButton.enabled = true
    }

    
    func updateConstraints() {
        if let image = imageView.image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            
            let viewWidth = scrollView.bounds.size.width
            let viewHeight = scrollView.bounds.size.height

            print ("scrollViewTop = \(scrollViewTop.constant)")
            print ("scrollViewBottom = \(scrollViewBottom.constant)")
            
            // center image if it is smaller than the scroll view
            var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
            if hPadding < 0 { hPadding = 0 }
            print ("hPadding = \(hPadding)")
            
            var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
            if vPadding < 0 { vPadding = 0 }
            print ("vPadding = \(vPadding)")
            
            imageConstraintLeft.constant = hPadding
            imageConstraintRight.constant = hPadding
            
            print ("scrollViewTop = \(scrollViewTop.constant)")
            print ("scrollViewBottom = \(scrollViewBottom.constant)")
            
            imageConstraintTop.constant = vPadding
            imageConstraintBottom.constant = vPadding

            view.layoutIfNeeded()
        
            print ("Updated image constraints")
        }
    }
    
    // Zoom to show as much image as possible unless image is smaller than the scroll view
    private func updateZoom() {
        if let image = imageView.image {
            print (scrollView.bounds.size.width)
            print (image.size.width)
            print (scrollView.bounds.size.height)
            print (image.size.height)
            
            var minZoom = min(scrollView.bounds.size.width / image.size.width,
                scrollView.bounds.size.height / image.size.height)
            print ("minZoom = \(minZoom)")
            
            if minZoom > 1 { minZoom = 1 }
            
            scrollView.minimumZoomScale = minZoom
            
            // Force scrollViewDidZoom fire if zoom did not change
            if minZoom == lastZoomScale { minZoom += 0.000001 }
            print ("minZoom = \(minZoom)")
            
            minZoom = 1
            
            scrollView.zoomScale = minZoom
            lastZoomScale = minZoom
            print ("Updated zoom to \(minZoom)")
        }
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // imageView.image = UIImage(named: imageScrollLargeImageName)
        scrollView.delegate = self
        updateZoom()
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraints()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}

