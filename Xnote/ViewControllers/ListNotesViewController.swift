//
//  ListNotesViewController.swift
//  Xnote
//
//  Created by Cesar Augusto Acjota Merma on 12/7/21.
//  Copyright © 2021 xnote. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ListNotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //var tareas:[(title: String, note: String)] = []
    
    var tareasListing: Categoria?
    
    var tareas:[Tarea] = []
    
    //private let listNotesViewController = ListNotesViewController()
    
    @IBOutlet weak var tableTareas: UITableView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableTareas.delegate = self
        tableTareas.dataSource = self
        title = "Tareas"
        
        self.tableTareas.reloadData()
    Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("tareas").observe(DataEventType.childAdded, with: {(snapshot) in
           print(snapshot)
       
           let tarea = Tarea()
           
           tarea.notaTitulo = (snapshot.value as! NSDictionary)["titulo"] as! String
           tarea.text = (snapshot.value as! NSDictionary)["tarea"] as! String
           tarea.id = snapshot.key
           
           self.tareas.append(tarea)
           
           self.tableTareas.reloadData()
           
           })
            
    }
    
    @IBAction func didTapNewNote(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? CreateNotasViewController else {
            return
        }
        vc.title = "Nueva Nota"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { noteTitle, note in
            //self.navigationController?.popViewController(animated: true)
            self.tableTareas.reloadData()
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("tareas").observe(DataEventType.childAdded, with: {(snapshot) in
               // print(snapshot)
            
            let tarea = Tarea()
            
            tarea.notaTitulo = (snapshot.value as! NSDictionary)["titulo"] as! String
            tarea.text = (snapshot.value as! NSDictionary)["tarea"] as! String
            tarea.id = snapshot.key
            
            self.tareas.append(tarea)
            
            self.tableTareas.reloadData()
            })
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tareas.count > 0 {
            label.isHidden = true
            tableView.isHidden = false
        }else{
            label.isHidden = false
            tableView.isHidden = true
            return tareas.count
        }
        return tareas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tareas[indexPath.row].notaTitulo
        cell.detailTextLabel?.text = tareas[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tarea = tareas[indexPath.row]
            self.tareas.remove(at: indexPath.row)
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("tareas").child(tarea.id).removeValue()
            self.tableTareas.reloadData()
        }
        self.tableTareas.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tarea = tareas[indexPath.row]
        performSegue(withIdentifier: "vertarea", sender: tarea)
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        //show notes controllers
//
//        let tarea = tareas[indexPath.row]
//
//        guard let vc = storyboard?.instantiateViewController(identifier: "note") as? NotasViewController else {
//            return
//        }
//        vc.navigationItem.largeTitleDisplayMode = .never
//        vc.title = "Detalles de la Tarea"
//        vc.noteTitle = tarea.notaTitulo
//        vc.note = tarea.text
//        navigationController?.pushViewController(vc,animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "vertarea" {
            let siguienteVC = segue.destination as! NotasViewController
            siguienteVC.tarea = sender as! Tarea
        }
    }
    
}
