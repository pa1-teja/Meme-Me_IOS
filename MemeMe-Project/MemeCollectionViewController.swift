//
//  MemeCollectionViewController.swift
//  MemeMe-Project
//
//  Created by TEJAKO3-Old Mac on 26/01/23.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController{
    
    var memes: [Meme.Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var emptyMessage: UILabel!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(!memes.isEmpty){
            refreshMemeDataOnCollectionView()
            toggleMemesEmptyMsgVisibility(isMemeDataAvailable: true)
        }
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(memes.isEmpty){
            toggleMemesEmptyMsgVisibility(isMemeDataAvailable: false)
        } else{
            toggleMemesEmptyMsgVisibility(isMemeDataAvailable: true)
        }
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2*space)) / 3.0
        
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    func refreshMemeDataOnCollectionView(){
        collectionView.reloadData()
    }
    
    func toggleMemesEmptyMsgVisibility(isMemeDataAvailable: Bool){
        emptyMessage.isHidden = isMemeDataAvailable
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let individualMemeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemesCollectionViewCell
        
        individualMemeCell.memeImage.image = memes[(indexPath as NSIndexPath).row].memedImage
        
        return individualMemeCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let memeDetailController = storyboard?.instantiateViewController(withIdentifier: "ChosenMemeDetail") as! MemeDetailViewController
        
        memeDetailController.chosenMeme = memes[(indexPath as NSIndexPath).row]
        
        navigationController?.pushViewController(memeDetailController, animated: true)
    }
 
}
