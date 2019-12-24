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
    var sommeChangeColor = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSwipe()
    }
    
    @IBAction func insertImage(_ sender: UIButton) {
        currentButton = sender
        showActionSheet()
    }
    
    @IBAction func layout1ButtonClick(_ sender: UIButton) {
        self.upRightView.isHidden = true
        self.bottomRightView.isHidden = false
        self.selectLayout1.isHidden = false
        self.selectLayout2.isHidden = true
        self.selectLayout3.isHidden = true
    }
    
    @IBAction func layout2ButtonClick(_ sender: UIButton) {
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
    
    // Change l'image du boutons par une autre en l'adaptant sans la deformer
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            currentButton!.setImage(image, for: .normal)
            currentButton!.imageView?.contentMode = .scaleAspectFill
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Fonction Bonus pour changer la couleur des bordures de l'image a partager selon un tableau de 5 couleurs
    @IBAction func changeBorder(_ gesture: UISwipeGestureRecognizer){
        let tabColor : [UIColor] = [UIColor.red,UIColor.black,UIColor.purple,UIColor.green,UIColor(red: 23/255, green: 101/255, blue: 156/255, alpha: 1)]
        if (gesture.direction == .right){
            if sommeChangeColor >= 5 {
                sommeChangeColor = 0
            }
            bigView.backgroundColor = tabColor[sommeChangeColor]
            sommeChangeColor = sommeChangeColor + 1
          }
    }
    
    // Permet de gerer les Swipe dans l'application
    func initializeSwipe(){
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeShare(_:)))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeShare(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(changeBorder(_:)))
            
        leftSwipe.direction = .left
        upSwipe.direction = .up
        rightSwipe.direction = .right

        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
   
     // Partager l'image avec l'animation de sortie d'ecran selon l'orientation paysage ou portrait
     @IBAction func swipeShare(_ gesture: UISwipeGestureRecognizer) {
            if UIDevice.current.orientation.isLandscape {
                if (gesture.direction == .left){
                    UIView.animate(withDuration: 1) {
                        self.bigView.transform = CGAffineTransform(translationX: -200, y: 0)
                        self.bigView.alpha = 0
                    }
                    shareTapped(im: bigView.asImage())
                }
            }else{
                if UIDevice.current.orientation.isPortrait {
                    if (gesture.direction == .up){
                        UIView.animate(withDuration: 1){
                            self.bigView.transform = CGAffineTransform(translationX: 0, y: -200)
                            self.bigView.alpha = 0
                        }
                        shareTapped(im: bigView.asImage())
                    }
                }
            }
        }
    
    // Fonction permettant de partage une image
    @objc func shareTapped(im : UIImage) {
        let vc = UIActivityViewController(activityItems: [im], applicationActivities: [])
        present(vc, animated: true)
        vc.completionWithItemsHandler = {  activity, success, items, error in
            UIView.animate(withDuration: 0.5, animations: {
                self.bigView.transform = .identity
                self.bigView.alpha = 1
            }, completion: nil)
        }
    }
    
    

}
//Permet de convertir une vue en Image
extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds:bounds)
        return renderer.image { rendererContext in layer.render(in: rendererContext.cgContext)}
    }
}
