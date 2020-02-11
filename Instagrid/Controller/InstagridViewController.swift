//
//  InstagridViewController.swift
//  Instagrid
//
//  Created by Nathan on 25/11/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import UIKit

class InstagridViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var generalView: UIView!
    @IBOutlet weak var gridContainerView: UIView!
    @IBOutlet var layoutSelectionImageViews: [UIImageView]!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var botStackView: UIStackView!
    private var currentButton: UIButton?
    var sommeChangeColor = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSwipe()
        selectLayoutWith(tag: 2)
    }
    @objc private func insertImage(_ sender: UIButton) {
        currentButton = sender
        showActionSheet()
    }
    @IBAction func layoutButtonClick(_ sender: UIButton) {
        selectLayoutWith(tag: sender.tag)
    }
    private func selectLayoutWith(tag: Int) {
        selectLayoutImageViewAccordingTo(tag: tag)
        let layout = Layout.layouts[tag - 1]
        generate(layout: layout)
    }
    //
    private func generate(layout: Layout) {
        addButtons(in: topStackView, amount: layout.top)
        addButtons(in: botStackView, amount: layout.bot)
    }
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
    private func clear(stackView: UIStackView) {
        for arrangedSubbviews in stackView.arrangedSubviews {
            arrangedSubbviews.removeFromSuperview()
        }
    }
    // appelle la fonction resetLayoutButtonVisibility puis en fonction du tag du bouton
    // appuyer rend visible une seul image "validé"
    private func selectLayoutImageViewAccordingTo(tag: Int) {
        resetLayoutButtonVisibility()
        let layoutSelectionImageViewToSelect = layoutSelectionImageViews[tag - 1]
        layoutSelectionImageViewToSelect.isHidden = false
    }
    // Cache la totlaité des images "validé" en mettant leurs propriétés a True
    private func resetLayoutButtonVisibility() {
        for layoutSelectionImageView in layoutSelectionImageViews {
            layoutSelectionImageView.isHidden = true
        }
    }
    private func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // Resolve bug which display a console warning message about breaking constraints
        actionSheet.pruneNegativeWidthConstraints()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default,
                                                handler: { (_: UIAlertAction!) -> Void in
                self.camera()
            }))}
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default,
                                                handler: { (_: UIAlertAction!) -> Void in
                self.photoLibrary()
            }))}
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    private func camera() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .camera
        self.present(myPickerController, animated: true, completion: nil)
    }
    private func photoLibrary() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    // Change l'image du boutons par une autre en l'adaptant sans la deformer
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            currentButton?.setImage(image, for: .normal)
            currentButton?.imageView?.contentMode = .scaleAspectFill
        }
        picker.dismiss(animated: true, completion: nil)
    }
    // Fonction Bonus pour changer la couleur des bordures de l'image a partager selon un tableau de 5 couleurs
    @IBAction func changeBorder(_ gesture: UISwipeGestureRecognizer) {
        let tabColor: [UIColor] =
            [UIColor.red, UIColor.black, UIColor.purple, UIColor.green,
             UIColor(red: 23/255, green: 101/255, blue: 156/255, alpha: 1)]
        if gesture.direction == .right {
            if sommeChangeColor >= 5 {
                sommeChangeColor = 0
            }
            gridContainerView.backgroundColor = tabColor[sommeChangeColor]
            sommeChangeColor += 1
        }
    }
    // Permet de gerer les Swipe dans l'application
    private func initializeSwipe() {
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
        let image: UIImage = gridContainerView.asImage()
        if UIDevice.current.orientation.isLandscape {
            if gesture.direction == .left {
                UIView.animate(withDuration: 1) {
                    self.gridContainerView.transform = CGAffineTransform(translationX: -200, y: 0)
                    self.gridContainerView.alpha = 0
                }
                self.shareTapped(image: image)
            }
        } else {
            if UIDevice.current.orientation.isPortrait {
                if gesture.direction == .up {
                    UIView.animate(withDuration: 1) {
                        self.gridContainerView.transform = CGAffineTransform(translationX: 0, y: -200)
                        self.gridContainerView.alpha = 0
                    }
                    self.shareTapped(image: image)
                }
            }
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
}
//Permet de convertir une vue en Image
extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in layer.render(in: rendererContext.cgContext)}
    }
}
