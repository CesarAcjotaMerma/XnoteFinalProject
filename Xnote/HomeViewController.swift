//
//  HomeViewController.swift
//  Xnote
//
//  Created by Cesar Augusto Acjota Merma on 12/2/21.
//  Copyright © 2021 xnote. All rights reserved.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController, MenuControllerDelegate {

    private var sideMenu: SideMenuNavigationController?
    
    private let infoController = InfoViewController()
    private let settingController = SettingViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menu = MenuController(with:SideMenuItem.allCases)
        
        menu.delegate = self
        
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        addChildControllers()
    }
    
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
    
    func didSelectMenuItem(named: SideMenuItem) {
        sideMenu?.dismiss(animated: true, completion: nil)
            
            title = named.rawValue
            
            switch named {
            case .home:
                settingController.view.isHidden = true
                infoController.view.isHidden = true
            case .info:
                settingController.view.isHidden = true
                infoController.view.isHidden = false
            case .setting:
                settingController.view.isHidden = false
                infoController.view.isHidden = true
            }
    }

}
