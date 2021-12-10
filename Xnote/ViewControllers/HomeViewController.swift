//
//  HomeViewController.swift
//  Xnote
//
//  Created by Cesar Augusto Acjota Merma on 12/2/21.
//  Copyright © 2021 xnote. All rights reserved.
//

import UIKit
import SideMenu
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class HomeViewController: UIViewController, MenuControllerDelegate{

    private var sideMenu: SideMenuNavigationController?
    
    private let infoController = InfoViewController()
    private let settingController = SettingViewController()
    private let pomodoroController = PomodoroViewController()
    
    @IBOutlet weak var emailUser: UILabel!
    
    @IBOutlet weak var fraseBienvenida: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnAdCategoria: UIButton!
    
    var tareas:[Tarea] = []
    
    var listTareas: Tarea?
    var listCategorias: Categoria?
    
    var usuarios:[Usuario] = []
    
    var usuario = Usuario()
    
    var name = ""
    var descript = ""
    
    var usuarioId = (Auth.auth().currentUser!.uid)
    var usuarioName = (Auth.auth().currentUser!.displayName)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailUser.text = "HOLA,\(usuarioName ?? "Amig@")"
        fraseBienvenida.text = "Bienvenid@ a Xnote, disfruta de la App"
        
        let menu = MenuController(with:SideMenuItem.allCases)
        // side menu
        menu.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        //addChildControllers()
        
        //recepcion de datos del usuario
        //guard let auth = user.authentication else{ return }
        
    Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("datos").observe(DataEventType.childAdded, with: {(snapshot) in
        
        print(snapshot)
        
//        let usuario = Usuario()
//        usuario.nombre = (snapshot.value as! NSDictionary)["nombre"] as! String
//        usuario.email = (snapshot.value as! NSDictionary)["email"] as! String
//        self.usuarios.append(usuario)
        //self.collectionView.reloadData()

    })
        
        //Button Add Category
        btnAdCategoria.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        
    }
    
    // Add a new Category
    
    @objc private func showAlert() {
        let alert = UIAlertController(
            title: "Add new Category",
            message: "Pleace add New Category",
            preferredStyle: .alert)
        
        // Add 2 fields
        alert.addTextField(configurationHandler: { field in
            field.placeholder = "Name Category"
            field.returnKeyType = .next
            field.keyboardType = .default
        })
        
        alert.addTextField(configurationHandler: { field in
            field.placeholder = "Description"
            field.returnKeyType = .continue
            field.keyboardType = .default
        })
        
        //print("Click")
        
        //Add 2 buttons
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Agregar", style: .default, handler: { _ in
            // REad textFiel values
            guard let fields = alert.textFields, fields.count == 2 else{
                return
            }
            let categoryField = fields[0]
            let descriptionField = fields[1]
            guard let nombre = categoryField.text, !nombre.isEmpty,
                let descripcion = descriptionField.text else{
                    print("Invalid entries")
                    return
            }
            print("Nombre \(nombre)")
            print("Descripcion \(descripcion)")
            
//            let tasks:[Tarea] = []
//            let task = Tarea?.self
            
            let categoria = ["nombre": nombre, "descripcion" : descripcion]
            Database.database().reference().child("usuarios").child(self.usuarioId).child("categorias").childByAutoId().setValue(categoria)
            
            //self.navigationController?.popViewController(animated: true)
            
        }))
        present(alert, animated: true)
    }
    
    @IBAction func didTapMenuButton(){
        present(sideMenu!, animated: true)
        
    }
    
    @IBAction func didTapLogoutButton(){
        
        do {
           try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
           //navigationController?.popViewController(animated: true)
        } catch {
               // se ha producido error
        }
    }
    
    
    func didSelectMenuItem(named: SideMenuItem) {
        sideMenu?.dismiss(animated: true, completion: nil)
            title = named.rawValue
            
            switch named {
            case .inicio:
                settingController.view.isHidden = true
                infoController.view.isHidden = true
            case .categoria:
               guard let vc = storyboard?.instantiateViewController(identifier: "listacategoria") as? ListCategoriasViewController else {
                   return
               }
               navigationController?.pushViewController(vc,animated: true)
            case .ajustes:
                guard let vc = storyboard?.instantiateViewController(identifier: "configuracioens") as? SettingViewController else {
                    return
                }
                navigationController?.pushViewController(vc,animated: true)
            }
    }
    
    func moveOnCarategoryDetail (cindex: Int) {
        guard let vc = storyboard?.instantiateViewController(identifier: "ListNotesViewController") as? ListNotesViewController
            else{
                return
        }
        //let tareas:[Categoria] = []
        
        //vc.tareasListing = tareas[cindex]
        //vc.listTareas = listCategorias![cindex]
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 2{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as? CollectionTableViewCell else {fatalError("Unable to create explore table view Cell")}
            cell.didSelectClosure = { celIndex in
                if let celIndexp = celIndex {
                    self.moveOnCarategoryDetail(cindex: celIndexp)
                }
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath)
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
