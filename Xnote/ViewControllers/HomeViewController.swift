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
    
    private let table: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let infoController = InfoViewController()
    private let settingController = SettingViewController()
    
    @IBOutlet weak var emailUser: UILabel!
    
    @IBOutlet weak var fraseBienvenida: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnAdCategoria: UIButton!
    
    var usuarioId = (Auth.auth().currentUser!.uid)
    var usuarioName = (Auth.auth().currentUser!.displayName)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.addSubview(table)
//        table.delegate = self
//        table.dataSource = self
        
        let menu = MenuController(with:SideMenuItem.allCases)
        // side menu
        menu.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        addChildControllers()
        
        //recepcion de datos del usuario
        
        emailUser.text = "HOLA,\(Auth.auth().currentUser!.displayName!)"
        fraseBienvenida.text = "Bienvenid@ a Xnote, disfruta de la App"
        
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
            guard let categoryName = categoryField.text, !categoryName.isEmpty,
                let description = descriptionField.text else{
                    print("Invalid entries")
                    return
            }
            print("Email \(categoryName)")
            print("Description \(description)")
            
            Database.database().reference().child("usuarios").child(self.usuarioId).child("categorias").childByAutoId().setValue(categoryName)
            
        }))
        present(alert, animated: true)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        table.frame = view.bounds
//    }
    
    private func addChildControllers(){
        addChild(settingController)
        addChild(infoController)
        view.addSubview(settingController.view)
        view.addSubview(infoController.view)
        
        settingController.view.frame = view.bounds
        infoController.view.frame = view.bounds
        settingController.didMove(toParent: self)
        infoController.didMove(toParent: self)
        settingController.view.isHidden = true
        infoController.view.isHidden = true
    }
    
    @IBAction func didTapMenuButton(){
        present(sideMenu!, animated: true)
        
    }
    
    func didTapLogoutButton(){
        
        do {
           try Auth.auth().signOut()
           navigationController?.popViewController(animated: true)
        } catch {
               // se ha producido error
        }
//
//        GIDSignIn.sharedInstance()?.signOut()
//
//        try! Auth.auth().signOut()
//
//        dismiss(animated: true, completion: nil)
    }
    
    func didSelectMenuItem(named: SideMenuItem) {
        sideMenu?.dismiss(animated: true, completion: nil)
            title = named.rawValue
            
            switch named {
            case .home:
                settingController.view.isHidden = true
                infoController.view.isHidden = true
            case .info:
                performSegue(withIdentifier: "infoScreen", sender: nil)
                //settingController.view.isHidden = true
                //infoController.view.isHidden = false
            case .setting:
               didTapLogoutButton()
            }
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
        print("HOOLA \(indexPath.row)")
        if indexPath.row < 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as? CollectionTableViewCell else {fatalError("Unable to create explore table view Cell")}
            print("HOOLA \(indexPath.row)")
            return cell
        }
        if indexPath.row > 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListaTareaPendiente", for: indexPath) as? ListaTareaPendiente else {fatalError("Unable to create explore table view Cell")}
            print("HOOLA HIJO DE PUTA \(indexPath.row)")
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath)
        
           cell.textLabel?.text = "No hay Elementos para Mostrar"
           
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

//extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = "Hello World"
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
//}
