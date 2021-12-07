//
//  TableViewCell.swift
//  Xnote
//
//  Created by Cesar Augusto Acjota Merma on 12/5/21.
//  Copyright © 2021 xnote. All rights reserved.
//

import UIKit

class ListaTareaPendiente: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ListaTareaPendiente: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 5
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "ListaTareaPendiente", for: indexPath)
        
           cell.textLabel?.text = "Hello World"
           
           return cell
       }
}
