//
//  FireworkOverviewController.swift
//  Feestwinkel
//
//  Created by Jeremie Van de Walle on 21/12/17.
//  Copyright © 2017 Jeremie Van de Walle. All rights reserved.
//

import RealmSwift
import CoreLocation
import UIKit

class FireworkOverviewController : UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var scanText: UITextView!
    
    var fireworkData: [Firework] = []
    var locationManager: CLLocationManager!
    override func viewDidAppear(_ animated: Bool) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        /* comment next 3 lines to test the scan at home */
        scanButton.isEnabled = false;
        scanButton.alpha = 0.7;
        scanText.isHidden = false;
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }else{
            print(status)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location: CLLocation = manager.location!
        let feestwinkel = CLLocation(latitude: 50.83176265, longitude: 3.59733867)
        let distance = feestwinkel.distance(from: location)
        /* comment this block to test at home */
        if(distance < 60.00){
            scanText.isHidden = true;
            scanButton.isEnabled = true;
            scanButton.alpha = 1;
        }else{
            scanText.isHidden = false;
            scanButton.isEnabled = false;
            scanButton.alpha = 0.7;
        }
        /* stop comment */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.locationManager.startUpdatingLocation()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false;
        self.locationManager.stopUpdatingLocation()
    }
    
    override var prefersStatusBarHidden : Bool { return false }
    
}
