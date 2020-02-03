//
//  HistoryTableViewController.swift
//  5140Assignment3
//
//  Created by hideto on 7/11/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import Firebase
import AVKit

class HistoryTableViewController: UITableViewController {
    
    var videos : [Video] = []
    var videoDict = [String:[Video]]()
    var sortedKey : [String] = []
    
    var cellColors = [ UIColor(red:1.00, green:0.54, blue:0.00, alpha:1.0),UIColor(displayP3Red: 0.4, green: 0.6, blue: 0.3, alpha: 0.5),UIColor(displayP3Red: 0.2, green: 0.6, blue: 0.6, alpha: 0.5),UIColor(displayP3Red: 0.3, green: 0.5, blue: 0.4, alpha: 0.5)
                    
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          reloadData()
      }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.videoDict.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var rowCount = 0
        if section < self.videoDict.keys.count
        {
            let key = sortedKey[section]
            rowCount = self.videoDict[key]!.count
        }
        print(rowCount)
        return rowCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        // Configure the cell...
        let videoCell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as!
        TableViewCell
        let key = sortedKey[indexPath.section]
        
        let video = videoDict[key]![indexPath.row]
        videoCell.nameLabel.text = video.name
        print("cell"+video.name)

        videoCell.contentView.backgroundColor = cellColors[indexPath.row % cellColors.count]
        return videoCell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let video = self.videos[indexPath.row]
        //print("row \(indexPath.row) selected")
        tableView.deselectRow(at: indexPath, animated: true)
    let videoPath = "https://storage.googleapis.com/fit5140-assignment3-257610.appspot.com/video/\(video.name)"
        let url = URL(string: videoPath)!
    playVideo(url: url)
       
     
       }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(65)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sortedKeys = Array(self.videoDict.keys).sorted(by:>)
        return sortedKeys[section]
    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)

        let vc = AVPlayerViewController()
        vc.player = player

        self.present(vc, animated: true) { vc.player?.play() }
    }
    
    func reloadData(){
        let storage = Storage.storage(url: "gs://fit5140-assignment3-257610.appspot.com")
                          
        let storageReference = storage.reference().child("video")
        
        videos = []

        storageReference.listAll{ (result, error) in
              for item in result.items {
             // The items under storageReference.
                 print(item.name,item.fullPath, item.bucket)
                
                let newvideo = Video(name: item.name, url: item.fullPath)
               self.videos.append(newvideo)
              }
             print("list "+String(self.videos.count))
             self.videos.sort {$0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedDescending}
            
            self.videoDict = Dictionary(grouping: self.videos, by: {$0.name.getDate()})
            self.sortedKey = self.videoDict.keys.sorted(by:>)
            
            print(self.sortedKey)
             self.tableView.reloadData()
             }
        
    }

    
}

extension String{
    func getDate() ->String{
        let start = 0
        let startIndex = self.index(self.startIndex,offsetBy: start)
        let end = start + 10
        let endIndex = self.index(self.startIndex,offsetBy: end)
        
        return String(self[startIndex..<endIndex])
    }
    
    
    
}



