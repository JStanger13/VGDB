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
        
        
        
        
        if currentGame.cover?.url != nil{
            
            let url = URL(string: "https:" + currentGame.cover!.url!)
            let sessionTask = URLSession.shared
            let request = URLRequest(url: url!)
            let task = sessionTask.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
                if (error == nil) {
                    let image: UIImage = UIImage(data: data!)!
                    cell.coverImage.image = image
                }
                
            })
            task.resume()
            
            
            print(currentGame.cover!.url!)
        }else{
            
            print("Shit's NILL")
        }
        return cell
    }
    
    func getJSON(title: String){
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
