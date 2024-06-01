//
//  ViewController.swift
//  NoteSync-App
//
//  Created by CHINAM DWARIKANATH PATRA on 31/05/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Initialisations
    
    @IBOutlet weak var notesTableView: UITableView!
    var notesArray = [Note]()
    
    // MARK: - Segue Data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddNoteViewController
        // Passes the note and tells the view controller to update instead of add
        if segue.identifier == "updateNoteSegue" {
            vc.note = notesArray[notesTableView.indexPathForSelectedRow!.row]
            vc.update = true
        }
    }
    
    // MARK: - LifeCycle Hooks
    
    override func viewWillAppear(_ animated: Bool) {
        // Update the notes array
        APIFunctions.functions.fetchNotes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Update the notes array
        APIFunctions.functions.fetchNotes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIFunctions.functions.delegate = self
        APIFunctions.functions.fetchNotes()
        notesTableView.delegate = self
        notesTableView.dataSource = self
    }
    
    // MARK: - TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototypeCell", for: indexPath) as! NotePrototypeCell
        // Customises cell to set title, note and date
        cell.title.text = notesArray[indexPath.row].title
        cell.note.text = notesArray[indexPath.row].note
        cell.date.text = notesArray[indexPath.row].date
        return cell
    }
}

// MARK: - Custom Delegates

protocol DataDelegate {
    func updateArray(newArray: String)
}

extension ViewController: DataDelegate {
    func updateArray(newArray: String) {
        do {
            notesArray = try JSONDecoder().decode([Note].self, from: newArray.data(using: .utf8)!)
        } catch {
            print("Failed to decode!")
        }
        self.notesTableView?.reloadData()
    }
}
