//
//  LiveStreamingViewController.swift
//  5140Assignment3
//
//  Created by hideto on 4/11/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import WebKit
import FirebaseStorage


class LiveStreamingViewController: UIViewController {
 


    @IBOutlet weak var webView: WKWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       

        
        
        
    }
    override func viewWillAppear(_ animated: Bool){
        streamingMode()
        streaming()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        dectectionMode()
    }
    
    @IBAction func refreshbtn(_ sender: Any) {
        streaming()
    }
    
    func streamingMode(){
        let Defaults = UserDefaults.standard
        let modeKey = "modeKey"
        Defaults.set(false, forKey: modeKey)
        
        let modeRef = Storage.storage().reference().child("validation/mode.jpeg")
                   // Delete the file
                   modeRef.delete { error in
                     if let error = error {
                       // Uh-oh, an error occurred!
                       print(error)
                     } else {
                       // File deleted successfully
                     }
                   }
    }
    
    func dectectionMode(){
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
    
    
    
    func streaming(){
       
            if let url = URL(string: "http://192.168.43.237:8000/index.html") {
                    let request =  URLRequest(url: url)
                    webView.load(request)

                
                
            }
       
    }
    
    

}

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
