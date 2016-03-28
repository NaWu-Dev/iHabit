//
//  SecondViewController.swift
//  iHabit
//
//  Created by Na Wu on 2016-03-27.
//  Copyright © 2016 Na Wu. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        print ("TESTING")
        let moc = DataController().managedObjectContext
        let testingFetch = NSFetchRequest(entityName: "Habits")
        
        do {
            let habitResults = try moc.executeFetchRequest(testingFetch) as! [Habits]
            print (habitResults.count)
            if (habitResults.count > 0) {
                for habit in habitResults {
                    print (String(habit.date) + ", " + String(habit.status) + ", " + String(habit.continualdays))
                }
            }
        } catch let error as NSError {
            print ("Error \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

