//
//  ScoreVC.swift
//  iQuiz
//
//  Created by ​ on 11/20/17.
//  Copyright © 2017 iGuest. All rights reserved.
//

import UIKit

class ScoreVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    var scoreArr:[String] = []
    var titleDesc:[[String]] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ScoreCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScoreCell else {
            fatalError("The de-queued cell is not an instance of ScoreCell.")
        }
        cell.label.adjustsFontSizeToFitWidth = true
        let title = titleDesc[indexPath.row][0]
        let score = scoreArr[indexPath.row]
        var scoreNum = ""
        let blackFont = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : UIColor.black]
        let redFont = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : UIColor.red]
        let greenFont = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : UIColor.green]
        let grayFont = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : UIColor.gray]
        let blueFont = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : UIColor.blue]
        var rawScore = NSMutableAttributedString(string:score, attributes:redFont)
        if let score2 = score.components(separatedBy: " ").last {
            scoreNum = score2.trimmingCharacters(in: ["%"])
        }
        if (scoreNum == "Score") {
            rawScore = NSMutableAttributedString(string:score, attributes:grayFont)
        } else if (Double(scoreNum)! == 100.0) {
            rawScore = NSMutableAttributedString(string:score, attributes:greenFont)
        } else if (Double(scoreNum)! > 60.0) {
            rawScore = NSMutableAttributedString(string:score, attributes:blueFont)
        }
        let cellLabel = NSMutableAttributedString(string:"\(title): ", attributes:blackFont)
        cellLabel.append(rawScore)
        cell.label.attributedText = cellLabel
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
