//
//  MusicItemViewController.swift
//  API test run
//
//  Created by meekam okeke on 8/28/20.
//  Copyright © 2020 meekam okeke. All rights reserved.
//

import Foundation
import UIKit

class MusicItemViewController: UIViewController {
    
    let tableView        = UITableView()
    let musicItems: [MusicItemModel]
    
    init(musicItems: [MusicItemModel]) {
        
        self.musicItems = musicItems
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMusicViewController()
        configureTableView()
    }
    
    func configureMusicViewController() {
        view.backgroundColor = .systemBackground
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame      = view.bounds
        tableView.dataSource = self
    }
}

extension MusicItemViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.musicItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = UITableViewCell.init()
        let musicItem     = self.musicItems[indexPath.row]
        
        tableViewCell.textLabel?.text  = musicItem.name
        tableViewCell.textLabel?.font  = .systemFont(ofSize: 14)
        tableViewCell.imageView?.image = UIImage.init(named: "music_placeholder")
        
        // API call to fetch the images
        if let imageFetchUrl = URL.init(string: musicItem.artworkImageUrl) {
            let urlSession = URLSession.init(configuration: .default)
            
            let imageFetchAPITask = urlSession.dataTask(with: imageFetchUrl) { (imageData, imageURLResponse, imageError) in
                
                if imageError != nil {
                    print("An error occurred while fetching artist image")
                    
                    return
                }
                
                guard let _imageData = imageData else {
                    print("Image data is not available.")
                    
                    return
                }
                
                let artistImage = UIImage.init(data: _imageData)
                
                DispatchQueue.main.async {
                    tableViewCell.imageView?.image = artistImage
                }
            }
            imageFetchAPITask.resume()
        } else {
            print("incorrect image URL.")
        }
        
        return tableViewCell
    }
}
