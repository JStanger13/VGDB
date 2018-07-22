//
//  GameModel.swift
//  VGDB
//
//  Created by Justin Stanger on 7/17/18.
//  Copyright © 2018 Justin Stanger. All rights reserved.
//

import Foundation
class GameModel {
    var mainTitle = ""
    var coverImage = ""
    convenience init(title: String, coverImage: String) {
        self.init()
        self.mainTitle = title
        self.coverImage = coverImage
    }
    
}
