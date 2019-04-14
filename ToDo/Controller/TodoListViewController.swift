//
//  ViewController.swift
//  ToDo
//
//  Created by Yusuf ali cezik on 10.04.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoListViewController: UITableViewController, SwipeTableViewCellDelegate{
   
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemArray:Results<Item>?
    let realm = try! Realm()
    var selectedCategory:Category? {
        didSet{
           loadItems()
        }
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        //sqllite ile v.tabanını açabilmemiz için dosya yolu gerekli. Bunu almak için; library supporting files
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.barTintColor = UIColor(hexString : selectedCategory!.color)
        tableView.separatorStyle = .none
        tableView.rowHeight = 60.0
        
        
        //nav color; background dersek hepsinde uygulanır..
        navigationController?.navigationBar.barTintColor = UIColor(hexString : selectedCategory!.color)
        navigationController?.navigationBar.tintColor=ContrastColorOf(UIColor(hexString: selectedCategory!.color)!, returnFlat: true)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(UIColor(hexString: selectedCategory!.color)!, returnFlat: true)]
        
        title = selectedCategory?.name
    }
    
    //MARK: - Tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! SwipeTableViewCell
        
        
        
        
        if let item = itemArray?[indexPath.row]{
            cell.textLabel?.text=item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:
                //current item numarası / toplam item
                CGFloat(indexPath.row) /  CGFloat(itemArray!.count) / 2.45){
                
                cell.backgroundColor = color
                //arka plan rengine göre yazı türü belirlenir, renk gitgide açılır/kapanır
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
                    
                
            
            
            
        }else{
            cell.textLabel?.text="Herhangi bir görev yok"
        }
        
    cell.delegate=self
        
        return cell
    }
    
    //MARK: - Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
        if let item = itemArray?[indexPath.row]{
            do{
                 try realm.write {
                        item.done = !item.done
                 }
            }catch{
                print("error")
                    
            }
        }
     
      
        tableView.reloadData()
      
        
    }


    //MARK: - Add new Items
    @IBAction func addButtonPressed(_ sender: Any) {
    
        var textField=UITextField()
        let alert=UIAlertController(title: "Yeni Görev", message: "Yeni görev eklenecek", preferredStyle: UIAlertController.Style.alert)
        
        let action=UIAlertAction(title:"Ekle", style: UIAlertAction.Style.default) { (action) in
            //ekleye tıklanınca ne olacak?
            if textField.text != nil && textField.text != "" {
                
                
                    if let currentCategory = self.selectedCategory { //kategorinin listesine ekledik görevi
                        do{
                        try self.realm.write {
                            let item=Item()
                            item.title=textField.text!
                            currentCategory.items.append(item)
                            self.realm.add(item)
                            
                            }
                        }catch{
                            print("error")
                        }
                        
                    }
               }
            
            self.tableView.reloadData()
           
            
            }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder="Görev Adı Girin"
            alertTextField.addConstraint(alertTextField.heightAnchor.constraint(equalToConstant: 35))
            alertTextField.backgroundColor=#colorLiteral(red: 0.1492741827, green: 0.6032516106, blue: 0.6764355964, alpha: 0.6923426798)
            alertTextField.layer.borderWidth=0
            alertTextField.layer.borderColor=#colorLiteral(red: 0.1492741827, green: 0.6032516106, blue: 0.6764355964, alpha: 0.6923426798)
            alertTextField.borderStyle = .roundedRect
            
            
            textField=alertTextField
          
        }
        
        
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
 

 

    //default olarak Item.feth.. verdik, eğer request parametresi gelmezse/göndermezsek/boş gönderirsek diye
      func loadItems(){
  
      itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true) //gelen kategorinin items larını sıraladık.
      tableView.reloadData()
    }
    
    
   
    
}


//MARK: - Search bar extension
extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        if searchBar.text != nil && searchBar.text != ""{
            itemArray=itemArray?.filter("title CONTAINS[cd] %@ ", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
            tableView.reloadData()
       
        }
        else{
          self.loadItems()
        }
        
        
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != nil && searchBar.text != ""{
            itemArray=itemArray?.filter("title CONTAINS[cd] %@ ", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
            tableView.reloadData()
          
        }
        else{
            self.loadItems()
        }
        
        
    }
    
    
    ///MARK: - SWİPE
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Sil") { action, indexPath in
            // kaydıktan sonra silme işlemleri ;
            do{
                try  self.realm.write {
                    if let item = self.selectedCategory?.items[indexPath.row] {
                        self.realm.delete(item)
                    }
                }}catch{print("error delete")}
            
            
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
