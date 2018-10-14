//
//  GroceryListController.swift
//  productScanner
//
//  Created by Mac on 11.10.2018.
//  Copyright © 2018 testOrg. All rights reserved.
//

import UIKit

var codeAfterScan = ""

class GroceryListController: ViewController {

    @IBAction func onButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension GroceryListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableCustomeCell
        
        cell.nameProduct.text = products[indexPath.row].name
        cell.imageProduct.image = UIImage(named: products[indexPath.row].image)
        cell.codeProduct.text = products[indexPath.row].code
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(products[indexPath.row].code)
        
        products[indexPath.row].code = codeAfterScan
        
        dissMiss()
    }
    
    func dissMiss() {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
