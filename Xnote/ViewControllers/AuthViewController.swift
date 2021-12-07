//
//  AuthViewController.swift
//  Xnote
//
//  Created by Cesar Augusto Acjota Merma on 12/2/21.
//  Copyright © 2021 xnote. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class AuthViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var btnGoogle: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        btnGoogle.layer.cornerRadius = 30.0
        
        //Google auth
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
    }
    
    @IBAction func googleButtonTapped(_ sender: Any){
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    
    func alert(title:String, message:String){
        let alertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok:UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.performSegue(withIdentifier: "loginGoogle", sender: nil)})
            
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            return
        }
        
        guard let auth = user.authentication else{ return }
        
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        
        Auth.auth().signIn(with: credentials) { (result, error) in
            
            if error != nil {
                self.alert(title: "Fallo en login", message: "Por favor intente nuevamente mas tarde")
            }else{
                self.alert(title: "Login Exitoso", message: "Login successsfull complete")
                self.performSegue(withIdentifier: "loginGoogle", sender: nil)
            }
        }
    }
    
    
//    private func showHome(result: AuthDataResult?, error: Error?){
//        if let result = result, error == nil {
//            self.navigationController?.pushViewController(HomeViewController(), animated: true)
//        } else {
//            let alertController = UIAlertController(title: "Error", message: "Se ha producido un error al realizar la Autenticacion", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
//            self.present(alertController, animated: true, completion: nil)
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//
//extension AuthViewController: GIDSignInDelegate {
//    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if error != nil && user.authentication != nil {
//            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
//            
//            Auth.auth().signIn(with: credential) { (result, error) in
//                self.showHome(result: result, error: error)
//            }
//        }
//    }
//    
//}
