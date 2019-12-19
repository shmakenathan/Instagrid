//
//  InstagridViewController.swift
//  Instagrid
//
//  Created by Nathan on 25/11/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import UIKit

class InstagridViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {

    @IBOutlet weak var bottomRightView: UIView!
    
    @IBOutlet weak var generalView: UIView!
    @IBOutlet weak var upRightView: UIView!
    
    
    @IBOutlet weak var bigView: UIView!
    

    @IBOutlet weak var selectLayout1: UIImageView!
    
    @IBOutlet weak var selectLayout2: UIImageView!
    
    @IBOutlet weak var selectLayout3: UIImageView!
    
    
    
    var currentButton : UIButton?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSwipe()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func insertImage(_ sender: UIButton) {
        currentButton = sender
        showActionSheet()
    }
    
    @IBAction func layout1ButtonClick(_ sender: Any) {
        self.upRightView.isHidden = true
        self.bottomRightView.isHidden = false
        self.selectLayout1.isHidden = false
        self.selectLayout2.isHidden = true
        self.selectLayout3.isHidden = true
    }
    
    @IBAction func layout2ButtonClick(_ sender: Any) {
        self.upRightView.isHidden = false
        self.bottomRightView.isHidden = true
        self.selectLayout1.isHidden = true
        self.selectLayout2.isHidden = false
        self.selectLayout3.isHidden = true
    }
    
    @IBAction func layout3ButtonClick(_ sender: UIButton) {
        self.bottomRightView.isHidden = false
        self.upRightView.isHidden = false
        self.selectLayout1.isHidden = true
        self.selectLayout2.isHidden = true
        self.selectLayout3.isHidden = false
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func camera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        } else {
            print("")
        }
    }
    
    func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            currentButton!.setImage(image, for: .normal)
            //ne deforme pas l'image et s'adapte à l'espace
            currentButton!.imageView?.contentMode = .scaleAspectFill
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    func initializeSwipe(){
    let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeShare(_:)))
    let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeShare(_:)))
        
    leftSwipe.direction = .left
    upSwipe.direction = .up

    view.addGestureRecognizer(leftSwipe)
    view.addGestureRecognizer(upSwipe)
    }
   
     
     @IBAction func swipeShare(_ gesture: UISwipeGestureRecognizer) {
        if UIDevice.current.orientation.isLandscape {
            
                if (gesture.direction == .left){
                    shareTapped(im: bigView.asImage())
                  }
        }else{
        if (gesture.direction == .up){
            shareTapped(im: bigView.asImage())
            }
        }
        }
        
     
     
     
    @objc func shareTapped(im : UIImage) {
        let vc = UIActivityViewController(activityItems: [im], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds:bounds)
        return renderer.image { rendererContext in layer.render(in: rendererContext.cgContext)}
    }
    
}
