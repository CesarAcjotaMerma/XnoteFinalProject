//
//  AuthEmailViewController.swift
//  Xnote
//
//  Created by Cesar Augusto Acjota Merma on 12/8/21.
//  Copyright © 2021 xnote. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AuthEmailViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Design
        signUpButton.layer.cornerRadius = 30.0
        logInButton.layer.cornerRadius = 30.0
        
        //Analitycs Event
        title = "Autenticacion"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //authStackView.isHidden = false
    }
    
    @IBAction func iniciarSessionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){ (user, error) in
               print("Intentando Iniciar Sesion")
               if error != nil{
                   let alerta = UIAlertController(title: "Error al Iniciar Sesion", message: "Usuario: \(self.emailTextField.text!) No esta registrado.", preferredStyle: .alert)
                   let btnOK = UIAlertAction(title: "Cancelar", style: .default)
                   let btnCrear = UIAlertAction(title: "Crear", style: .default, handler: { (UIAlertAction) in
                       self.performSegue(withIdentifier: "registrousuario", sender: nil)
                   })
                   alerta.addAction(btnOK)
                   alerta.addAction(btnCrear)
                   self.present(alerta,animated: true,completion: nil)
               }else{
                   print("Inico de Sesion Exitoso")
                   self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
               }
        }
    
    }
}
