//
//  Firework.swift
//  Feestwinkel
//
//  Created by Jeremie Van de Walle on 20/12/17.
//  Copyright © 2017 Jeremie Van de Walle. All rights reserved.
//
import RealmSwift

class Firework: Object {
    
    enum FireworkType: String {
        
        case battery = "battery"
        case rocket = "rocket"
        static let values: [FireworkType] = [.battery, .rocket]
    }
    
    @objc dynamic var name : String = ""
    @objc dynamic var shots : String = ""
    @objc dynamic var price : Double = 0.0
    @objc dynamic var code : String = ""
    @objc dynamic var typeRaw = ""
    var type: FireworkType {
        get {
            return FireworkType(rawValue: typeRaw)!
        } set {
            typeRaw = newValue.rawValue
        }
    }
    
    convenience init (name: String, shots: String, price: Double, code : String, type: FireworkType){
        self.init()
        self.name = name
        self.shots = shots
        self.price = price
        self.code = code
        self.type = type
    }
}
