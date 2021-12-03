//
//  NameViewController.swift
//  Xnote
//
//  Created by Cesar Augusto Acjota Merma on 12/2/21.
//  Copyright © 2021 xnote. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {
    
    //@IBOutlet weak var noteTitle: UITextField!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var btnFinalizar: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnFinalizar.layer.cornerRadius = 30.0

        // Do any additional setup after loading the view.
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
