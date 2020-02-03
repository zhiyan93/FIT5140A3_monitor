//
//  HomeViewController.swift
//  5140Assignment3
//
//  Created by hideto on 2/11/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications
import CoreLocation
import FirebaseStorage





class HomeViewController: UIViewController,CLLocationManagerDelegate,UNUserNotificationCenterDelegate {
    
    let locationManager:CLLocationManager = CLLocationManager()
    let userNotificationManager = UNUserNotificationCenter.current()
    let storageRef = Storage.storage().reference()
    //let session = NMSSHSession.init(host: "192.168.43.254", andUsername: "pi")


    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var modeImage: UIImageView!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    var text:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
           locationManager.delegate = self
           locationManager.requestAlwaysAuthorization()
           locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
           locationManager.allowsBackgroundLocationUpdates = true
           locationManager.startUpdatingLocation()
       }

//        session.connect()
//        if (session.isConnected) {
//            session.authenticate(byPassword: "123456")
//            print("authenticate")
//            if (session.isAuthorized) {
//                print("isAuthorized")
//            }
//        }

        
     
        // Do any additional setup after loading the view.
        //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
        //echo "export SENDGRID_API_KEY='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'" > sendgrid.env
    }
    
   override func viewWillAppear(_ animated: Bool){
       getMode()
    
   }
 
 
    
    
    
   
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.last
        var sightNear = false
      
        let location = CLLocation(latitude: CLLocationDegrees(-37.813407), longitude: CLLocationDegrees(144.969730))
        let distance = userLocation?.distance(from: location)
        let withinDis:Double = 300
        if  distance! < withinDis{
            sightNear = true
        }
    
        if(sightNear == true){
            let alert = UIAlertController(title: "You are at home.", message: "Home security is shut down now.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {_ in }))
            self.present(alert,animated:true,completion:nil)
            self.statusImage.image = UIImage(named: "notHome")
            let validationRef = storageRef.child("validation/true.jpeg")
            let image = UIImage(named: "true")!
            if let data = image.pngData(){
                validationRef.putData(data, metadata: nil) { (metadata, error) in
                    guard metadata != nil else {
                    // Uh-oh, an error occurred!
                    print("error happend")
                    return
                  }
                    
                  // You can also access to download URL after upload.
                  validationRef.downloadURL { (url, error) in
                    guard url != nil else {
                      // Uh-oh, an error occurred!
                        print(url ?? "this is default value")
                      return
                    }
                  }
                }
            }
        }
        else{
            let alert = UIAlertController(title: "You are leaving home.", message: "Home security is working now.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {_ in }))
            self.present(alert,animated:true,completion:nil)
            self.statusImage.image = UIImage(named: "athome")

            let validationRef = storageRef.child("validation/true.jpeg")

            // Delete the file
            validationRef.delete { error in
              if let error = error {
                // Uh-oh, an error occurred!
                print(error)
              } else {
                // File deleted successfully
              }
            }
                
        }
    }
    
    //Set up backgorund notification
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways  {
                let region = CLCircularRegion(center:CLLocationCoordinate2D(latitude: CLLocationDegrees(-37.813407), longitude: CLLocationDegrees(144.969730)),radius: 300, identifier: "home")
                region.notifyOnEntry = true
                region.notifyOnExit = false
                let trigger = UNLocationNotificationTrigger(region: region, repeats:true)
                let content = UNMutableNotificationContent()
                content.title = "You are at home !"
                content.body = "Home security will be shut down"
                content.sound = UNNotificationSound.default
                
                let request = UNNotificationRequest(identifier: "home", content: content, trigger: trigger)
                self.userNotificationManager.add(request) {(error) in
                    if let error = error {
                        print("Uh oh! We had an error: \(error)")
                    }
                }
        }
    }
    
    func getMode(){

        
        let Defaults = UserDefaults.standard
        let modeKey = "modeKey"
        if Defaults.bool(forKey: modeKey){
            modeImage.image = UIImage(named: "dectection")
            //runDetectionCommand()
        }
        else{
            modeImage.image = UIImage(named: "streaming")
            //runStreamingCommand()
        }

        
    }
    
//    func runStreamingCommand(){
//          let command = "python3 streaming.py"
//        _ = session.channel.execute(command, error: nil, timeout: 3)
//    }
//
//    func runDetectionCommand(){
//        DispatchQueue.global(qos: .userInitiated).async {
//            let command = "python3 start.py"
//            _ = self.session.channel.execute(command, error: nil, timeout: 3)
//            print("start")
//            // Bounce back to the main thread to update the UI
//            DispatchQueue.main.async {
//
//            }
//        }
//    }
    
    
        
        
        
        
    }
    
    
 




