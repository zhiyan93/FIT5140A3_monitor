//
//  NewVideoViewController.swift
//  5140Assignment3
//
//  Created by hideto on 2/11/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import FirebaseStorage
import Firebase

class NewVideoViewController: UIViewController {

    @IBOutlet weak var photoImage: UIImageView!
    var faceDetection : UIImage?
    let options = VisionFaceDetectorOptions()
    lazy var vision = Vision.vision()
    @IBOutlet weak var resultLabel: UILabel!

    
    var images : [Image] = []
    var videos : [Video] = []


    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        options.minFaceSize = CGFloat(0.1)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        //changeMode()
        refresh()
    }
    
    @IBAction func playBtn(_ sender: Any) {
//
//        let url = URL(string: "https://storage.googleapis.com/fit5140-assignment3-257610.appspot.com/video/notification_video.mp4")!

        
        let storage = Storage.storage(url: "gs://fit5140-assignment3-257610.appspot.com")
                          
        let storageReference = storage.reference().child("video")

        storageReference.listAll{ (result, error) in
                      for item in result.items {
                     // The items under storageReference.
                         print(item.name,item.fullPath, item.bucket)
                        
                        let newvideo = Video(name: item.name, url: item.fullPath)
                       self.videos.append(newvideo)
                      }
        self.videos.sort {$0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedDescending}
        let name = self.videos.first?.name
        print(name!)
            let videoPath = "https://storage.googleapis.com/fit5140-assignment3-257610.appspot.com/video/\(name ?? "16:23:0606-11-2019.mp4")"
        let url = URL(string: videoPath)!
        let player = AVPlayer(url:url)

        let vc = AVPlayerViewController()

        vc.player = player

        self.present(vc, animated: true){ vc.player?.play() }
         
        }
        
    }
    
    @IBAction func refreshBtn(_ sender: Any) {
        refresh()
        

    }
    
    func refresh(){
        let storage = Storage.storage(url: "gs://fit5140-assignment3-257610.appspot.com")
        let storageReference = storage.reference().child("image")
        
        storageReference.listAll{ (result, error) in
                         for item in result.items {
                        // The items under storageReference.
                           // print(item.name,item.fullPath, item.bucket)
                           
                           let newimage = Image(name: item.name, url: item.fullPath)
                          self.images.append(newimage)
                         }
        //print("list "+String(self.images.count))
                    self.images.sort {$0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedDescending}
                    print(self.images.first?.url ?? "error happened")
            self.detectFace(imagePath: self.images.first!.url)
                }
    }
    
    func detectFace(imagePath:String){
        
        let storage = Storage.storage(url: "gs://fit5140-assignment3-257610.appspot.com")
        let storageReference = storage.reference().child(imagePath)
        storageReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
            print(error)
          } else {
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
            self.options.landmarkMode = .all
            let faceDetector = self.vision.faceDetector(options: self.options)
            let visionImage = VisionImage(image: image!)
            faceDetector.process(visionImage) { faces, error in
              guard error == nil, let faces = faces, !faces.isEmpty else {
                // ...
                self.photoImage.image = image
                self.resultLabel.text = " No face detected. Check video"
                return
              }

              // Faces detected
              // ...
                self.photoImage.image = image
               if (faces.count == 1){
                    self.resultLabel.text = " One face detected.\n\n"
                }
                else{
                    self.resultLabel.text = " \(faces.count) face(s) detected.\n\n"
                }
            }
          }
        }
        
        
        
    }
    
    func changeMode(){
        let Defaults = UserDefaults.standard
        let modeKey = "modeKey"
        Defaults.set(true, forKey: modeKey)
        
        let modeRef = Storage.storage().reference().child("validation/mode.jpeg")
        let image = UIImage(named: "true")!
        if let data = image.pngData(){
            modeRef.putData(data, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                // Uh-oh, an error occurred!
                print("error happend")
                return
                }
            }
        }
    }
    

}


