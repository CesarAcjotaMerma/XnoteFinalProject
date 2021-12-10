//
//  CreateAccountViewController.swift
//  Xnote
//
//  Created by Cesar Augusto Acjota Merma on 12/8/21.
//  Copyright © 2021 xnote. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    //@IBOutlet weak var btnCancel: UIButton!
    
    var user: [Usuario] = []
    var usuario : Usuario?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnRegister.layer.cornerRadius = 30.0
        //btnCancel.layer.cornerRadius = 35.0
    }
    
    @IBAction func btnRegisterTapped(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.emailTxt.text!, password: self.passwordTxt.text!, completion: { (user, error) in
            print("Intentando crear un usuario")
            if error != nil{
                let alerta = UIAlertController(title: "Creacion de Usuario", message: "Se creo el siguiente error al crear el usuario:\(String(describing: error))", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Aceptar", style: .default)
                alerta.addAction(btnOK)
                self.present(alerta,animated: true,completion: nil)
                
            }else{
                print("El usuario fue creado exitosamente")
                let nombre = self.nameTxt.text!
                let email = self.emailTxt.text!
                
                let usuario = ["nombre": nombre, "email" : email];
            Database.database().reference().child("usuarios").child(user!.user.uid).child("datos").setValue(usuario)
                
                let alerta = UIAlertController(title: "Creacion de Usuario", message: "Usuario: \(self.nameTxt.text!) se creo correctamente.", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: { (UIAlertAction) in
                    self.performSegue(withIdentifier: "registrousuariosegue", sender: nil)
                })
                alerta.addAction(btnOK)
                self.present(alerta,animated: true,completion: nil)
            }
        })
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
