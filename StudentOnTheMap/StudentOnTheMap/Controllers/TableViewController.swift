//
//  TableViewController.swift
//  StudentOnTheMap
//
//  Created by dnlatt on 31/8/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    @IBOutlet var studentTableListView: UITableView!
    
    // Mark Properties
    var students = [StudentInformation]()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        retrieveAllStudents()
    }
    
    // MARK: Get Student
    
    func retrieveAllStudents() {
        UdacityClient.getAllStudentsLocations(completion: { (students, error) in
            
            self.students = students ?? []

            DispatchQueue.main.async {

                self.tableView.reloadData()
            }
        })
    }
    
    // MARK : Table
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCellView", for: indexPath)
        let studentInfo = students[indexPath.row]
        cell.textLabel?.text = "\(studentInfo.firstName)" + " " + "\(studentInfo.lastName)"
        cell.detailTextLabel?.text = "\(studentInfo.mediaURL )"
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentInfo = students[indexPath.row]
        openWebLink(studentInfo.mediaURL)
    }
    
    // MARK : Tab Bar Actions
    
    @IBAction func addStudentLocationTapped(_ sender: Any) {
        print("Tapped Add Student Location")
        performSegue(withIdentifier: "addStudentLocation", sender: sender)
    
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        retrieveAllStudents()
    }
    
       
    @IBAction func logoutTapped(_ sender: Any) {
        UdacityClient.logOut {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
