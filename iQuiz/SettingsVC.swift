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

    var urlStr = ""

    @IBAction func github(_ sender: Any) {
        input.text = "https://cdn.rawgit.com/uwadmin/b583231b7dfa52dcdd00bc847bd57ea5/raw/9c32101231d70c780710edc7a69cbcbc6042036e/data.json"
    }

    @IBAction func ted(_ sender: Any) {
        input.text = "https://tednewardsandbox.site44.com/questions.json"
    }

    @IBAction func dismiss(_ sender: Any) {
        let mvc = self.presentingViewController as! MainVC
        if (valid(urlStr)) {
            mvc.urlStr = self.urlStr
            mvc.urlChanged = true
//            dismiss(animated: true, completion: {
//                mvc.loadData()
//                mvc.loadQuizzes()
//                mvc.tableView.reloadData()
//            })
//        } else
        }
            dismiss(animated: true, completion: nil)
//        }
    }

    @IBAction func updateURL(_ sender: UIButton) {
        if (valid(input.text)) {
            urlStr = input.text!
            let alert = UIAlertController(title: "URL Updated!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Not a valid HTTPS URL", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func valid(_ urlString: String?) -> Bool {
        guard let urlString = urlString, let url = URL(string: urlString) else { return false }
        if !UIApplication.shared.canOpenURL(url) { return false }
        let regEx = "^https://[^\\s/$.?#].[^\\s]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regEx])
        return predicate.evaluate(with: urlString)
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
