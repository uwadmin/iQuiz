//
//  SettingsVC.swift
//  iQuiz
//
//  Created by ​ on 11/14/17.
//  Copyright © 2017 iGuest. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var input: UITextField!
    
    var urlStr = "https://cdn.rawgit.com/uwadmin/b583231b7dfa52dcdd00bc847bd57ea5/raw/3ce9d4dad4813d4231a6003cdc9c1037609409c7/data.json"

    @IBAction func github(_ sender: Any) {
        input.text = "https://cdn.rawgit.com/uwadmin/b583231b7dfa52dcdd00bc847bd57ea5/raw/3ce9d4dad4813d4231a6003cdc9c1037609409c7/data.json"
    }
    
    @IBAction func ted(_ sender: Any) {
        input.text = "https://tednewardsandbox.site44.com/questions.json"
    }
    
    @IBAction func dismiss(_ sender: Any) {
        let mvc = self.presentingViewController as! MainVC
        if (valid(urlStr)) {
            mvc.urlStr = self.urlStr
            mvc.urlChanged = true
        }
        dismiss(animated: true, completion: {
            mvc.loadData()
            mvc.tableView.reloadData()
        })
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateURL(_ sender: UIButton) {
        if (valid(input.text)) {
            urlStr = input.text!
            let alert = UIAlertController(title: "URL Updated!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Not a valid URL", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func valid(_ urlString: String?) -> Bool {
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
                return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
