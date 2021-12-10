//
//  CreateNotasViewController.swift
//  Xnote
//
//  Created by Cesar Augusto Acjota Merma on 12/8/21.
//  Copyright © 2021 xnote. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseFirestore

class CreateNotasViewController: UIViewController {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var noteField: UITextView!
    
    var usuarioId = (Auth.auth().currentUser!.uid)
    var categorias:[Categoria] = []
    
    public var completion: ((String, String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Guardar", style: .done, target: self, action: #selector(didTapSave))

        // Do any additional setup after loading the view.
    }
    
    func alert(title:String, message:String){
         let alertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
         let ok:UIAlertAction = UIAlertAction(title: "VER", style: .default, handler: { (UIAlertAction) in
             self.performSegue(withIdentifier: "listaTareas", sender: nil)})
             
         alertController.addAction(ok)
         self.present(alertController, animated: true, completion: nil)
     }
    
    func limpiarCampos() {
        let title = titleField
        let nota = noteField
        title?.text = ""
        nota?.text = ""
    }
    
    @objc func didTapSave() {
        if let text = titleField.text, !text.isEmpty, !noteField.text.isEmpty {
            
            let titulo = titleField.text
            let tarea = noteField.text
            let nota = ["titulo": titulo, "tarea" : tarea]
        Database.database().reference().child("usuarios").child(self.usuarioId).child("tareas").childByAutoId().setValue(nota)
            //Database.database().reference().child("usuarios").child(self.usuarioId).child("categorias").child("categoria").childByAutoId().setValue(categoria)
            
            completion?(text, noteField.text)
            
            let alerta = UIAlertController(title: "Tarea creada correctamente", message: "Se ha creado correctemente la tarea", preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "OK", style: .default, handler: {(UIAlertAction) in
                self.limpiarCampos()
            })
            let btnCrear = UIAlertAction(title: "VER", style: .default, handler: { (UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
              })
            alerta.addAction(btnOK)
            alerta.addAction(btnCrear)
            self.present(alerta,animated: true,completion: nil)

            
            //self.alert(title: "Tarea creada correctamente", message: "Se ha creado correctemente la tarea")
        }
    }

}
