//
//  VideoListVC.swift
//  MobioticsPallaviD
//
//  Created by Administrator on 03/04/20.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import Alamofire
import Kingfisher
import CoreData
import MBProgressHUD

class VideoListVC: BaseVC {
    
    @IBOutlet weak var listingTableView: UITableView!
    var storedVideos = [ListOfVideosToShow]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Videos"
        let fetchRequest : NSFetchRequest<ListOfVideosToShow> = ListOfVideosToShow.fetchRequest()
        do{
            let video = try CoreDataClass.context.fetch(fetchRequest)
            self.storedVideos = video
            if self.storedVideos.count > 0{
                self.listingTableView.reloadData()
            }else{
                 MBProgressHUD.showAdded(to: self.view, animated: true)
                VideoListVM.shared.getData { (success, response) in
                    if let responseData = response as? Data {
                        do {
                            var videos = [VideoListModel]()
                            videos = try JSONDecoder().decode([VideoListModel].self, from: responseData)
                            print(videos)
                            for i in 0...videos.count - 1{
                                let videoDict = ListOfVideosToShow(context: CoreDataClass.context)
                                videoDict.id = videos[i].id
                                videoDict.title = videos[i].title
                                videoDict.descriptionOfVideo = videos[i].description
                                videoDict.thumb = videos[i].thumb
                                videoDict.url = videos[i].url
                                videoDict.startTime = 0.0
                                self.storedVideos.append(videoDict)
                                print(videoDict)
                                CoreDataClass.saveContext()
                                
                            }
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.listingTableView.reloadData()
                        }catch(let err){
                            print(err.localizedDescription)
                        }
                    }else{
                        self.showAlertMessage(titleStr: "", messageStr: "Sorry..No Data Found")
                    }
                }
            }
        }catch(let err){
            print(err.localizedDescription)
        }
    }
    
    
    @IBAction func didSelectBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension VideoListVC:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedVideos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell") as! VideoListCell
        cell.thumbnailImage.image = UIImage(contentsOfFile: storedVideos[indexPath.row].thumb!)
        cell.titleLabel.text! = storedVideos[indexPath.row].title!
        cell.descriptionLabel.text! = storedVideos[indexPath.row].descriptionOfVideo ?? ""
        DispatchQueue.main.async {
            let imageView = self.storedVideos[indexPath.row].thumb!
            Utilies.setImage(onImageView: (cell.thumbnailImage), withImageUrl: imageView, placeHolderImage: UIImage())
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navigationToDetail = storyboard?.instantiateViewController(withIdentifier: "DetailVideoVC") as! DetailVideoVC
        navigationToDetail.storedVideos = self.storedVideos
        navigationToDetail.selectedIndex = self.storedVideos[indexPath.row].id ?? ""
        self.navigationController?.pushViewController(navigationToDetail, animated: true)
        
    }
}
