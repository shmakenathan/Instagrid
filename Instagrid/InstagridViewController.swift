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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func layout3ButtonClick(_ sender: UIButton) {
        self.bottomRightView.isHidden = false
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
