//
//  InstagridViewController.swift
//  Instagrid
//
//  Created by Nathan on 25/11/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import UIKit

class InstagridViewController: UIViewController {

    @IBOutlet weak var bottomRightView: UIView!
    
    @IBOutlet weak var upRightView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var selectLayout1: UIImageView!
    
    @IBOutlet weak var selectLayout2: UIImageView!
    
    @IBOutlet weak var selectLayout3: UIImageView!
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func swipeUp(_ sender: Any) {
        
        shareTapped()
        
        
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
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: [])
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
