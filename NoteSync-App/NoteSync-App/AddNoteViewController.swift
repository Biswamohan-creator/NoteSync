//
//  AddNoteViewController.swift
//  NoteSync-App
//
//  Created by CHINAM DWARIKANATH PATRA on 01/06/24.
//

import UIKit

class AddNoteViewController: UIViewController {
    
    // MARK: - Initialisation
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    var note: Note?
    var update = false
    
    // MARK: = UI Buttons
    
    @IBAction func deleteClick(_ sender: Any) {
        APIFunctions.functions.deleteNote(id: note!._id)
        // Returns the screen back to the main screen
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveClick(_ sender: Any) {
        // Crates a date string that we can pass into the database
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: Date())
        
        // If the user is updating, update the note rather than saving
        if update == true {
            APIFunctions.functions.updateNote(date: date, title: titleTextField.text!, note: bodyTextView.text, id: note!._id)
            self.navigationController?.popViewController(animated: true)
            
        } else if titleTextField.text != "" && bodyTextView.text != "" {
            APIFunctions.functions.addNote(date: date, title: titleTextField.text!, note: bodyTextView.text)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - LifeCycle Hooks
    
    override func viewWillAppear(_ animated: Bool) {
        // Disables the delete button if the user is adding a note (can't delete something that doesn't exist)
        if update == false {
            self.deleteButton.isEnabled = false
            self.deleteButton.title = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Prepopulates the text field if the user is updating a note
        if update == true {
            titleTextField.text = note!.title
            bodyTextView.text = note!.note
        }
    }
}
