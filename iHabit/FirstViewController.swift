//
//  FirstViewController.swift
//  iHabit
//
//  Created by Na Wu on 2016-03-27.
//  Copyright © 2016 Na Wu. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController {
    
    @IBOutlet weak var txtHabitDays: UILabel!
    @IBOutlet weak var txtToday: UILabel!
    @IBOutlet weak var txtComment: UILabel!
    
    let currentDate = NSDate()
    var habitTypes = ["Get Up"]
    var GoodComments = [
        "Fighting!", "Amazing!", "Try harder!", "Don't give up"
    ]
    var BadComments = [
        "Are you sure?", "What are you doing?", "Too lazy girl!"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Delete alll core data
        // deleteCoreData("Habits")
        
        // Display current date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let convertedDate = dateFormatter.stringFromDate(currentDate)
        txtToday.text = convertedDate
        
        // Display how many days to keep this habit
        let days = getContinualDays("Habit")
        txtHabitDays.text = String(days)
        switch days {
        case 0...10:
            txtComment.text = BadComments[random() % BadComments.count]
        case 11...30:
            txtComment.text = GoodComments[random() % GoodComments.count]
        default:
            txtComment.text = "Amazing!"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func habitNo(sender: AnyObject) {
        let tempHabit = iHabits(habitName: habitTypes[0])
        tempHabit.date = NSDate()
        tempHabit.status = false
        saveHabits().save(tempHabit)
        
        // Display how many days to keep this habit
        let days = getContinualDays("Habit")
        txtHabitDays.text = String(days)
        txtHabitDays.text = String(days)
        switch days {
        case 0...10:
            txtComment.text = BadComments[random() % BadComments.count]
        case 11...30:
            txtComment.text = GoodComments[random() % GoodComments.count]
        default:
            txtComment.text = "Amazing!"
        }
    }
    
    @IBAction func habitYes(sender: AnyObject) {
        let tempHabit = iHabits(habitName: habitTypes[0])
        tempHabit.date = NSDate()
        tempHabit.status = true
        saveHabits().save(tempHabit)
        
        // Display how many days to keep this habit
        let days = getContinualDays("Habit")
        txtHabitDays.text = String(days)
        txtHabitDays.text = String(days)
        switch days {
        case 0...10:
            txtComment.text = BadComments[random() % BadComments.count]
        case 11...30:
            txtComment.text = GoodComments[random() % GoodComments.count]
        default:
            txtComment.text = "Amazing!"
        }
    }

}

class iHabits {
    var habitName: String
    var date: NSDate
    var status: Bool
    var continualdays: NSInteger
    
    init (habitName:String) {
        self.habitName = habitName
        self.date = NSDate()
        self.status = true
        self.continualdays = 0
    }
}

class saveHabits {
    func save(iHabit: iHabits) {
        let moc = DataController().managedObjectContext
        
        let testingFetch = NSFetchRequest(entityName: "Habits")
        
        if (iHabit.status == true) {
            do {
                let habitResults = try moc.executeFetchRequest(testingFetch) as! [Habits]
                if (habitResults.count > 0) {
                    let tempdays = habitResults[habitResults.count-1].continualdays
                    iHabit.continualdays = Int(tempdays!) + 1
                    //print ("Last babit information: ")
                    //print ("\(habitResults[habitResults.count-1].date), " + "\(habitResults[habitResults.count-1].status), " + "\(habitResults[habitResults.count-1].continualdays)")
                } else {
                    iHabit.continualdays = 1
                }
            } catch let error as NSError {
                print ("Error \(error)")
            }
        } else {
            iHabit.continualdays = 0
        }

        let entity = NSEntityDescription.insertNewObjectForEntityForName("Habits", inManagedObjectContext: moc) as! Habits
        
        print ("Date: \(iHabit.date)")
        print ("Status: \(iHabit.status)")
        print ("Conintual days: \(iHabit.continualdays)")
        
        entity.setValue(iHabit.habitName, forKey: "habitname")
        entity.setValue(iHabit.date, forKey: "date")
        entity.setValue(iHabit.status, forKey: "status")
        entity.setValue(iHabit.continualdays, forKey: "continualdays")
        
        do {
            try moc.save()
        } catch {
            fatalError("Failure \(error)")
        }
        
        /*
        let testingFetch = NSFetchRequest(entityName: "Habits")
        var error: NSError? = nil
        let amount = moc.countForFetchRequest(testingFetch, error: &error)
        print ("Core data amount: \(amount)")
 */
    }
}

func getContinualDays (habitType: String)->NSInteger {
    let moc = DataController().managedObjectContext
    let testingFetch = NSFetchRequest(entityName: "Habits")
    var days: NSInteger = 0
    do {
        let habitResults = try moc.executeFetchRequest(testingFetch) as! [Habits]
        if (habitResults.count > 0) {
            days = NSInteger(habitResults[habitResults.count-1].continualdays!)
        } else {
            days = 0
        }
    } catch let error as NSError {
        print ("Error \(error)")
    }
    
    return days

}

func deleteCoreData(entity: String) {
    let moc = DataController().managedObjectContext
    let fetchRequest = NSFetchRequest(entityName: entity)
    
    do {
        let results = try moc.executeFetchRequest(fetchRequest)
        for manageObject in results {
            moc.deleteObject(manageObject as! NSManagedObject)
        }
        try moc.save()
    } catch {
        print ("Delete all data error: \(error)")
    }

}