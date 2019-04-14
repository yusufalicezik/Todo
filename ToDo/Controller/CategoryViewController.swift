//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Yusuf ali cezik on 13.04.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: UITableViewController,SwipeTableViewCellDelegate {
    

    ///Realm;
    let realm = try! Realm()
    
    //
    var categoryArray:Results<Category>? //realm nin sunduğu listeler, diziler hepsiyle uyumlu tür
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none //aradaki ayırıcıları çıkarmak için
      
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        
     
             self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "269AAC")
      
    
        
    }
    
    //MARK: Tableview datasource methods //temel
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text=categoryArray?[indexPath.row].name ?? "Kategori Bulunamadı"
        cell.delegate=self
        cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].color ?? "1b9b6f")
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        
        return cell
    }
    
    
    //Mark: Delegate Methods //tıklama vs
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath=tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory=categoryArray?[indexPath.row]
        }
    }
    
    
    //Mark: Data manipulation //load data, save data vs
    func loadData(){
        
        categoryArray = realm.objects(Category.self)
        
        /*let request:NSFetchRequest<Category> = Category.fetchRequest()
        do {categoryArray = try context.fetch(request)
            tableView.reloadData()
        }catch{
            print("çekme hatası")
        }*/
        
         tableView.reloadData()
    }
    
    func saveData(category:Category){
        do{
            try realm.write {
                realm.add(category)
            }
            tableView.reloadData()
            print("saved")
        }catch{
            print("error")
        }
    }
    
    
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        var textField=UITextField()
        let alert = UIAlertController(title: "Yeni Kategori", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Ekle", style: UIAlertAction.Style.default) { (action) in
            //Ekle denildiğinde yapılacaklar//
            
            if textField.text!.count>0{
            let tempCategory=Category()
            tempCategory.name=textField.text!
            tempCategory.color = UIColor.randomFlat.hexValue()
            //self.categoryArray.append(tempCategory) eklemek zorunda değiliz değişiklikler otomatik izlenir ve güncellenir
             self.saveData(category: tempCategory)
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder="Kategori adı girin"
           alertTextField.addConstraint(alertTextField.heightAnchor.constraint(equalToConstant: 35))
            textField=alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    ///MARK: - SWİPE
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Sil") { action, indexPath in
            // kaydıktan sonra silme işlemleri ;
            do{
           try  self.realm.write {
                if let kategori = self.categoryArray?[indexPath.row] {
                self.realm.delete(kategori)
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
