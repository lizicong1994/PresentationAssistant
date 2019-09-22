//
//  SecondViewController.swift
//  PresentationAssistant
//
//  Created by Bowen Li on 2018/4/11.
//  Copyright © 2018年 Bowen Li. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    

    @IBOutlet weak var titleName: UITextField!

    @IBOutlet weak var presentTime: UIDatePicker!
    
    var timeInput = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the v
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    @IBAction func nextPage(_ sender: UIButton) {
        if (titleName.text == ""){
            creatAlert(title: "WARNING!", message: "Title can't be empty!")
        }
        else{
            performSegue(withIdentifier: "nextpageVC", sender: self)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as? ThirdViewController
        destination?.titlename = titleName.text!
        destination?.estimatedTime = presentTime.countDownDuration
    }
    
    func creatAlert (title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
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
