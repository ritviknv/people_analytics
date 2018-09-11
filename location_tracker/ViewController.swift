//
//  ViewController.swift
//  location_tracker
//
//  Created by Ritvik Vasudevan on 8/27/18.
//  Copyright © 2018 Ritvik Vasudevan. All rights reserved.
//

import UIKit
import CoreLocation
import AWSCore
import AWSS3

class ViewController: UIViewController {
    var locationManager = CLLocationManager()
    var gameTimer: Timer!
    @IBOutlet weak var location_enabled: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var timer = Timer()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.requestAlwaysAuthorization()
        
        if !(CLLocationManager.locationServicesEnabled()){
            location_enabled.text = "No"
        }
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(performTimer), userInfo: nil, repeats: true)
        
        
        uploadData()
    
    }
    @objc func performTimer(){
        if (CLLocationManager.locationServicesEnabled()) {
            location_enabled.text = "Yes"
            print (CLLocationManager.locationServicesEnabled())
            print(CLLocationManager.authorizationStatus())
            print("yes")
            self.locationManager.requestLocation()
            print("yes sir")
            self.locationManager.startUpdatingLocation()
            print("no")
            let lat = self.locationManager.location?.coordinate.latitude
            let long = self.locationManager.location?.coordinate.longitude
            
            print(lat)
            print(long)
            
        }
    }
    func uploadData() {
        
        let data: Data = "TestData".data(using: .utf8)!
        // Data to be uploaded
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Update a progress bar.
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        
        transferUtility.uploadData(data,
                                   bucket: "YourBucket",
                                   key: "YourFileName",
                                   contentType: "text/plain",
                                   expression: expression,
                                   completionHandler: completionHandler).continueWith {
                                    (task) -> AnyObject! in
                                    if let error = task.error {
                                        print("Error: \(error.localizedDescription)")
                                    }
                                    
                                    if let _ = task.result {
                                        // Do something with uploadTask.
                                    }
                                    return nil;
        }
    }
//    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            // authorized location status when app is in use; update current location
//            locationManager.startUpdatingLocation()
//            // implement additional logic if needed...
//        }
//        // implement logic for other status values if needed...
//    }
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        if let location = locations.first as? CLLocation {
//            // implement logic upon location change and stop updating location until it is subsequently updated
//            locationManager.stopUpdatingLocation()
//        }
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            locationManager.requestLocation()
        }
        else if status == .authorizedWhenInUse{
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.first != nil {
            print("location:: (location)")
        }
        
    }
    
}
