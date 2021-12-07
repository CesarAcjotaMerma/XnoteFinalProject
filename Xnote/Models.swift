//
//  Models.swift
//  Xnote
//
//  Created by Cesar Augusto Acjota Merma on 12/5/21.
//  Copyright © 2021 xnote. All rights reserved.
//

import Foundation

enum CellModel {
    case collectionView(models: [CollectionTableCellModel], rows: Int)
    case list(models: [ListCellModel])
}

struct ListCellModel {
    let title: String
}

struct CollectionTableCellModel {
    let title: String
    let imageName: String
}
