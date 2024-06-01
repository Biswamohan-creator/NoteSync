//
//  APIFunctions.swift
//  NoteSync-App
//
//  Created by CHINAM DWARIKANATH PATRA on 31/05/24.
//

import Foundation
import Alamofire

// MARK: - Custom Notes Struct

struct Note: Decodable {
    var title: String
    var date: String
    var _id: String
    var note: String
}

// MARK: Functions that interact with API

class APIFunctions {
    
    // Sets our custom data delegate
    var delegate: DataDelegate?
    // Creates an instance of the class so the other files can interact with it
    static let functions = APIFunctions()
    let IPAddress = "<Your IP Address>"
    // Fetches notes from database
    func fetchNotes() {
        AF.request("http://\(IPAddress)/fetch").response { response in
            print(response.data)
            // Converts the response into utf8 string format
            let data = String(data: response.data!, encoding: .utf8)
            // Fires off the custom delegate in the view controller
            self.delegate?.updateArray(newArray: data!)
            
        }
    }
    
    // Adding a note to the server, passing the arguments as headers
    func addNote(date: String, title: String, note: String) {
        AF.request("http://\(IPAddress)1/create", method: .post, encoding: URLEncoding.httpBody, headers: ["title": title, "date": date, "note": note]).responseJSON {
            response in
            print(response)
        }
    }
    
    // Updates a note to the server, passing the arguments as headers
    func updateNote(date: String, title: String, note: String, id: String) {
        AF.request("http://\(IPAddress)/update", method: .post, encoding: URLEncoding.httpBody, headers: ["title": title, "date": date, "note": note, "id": id]).responseJSON {
            response in
            print(response)
        }
    }
    
    // Deletes a note from the server, passing the notes id as a header
    func deleteNote(id: String) {
        AF.request("http://\(IPAddress)/delete", method: .post, encoding: URLEncoding.httpBody, headers: ["id": id]).responseJSON {
            response in
            print(response)
        }
    }
}
