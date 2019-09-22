//
//  ViewController.swift
//  PresentationAssistant
//
//  Created by Bowen Li on 2018/4/11.
//  Copyright © 2018年 Bowen Li. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var fileName = ""
    var totalTime = 0.0
    var titles = [""]
    var selected = 0
    
    
    @IBOutlet weak var topicList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        let context = container.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Topic")
        request.returnsObjectsAsFaults = false
        
        do{
            let result = try context.fetch(request)
            print("Data in Core Data")
            for data in result as! [NSManagedObject]{
                print(data.value(forKey: "title") as! String)
                print(data.value(forKey: "estimatedTime" ) as Any)
                titles.append(data.value(forKey: "title") as! String)
            }
        } catch {
            print("Failed")
        }
        
        
        
        topicList.delegate = self
        topicList.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = topicList.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = titles[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? DetailViewController
        destination?.fileName = titles[selected]
        
    }

}

