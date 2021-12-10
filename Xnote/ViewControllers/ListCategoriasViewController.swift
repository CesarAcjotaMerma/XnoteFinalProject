//
//  ListCategoriasViewController.swift
//  Xnote
//
//  Created by Cesar Augusto Acjota Merma on 12/9/21.
//  Copyright © 2021 xnote. All rights reserved.
//

import UIKit
import Firebase

class ListCategoriasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewCategorias: UITableView!
    
    var categorias:[Categoria] = []
    //var categoria : Categoria?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewCategorias.delegate = self
        tableViewCategorias.dataSource = self
        self.tableViewCategorias.reloadData()
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("categorias").observe(DataEventType.childAdded, with: {(snapshot) in
        //print(snapshot)
        
        let categoria = Categoria()
        
        categoria.name = (snapshot.value as! NSDictionary)["nombre"] as! String
        categoria.descript = (snapshot.value as! NSDictionary)["descripcion"] as! String
        categoria.id = snapshot.key
        
        self.categorias.append(categoria)
        self.tableViewCategorias.reloadData()
        
        })
        //self.tableViewCategorias.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categorias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categorias[indexPath.row].name
        cell.detailTextLabel?.text = categorias[indexPath.row].descript
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tableViewCategorias.reloadData()
        if editingStyle == .delete {
            let categoria = categorias[indexPath.row]
           
            self.categorias.remove(at: indexPath.row)
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("categorias").child(categoria.id).removeValue()
            
            self.tableViewCategorias.reloadData()
        }
        self.tableViewCategorias.reloadData()
    }

}
