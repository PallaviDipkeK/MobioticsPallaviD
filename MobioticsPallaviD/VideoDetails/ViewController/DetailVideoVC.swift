//
//  DetailVideoVC.swift
//  MobioticsPallaviD
//
//  Created by Administrator on 03/04/20.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import CoreData
import MBProgressHUD

class DetailVideoVC: UIViewController {
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var tblVideoList: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    var selectedIndex = String()
    var player: AVPlayer!
    var startTimeFromVideoPlay = 0.0
    var storedVideos = [ListOfVideosToShow]()
    var videosList = [ListOfVideosToShow]()
    var playerLayer: AVPlayerLayer!
    var isVideoPlaying = false
    var seekTime = 0.0
    var startedWithSeek : Bool = false
    @IBOutlet weak var timeSlider: UISlider!
    //@IBOutlet weak var currentTimeLabel: UILabel!
    // @IBOutlet weak var durationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playVideo()
    }
    
    func playVideo(){
        playPauseButton.setTitle("Play", for: .normal)
        videosList = storedVideos.filter { $0.id != selectedIndex }
        if videosList.count > 0{
            tblVideoList.reloadData()
        }
        let currentVideo = storedVideos.filter { $0.id == selectedIndex }
        titleLabel.text! = currentVideo.first?.title ?? ""
        descriptionLabel.text! = currentVideo.first?.descriptionOfVideo ?? ""
        let url = URL(string:currentVideo.first?.url ?? "")
        player = AVPlayer(url: url!)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
        seekTime = Double(currentVideo.first?.startTime ?? 0.0)
        MBProgressHUD.showAdded(to: (self.videoView)!, animated: true)
        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        addTimeObserver()
    }
    
    
    func updateStartTime(){
        let managedObjectContext = CoreDataClass.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ListOfVideosToShow")
        fetchRequest.predicate = NSPredicate(format: "id = \(selectedIndex)")
        let result = try? managedObjectContext.fetch(fetchRequest)
        let resultData = result as! [ListOfVideosToShow]
        for object in resultData {
            if object.startTime != Float(startTimeFromVideoPlay) {
                object.setValue(NSNumber(value: startTimeFromVideoPlay), forKey: "startTime")
            }
        }
        do {
            try managedObjectContext.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        self.tblVideoList.reloadData()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoView.bounds
    }
    
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            self?.player.playImmediately(atRate: 0.1)
            guard let currentItem = self?.player.currentItem else {return}
            guard currentItem.status.rawValue == AVPlayerItem.Status.readyToPlay.rawValue else {return}
            if !(self?.startedWithSeek ?? true){
                MBProgressHUD.hide(for: (self?.videoView)!, animated: true)
                let intervel : CMTime = CMTimeMake(value: Int64((self?.seekTime)!), timescale: 1)
                currentItem.seek(to: intervel)
                self?.startedWithSeek = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self?.timeSlider.value = Float(currentItem.currentTime().seconds)
                self?.timeSlider.maximumValue = Float(currentItem.duration.seconds)
                self?.timeSlider.minimumValue = 0
            })
            self?.startTimeFromVideoPlay = currentItem.currentTime().seconds
        })
        playerLayer = AVPlayerLayer(player: player)
        videoView.layer.addSublayer(playerLayer)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        if player != nil{
            defer {
                self.player.currentItem?.removeObserver(self, forKeyPath: "duration")
                self.updateStartTime()
            }
        }
    }
    
    @IBAction func playPressed(_ sender: UIButton) {
        if isVideoPlaying {
            player.pause()
            sender.setTitle("Play", for: .normal)
        }else {
            player.play()
            sender.setTitle("Pause", for: .normal)
        }
        
        isVideoPlaying = !isVideoPlaying
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        player.seek(to: CMTimeMake(value: Int64(sender.value*1000), timescale: 1000))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
            let durationLabel = getTimeString(from: player.currentItem!.duration)
            print(durationLabel)
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        if Int(selectedIndex) != storedVideos.count - 1{
            let index : Int = Int(selectedIndex) ?? 0
            selectedIndex =  String(index + 1)
            print(selectedIndex)
            playVideo()
        }
    }
    func getTimeString(from time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds/3600)
        let minutes = Int(totalSeconds/60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours,minutes,seconds])
        }else {
            return String(format: "%02i:%02i", arguments: [minutes,seconds])
        }
    }
}

extension DetailVideoVC:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videosList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailVideoCell") as! DetailVideoCell
        cell.titleLabel.text! = videosList[indexPath.row].title!
        cell.descriptionLabel.text! = videosList[indexPath.row].descriptionOfVideo!
        DispatchQueue.main.async {
            let imageView = self.videosList[indexPath.row].thumb!
            Utilies.setImage(onImageView: (cell.thumbnailImage), withImageUrl: imageView, placeHolderImage: UIImage())
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.player.currentItem?.removeObserver(self, forKeyPath: "duration")
        self.updateStartTime()
        selectedIndex = videosList[indexPath.row].id!
        isVideoPlaying = !isVideoPlaying
        self.startedWithSeek = false
        playVideo()
        
    }
}
