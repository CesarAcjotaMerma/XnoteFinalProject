//
//  ViewController.swift
//  Xnote
//
//  Created by Cesar Augusto Acjota Merma on 12/1/21.
//  Copyright © 2021 xnote. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btnComenzar: UIButton!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        btnComenzar.layer.cornerRadius = 30.0
    }
    
    @IBAction func btnTappedComenzar(_ sender: Any) {
        performSegue(withIdentifier: "comenzarSegue", sender: nil)
    }
    
}

