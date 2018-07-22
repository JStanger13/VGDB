//
//  ViewController.swift
//  VGDB
//
//  Created by Justin Stanger on 7/17/18.
//  Copyright © 2018 Justin Stanger. All rights reserved.
//

import UIKit
import IGDBWrapper

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    let KEY = "42abe250b08fece0a2a28b1b29d85334"
    var gameList = [Game]()
    
    var currentGame: GameModel?
    let imageCache = NSCache<NSString, UIImage>()

    @IBOutlet weak var textField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
    }
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()  //if desired
        print("OKAY!!!")
        getJSON(title: textField.text!)
        self.tableView.reloadData()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameList.count
    }
   
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameCell
        let currentGame = gameList[indexPath.row]

        cell.gameTitle.text = currentGame.name
        cell.coverImage = nil
        let URL_IMAGE = URL(string: "https://i.4pcdn.org/s4s/1510200817001.png")
        let session = URLSession(configuration: .default)
        let getImageFromUrl = session.dataTask(with: URL_IMAGE!)
       
        cell.coverImage.image = UIImage(data: getImageFromUrl)
        
        //var urlS = (currentGame.cover?.url)!
//        var isStringNil = urlS ?? "nil"
//        var httpImage = ""
//        if isStringNil == "nil"{
//            httpImage = "https://i.4pcdn.org/s4s/1510200817001.png"
//        }else{
//            httpImage = "https:\(isStringNil)"
//        }
//        print(httpImage)
//
//        let urlString = httpImage
//        cell.coverImage!.image! =  fileUrl
//        if let imageFromCache = imageCache.object(forKey: urlString){
//            cell.coverImage.image = imageFromCache
//        } else if let imageURL =  URL(string: (urlString as String)){
//            DispatchQueue.global().async {
//                let data = try? Data(contentsOf: imageURL)
//                if let data = data {
//
//                    let image = UIImage(data: data)
//                    DispatchQueue.main.async {
//
//                        let  imageToCache = image
//                        self.imageCache.setObject(image!, forKey: urlString)
//                            if imageToCache == nil{
//                                //do something
//                        }else{
//                            cell.coverImage.image = imageToCache
//
//                        }
//                    }
//                }
//            }
//        }
//        else{
//            //do nothing
//        }
        return cell
    }
    
    func getJSON(title: String){
        print("INGETJSON")
        self.gameList = [Game]()
        searchGame(title: title)
        self.tableView.reloadData()
    }
    
    func searchGame(title: String){
        print("IN SEARCH GAME")
       
        let wrapper: IGDBWrapper = IGDBWrapper(apiKey: KEY)
        let params: Parameters = Parameters()
            .add(search: title)
            .add(fields: "*")
            .add(order: "published_at:desc")
            
        wrapper.search(endpoint: .GAMES, params: params, onSuccess: {(jsonResponse: [Game]) -> (Void) in
            self.gameList = jsonResponse
            print(self.gameList.count)
            self.tableView.reloadData()
        }, onError: {(Error) -> (Void) in
            // Do something on error
        })
    }

}
