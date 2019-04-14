//
//  SwipeTableViewController.swift
//  ToDo
//
//  Created by Yusuf ali cezik on 14.04.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate{
  
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate=self
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Sil") { action, indexPath in
            // kaydıktan sonra silme işlemleri ;
           /* do{
                try  self.realm.write {
                    if let kategori = self.categoryArray?[indexPath.row] {
                        self.realm.delete(kategori)
                    }
                }}catch{print("error delete")}
             */
            
        }

 
 
            
        
        // customize the action appearance
 
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    
    
    ////sonuna kadar kaydrma ;
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    

    
}
