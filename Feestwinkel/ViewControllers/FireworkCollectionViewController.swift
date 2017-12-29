//
//  FirewokCollectionViewController.swift
//  Feestwinkel
//
//  Created by Jeremie Van de Walle on 20/12/17.
//  Copyright © 2017 Jeremie Van de Walle. All rights reserved.
//

import RealmSwift
import UIKit

class FireworkCollectionViewController: UICollectionViewController {

    @IBOutlet weak var fireworkCollectionView: UICollectionView!
    
    var itemsPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    var fireworks: Results<Firework>!
    
    var filter: String = "Naam A - Z"
    
    func sortFirework(){
        switch filter {
        case "Naam A - Z":
            fireworks = fireworks.sorted(byKeyPath: "name", ascending: true)
        case "Naam Z - A":
            fireworks = fireworks.sorted(byKeyPath: "name", ascending: false)
        case "Prijs laag - hoog":
            fireworks = fireworks.sorted(byKeyPath: "price", ascending: true)
        case "Prijs hoog - laag":
            fireworks = fireworks.sorted(byKeyPath: "price", ascending: false)
        case "Type":
            fireworks = fireworks.sorted(byKeyPath: "typeRaw", ascending: true)
        default:
           fireworks = fireworks.sorted(byKeyPath: "name", ascending: true)
        }
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if ( UIDevice.current.model.range(of: "iPad") != nil){
            itemsPerRow = 3
        }
        fireworks = try! Realm().objects(Firework.self)
        sortFirework()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showVideo"){
            let selection = fireworkCollectionView.indexPathsForSelectedItems!.first!
            let firework = fireworks[selection.item]
            
            guard Bundle.main.path(forResource: firework.code, ofType: "mp4") != nil else {
                let alert = UIAlertController(title: "Fout", message: "Voor de " + firework.name + " is geen video beschikbaar, onze excuses.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Oke", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            let fireworkPlayerViewController = segue.destination as! FireworkPlayerViewController
            fireworkPlayerViewController.code = firework.code
        }
        if(segue.identifier == "filter"){
            let fireworkFilterViewController = segue.destination as! FireworkFilterViewController
                fireworkFilterViewController.selectedFilter = filter
        }
    }
    override var prefersStatusBarHidden : Bool { return false }
    
}

extension FireworkCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fireworks.count
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FireworkCell", for: indexPath) as! FireworkCell
        cell.firework = fireworks[indexPath.item]
        cell.layer.borderWidth = 0
        return cell
    }
}

extension FireworkCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension FireworkCollectionViewController {
    
    @IBAction func unwindFilter(segue: UIStoryboardSegue) {
        guard segue.identifier == "didSelectFilter" else {
            fatalError("Unknown segue")
        }
        let fireworkFilterViewController = segue.source as! FireworkFilterViewController
        filter = fireworkFilterViewController.selectedFilter!
        sortFirework()
    }
}


