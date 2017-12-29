//
//  FireworkCell.swift
//  Feestwinkel
//
//  Created by Jeremie Van de Walle on 20/12/17.
//  Copyright © 2017 Jeremie Van de Walle. All rights reserved.
//

import UIKit

class FireworkCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var shotsLabel: UILabel!
    @IBOutlet weak var fireworkImage: UIImageView!
    
    var firework: Firework! {
        didSet {
            nameLabel.text = firework.name.uppercased()
            shotsLabel.text = firework.shots
            priceLabel.text = "€ " + String(format:"%.2f", firework.price)
            fireworkImage.image = UIImage(named: firework.code)
            }
    }
    
    private func prepareView() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareView()
    }
}

