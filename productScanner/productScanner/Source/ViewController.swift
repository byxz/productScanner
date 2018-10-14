//
//  ViewController.swift
//  productScanner
//
//  Created by Mac on 10.10.2018.
//  Copyright © 2018 testOrg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCustomeCell
        
        cell.imageProduct.image = UIImage(named: products[indexPath.row].image)
        cell.nameProduct.text = products[indexPath.row].name
        cell.codeProduct.text = products[indexPath.row].code
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        print("Код товара: \(products[indexPath.row].code)")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widht = ((self.mainView.frame.size.width/2) - 20)
        let height = widht
        
        return CGSize(width: widht, height: height)
    }

}
