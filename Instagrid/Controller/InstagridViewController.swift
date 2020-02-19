//
//  InstagridViewController.swift
//  Instagrid
//
//  Created by Nathan on 25/11/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import UIKit

class InstagridViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var generalView: UIView!
    @IBOutlet weak var gridContainerView: UIView!
    @IBOutlet var layoutSelectionImageViews: [UIImageView]!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var botStackView: UIStackView!
    
    // MARK: IBAction
    
    @IBAction func layoutButtonClick(_ sender: UIButton) {
        selectLayoutWith(tag: sender.tag)
    }
    
    //Bonus function to change the color of the borders of the image to be shared according to a table of 5 colors
    @IBAction func changeBorder(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            let indexColorModulo = gridFrameColorIndex % tabColor.count
            gridContainerView.backgroundColor = tabColor[indexColorModulo]
            gridFrameColorIndex += 1
        }
    }
    
    // Share the image with the screen output animation according to landscape or portrait orientation
    @IBAction func swipeShare(_ gesture: UISwipeGestureRecognizer) {
        let image: UIImage = gridContainerView.asImage()
        if UIDevice.current.orientation.isLandscape {
            if gesture.direction == .left {
                animateGridView(direction: .left)
                }
                self.shareTapped(image: image)
            
        } else {
            if UIDevice.current.orientation.isPortrait {
                if gesture.direction == .up {
                    animateGridView(direction: .up)
                    self.shareTapped(image: image)
                }
            }
        }
    }
    
    @objc private func insertImage(_ sender: UIButton) {
        currentButton = sender
        showActionSheet()
    }
    
    // MARK: Methods - Internal
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Change the image of the buttons by another one by adapting it without distorting it
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            currentButton?.setImage(image, for: .normal)
            currentButton?.imageView?.contentMode = .scaleAspectFill
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Properties - Private
    
    private let tabColor: [UIColor] = [.red, .black, .purple, .green, UIColor(red: 23/255, green: 101/255, blue: 156/255, alpha: 1)]
    private var currentButton: UIButton?
    private var gridFrameColorIndex = 0
    let swipeToShareGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeShare(_:)))
    
    
    
    // MARK: Methods - Private
    
    //Allows you to select a layout according to a predefined model
    private func selectLayoutWith(tag: Int) {
        selectLayoutImageViewAccordingTo(tag: tag)
        let layout = Layout.layouts[tag - 1]
        generate(layout: layout)
    }
    
    //add buttons in stack view
    private func generate(layout: Layout) {
        addButtons(in: topStackView, amount: layout.top)
        addButtons(in: botStackView, amount: layout.bot)
    }
    
    //ajoute des boutons en fonction du layout selectionne
    private func addButtons(in stackView: UIStackView, amount: Int) {
        clear(stackView: stackView)
        for _ in 1...amount {
            let buttonToAdd = UIButton()
            buttonToAdd.backgroundColor = .white
            let plusImage = UIImage(named: "Plus")
            buttonToAdd.setImage(plusImage, for: .normal)
            buttonToAdd.addTarget(self, action: #selector(insertImage(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(buttonToAdd)
        }
    }
    
    //allows to empty the stackview (loss of the selected image)
    private func clear(stackView: UIStackView) {
        for arrangedSubbviews in stackView.arrangedSubviews {
            arrangedSubbviews.removeFromSuperview()
        }
    }
    
    // Calls the resetLayoutButtonVisibility function then, depending on the tag of the button pressed, makes a single "validated" image visible
    private func selectLayoutImageViewAccordingTo(tag: Int) {
        resetLayoutButtonVisibility()
        let layoutSelectionImageViewToSelect = layoutSelectionImageViews[tag - 1]
        layoutSelectionImageViewToSelect.isHidden = false
    }
    
    // Hide all "validated" images by setting their properties to True
    private func resetLayoutButtonVisibility() {
        for layoutSelectionImageView in layoutSelectionImageViews {
            layoutSelectionImageView.isHidden = true
        }
    }
   
    //Displays the sheet to select an action
    private func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // Resolves bug which display a console warning message about breaking constraints
        actionSheet.pruneNegativeWidthConstraints()
        
        addPhotoAction(to: actionSheet, with: .camera)
        addPhotoAction(to: actionSheet, with: .photoLibrary)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // Add an action (Gallery or Camera)
    private func addPhotoAction(to actionSheet: UIAlertController, with sourceType: UIImagePickerController.SourceType) {
        guard sourceType != .savedPhotosAlbum else { return }
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            /////////////////////////////////////////////////////////////
            let title = sourceType == .camera ? "Camera" : "Gallery"
            let alertAction = UIAlertAction(title: title, style: .default, handler: { _ in self.presentImagePickerController(with: sourceType)
            })
            actionSheet.addAction(alertAction)
        }
    }
    
    private func presentImagePickerController(with sourceType: UIImagePickerController.SourceType) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = sourceType
        self.present(myPickerController, animated: true, completion: nil)
    }

    

    //
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            
            if UIDevice.current.orientation.isLandscape {
                self.shareLabel.text = "Swipe left to share"
                self.swipeToShareGestureRecognizer.direction = .left
            }else{
                self.shareLabel.text = "Swipe up to share"
            }
        }
    }
    
    // Permet de gerer les Swipe dans l'application
    private func initializeSwipe() {
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeShare(_:)))
        let swipeToChangeFrameColorGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(changeBorder(_:)))
        //swipeToShareGestureRecognizer.direction = .left
        upSwipe.direction = .up
        swipeToChangeFrameColorGestureRecognizer.direction = .right
        //view.addGestureRecognizer(swipeToShareGestureRecognizer)
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(swipeToChangeFrameColorGestureRecognizer)
    }
    
    private func animateGridView(direction: UISwipeGestureRecognizer.Direction) {
        let xTranslation: CGFloat = direction == .up ? 0 : -200
        let yTranslation: CGFloat = direction == .up ? -200 : 0
        
        UIView.animate(withDuration: 1) {
            self.gridContainerView.transform = CGAffineTransform(translationX: xTranslation, y: yTranslation)
            self.gridContainerView.alpha = 0
        }
    }
    
    private func shareTapped(image: UIImage) {
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(share, animated: true, completion: nil)
        // Permet de faire l'animation inverse à la fermeture de la fenêtre de partage
        share.completionWithItemsHandler = {  activity, success, items, error in
            UIView.animate(withDuration: 0.5, animations: {
                self.gridContainerView.transform = .identity
                self.gridContainerView.alpha = 1
            }, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSwipe()
        selectLayoutWith(tag: 2)
    }
}

//Permet de convertir une vue en Image
extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in layer.render(in: rendererContext.cgContext)}
    }
}
