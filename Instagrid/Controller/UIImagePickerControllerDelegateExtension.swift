//
//  UIImagePickerControllerDelegateExtension.swift
//  Instagrid
//
//  Created by Nathan on 04/03/2020.
//  Copyright © 2020 Nathan. All rights reserved.
//

import UIKit
extension InstagridViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    /// Change the image of the buttons by another one by adapting it without distorting it
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            currentButton?.setImage(image, for: .normal)
            currentButton?.imageView?.contentMode = .scaleAspectFill
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

