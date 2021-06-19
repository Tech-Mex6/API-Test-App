//
//  ViewController.swift
//  API test run
//
//  Created by meekam okeke on 8/26/20.
//  Copyright © 2020 meekam okeke. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGoButton()
    }
    
    func configureGoButton() {
        let uiButton = UIButton.init(frame: CGRect.init(x: 150, y: 700, width: 100, height: 75))
        uiButton.setTitle("Get Songs", for: .normal)
        uiButton.setTitleColor(.systemBackground, for: .normal)
        uiButton.backgroundColor = .systemBlue
        uiButton.layer.cornerRadius = 10
        uiButton.addTarget(self, action: #selector(GoAction), for: .touchUpInside)
        self.view.addSubview(uiButton)
    }
    
    
    @objc func GoAction(){
        
        if let apiURL      = URL.init(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/coming-soon/all/100/non-explicit.json") {
            
            let urlSession = URLSession.init(configuration: URLSessionConfiguration.default)
            
            let apiTask    = urlSession.dataTask(with: apiURL) {(responseData, URLResponse, error) in
                
                print("response received")
                
                if error == nil {
                    
                    print("Error is nil")
                    
                    let responseDataString = String.init(data: responseData!, encoding: .utf8)
                    
                    print(responseDataString!)
                    
                    var musicItems = [MusicItemModel]()
                    
                    let jsonObject = try? JSONSerialization.jsonObject(with: responseData!, options: .mutableContainers)
                    
                    if let jsonDictionary = jsonObject as? [String: Any]{
                        
                        if let feedDictionary = jsonDictionary["feed"] as? [String: Any]{
                            
                            if let resultArray = feedDictionary["results"] as? [([String: Any])]{
                                
                                for resultDictionary in resultArray{
                                    
                                    let musicItemName        = resultDictionary["name"] as? String ?? ""
                                    let musicItemID          = resultDictionary["id"] as? String ?? ""
                                    let musicItemReleaseDate = resultDictionary["releaseDate"] as? String ?? ""
                                    let musicItemKind        = resultDictionary["kind"] as? String ?? ""
                                    let musicArtistURL       = resultDictionary["artistURL"] as? String ?? ""
                                    let musicArtworkUrl100   = resultDictionary["artworkUrl100"] as? String ?? ""
                                    
                                    let musicItem = MusicItemModel.init(name: musicItemName,
                                                                        id: musicItemID,
                                                                        releaseDate: musicItemReleaseDate,
                                                                        kind: musicItemKind,
                                                                        artistURL: musicArtistURL,
                                                                        artworkImageUrl: musicArtworkUrl100)
                                    
                                    musicItems.append(musicItem)
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        let musicItemViewController = MusicItemViewController.init(musicItems: musicItems)
                        
                        self.present(musicItemViewController, animated: true)
                    }
                } else {
                    print("error from server")
                }
            }
            apiTask.resume()
            
        }else {
            return
        }
    }
    
    func dataTask(with URL: URL, completionHandler: String) -> URLSessionDataTask? {
        print(completionHandler)
        
        return nil
    }
}
