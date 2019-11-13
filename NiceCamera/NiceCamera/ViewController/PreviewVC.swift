//
//  PreviewVC.swift
//  NiceCamera
//
//  Created by Informatica Labo Mac on 12/11/19.
//  Copyright © 2019 Dan Beltrami. All rights reserved.
//

import UIKit

class PreviewVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imagemView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    var imagens = [UIImage]()
    var posicao = 0
    var selectedIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.delegate = self
        
        imagemView.image = imagens[0]
       
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imagemView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        selectItem(at: 0)
    }
    
    @IBAction func didPressDel(_ sender: Any) {
        imagens.remove(at: posicao)
        
        if imagens.count >= 1 {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            selectItem(at: posicao)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func didPressVolta(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagens.count
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell
        cell.imagemCell.image = imagens[indexPath.row]
        
        if selectedIndexPath == indexPath {
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor.green.cgColor
            cell.layer.cornerRadius = 5.0
        } else {
            cell.layer.borderWidth = 0.0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndexPath != indexPath || selectedIndexPath == nil {
           selectedIndexPath = indexPath
        } else {
           selectedIndexPath = nil
        }

        collectionView.reloadData()
        let i = indexPath.row
        imagemView.image = (i == imagens.count ? imagens[i-1] : imagens[i])
        posicao = indexPath.row
    }
 
    func selectItem(at posicao: Int){
        let index = IndexPath(row: posicao, section: 0)
        collectionView.selectItem(at: index, animated: true, scrollPosition: .centeredHorizontally)
        collectionView.delegate?.collectionView!(collectionView, didSelectItemAt: index)
        selectedIndexPath = index
    }
}

class ImageViewCell: UICollectionViewCell {
    @IBOutlet var imagemCell: UIImageView!
    
}

