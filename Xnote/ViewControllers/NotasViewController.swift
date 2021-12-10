//
//  NotasViewController.swift
//  Xnote
//
//  Created by Cesar Augusto Acjota Merma on 12/8/21.
//  Copyright © 2021 xnote. All rights reserved.
//

import UIKit
import Firebase

class NotasViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var noteLabel: UITextView!
    
    public var noteTitle: String = ""
    public var note: String = ""
    
    var tarea = Tarea()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = tarea.notaTitulo
        noteLabel.text = tarea.text
//        print(tarea.notaTitulo)
//        print(tarea.text)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func eliminarTarea(_ sender: Any){
    Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("tareas").child(tarea.id).removeValue()
    }
    
    @IBAction func tappedPomodoro(_ sender: Any) {
        
//        let tareaID = tareas
//        performSegue(withIdentifier: "realizarTarea", sender: tareaID)
        
        guard let vc = storyboard?.instantiateViewController(identifier: "pomodoro") as? PomodoroViewController else {
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        //vc.title = "Detalles de la Tarea"
        vc.tituloTarea = tarea.notaTitulo
        vc.idTarea = tarea.id
        navigationController?.pushViewController(vc,animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "realizarTarea" {
//            let siguienteVC = segue.destination as! PomodoroViewController
//            siguienteVC.tarea = sender as! tarea
//        }
//    }
    
}
