//
//  AuthViewController.swift
//  Xnote
//
//  Created by Cesar Augusto Acjota Merma on 12/2/21.
//  Copyright © 2021 xnote. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnOmitir: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        btnGoogle.layer.cornerRadius = 30.0
        btnOmitir.layer.cornerRadius = 30.0
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
