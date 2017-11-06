//
//  Quiz.swift
//  iQuiz
//
//  Created by ​ on 11/5/17.
//  Copyright © 2017 iGuest. All rights reserved.
//

import UIKit

class Quiz {
    var name: String
    var photo: UIImage?
    var desc: String
    
    init?(name: String, photo: UIImage?, desc: String) {
        if name.isEmpty || desc.isEmpty  {
            return nil
        }
        self.name = name
        self.photo = photo
        self.desc = desc
    }
    
}

