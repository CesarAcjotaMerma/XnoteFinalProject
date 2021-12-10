//
//  CollectionTableViewCell.swift
//  Xnote
//
//  Created by Cesar Augusto Acjota Merma on 12/4/21.
//  Copyright © 2021 xnote. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

typealias DidSelectClosure = ((_ collectionIndex: Int? ) -> Void )

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var categorias:[Categoria] = []
    
    var index: Int?
    var didSelectClosure: DidSelectClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.cornerRadius = 5.0
        

        self.collectionView.reloadData()
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("categorias").observe(DataEventType.childAdded, with: {(snapshot) in
        print(snapshot)
        
        let categoria = Categoria()
        
        categoria.name = (snapshot.value as! NSDictionary)["nombre"] as! String
        categoria.descript = (snapshot.value as! NSDictionary)["descripcion"] as! String
        categoria.id = snapshot.key
        
        self.categorias.append(categoria)
        
        self.collectionView.reloadData()
        
        })
        
        self.collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}

extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categorias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.layer.cornerRadius = 20.0
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 130))
        title.textColor = UIColor.black
        let categoria = categorias[indexPath.row]
        title.text = "\(categoria.name)"
        title.font = UIFont.systemFont(ofSize: 12.0)
        title.textAlignment = .center
        cell.contentView.addSubview(title)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectClosure!(indexPath.row)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 130)
    }
    
    
    
}
