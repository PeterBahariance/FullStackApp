//
//  APIFunctions.swift
//  HangTime
//
//  Created by Peter Bahariance on 9/29/24.
//

import Foundation
import Alamofire

struct AccountInfo: Decodable{
    var email: String
    var userName: String
    var password: String
    var birthDate: String
    
}

// MARK: - Functions that interact with API
class APIFunctions{
    
    // Sets our custom data delegate
    var delegate: DataDelegate?
    
    // this creates an instance of the APIFunctions class, meaning we can then utilize the functions
    
    // below from outside of the class
    
    // It creates an instance of the class so the other files can interact with it
    static let functions = APIFunctions()
    
    // Fetches notes from database
    func fetchNotes(){
        // makes a request to the server, then obtains its response, and prints it
        AF.request("http://192.168.1.166:8081/fetch").response { response in
            
            print("This is a test!")
            
            print(response.data)
            
            // Converts the response into utf8 string format
            // It turns the data that the server sends us into a string we can actually parse
           
            let data = String(data: response.data!, encoding: .utf8)
           
            print("We will now print the data:")
        
            print(data)
            
            
            // This delegate tells the view contrller to fire the function updateArray
            // Meaning it fires off the custom delegate in the view controller
            self.delegate?.updateArray(newArray: data!)
            
        }
        
    }
    
    // Adds a note to the server, passing the arguments as headers
    func AddUserData(email: String, userName: String, password: String, birthDate: String){
        
        // the .post specifies that it is a post request
        AF.request("http://192.168.1.166:8081/create", method: .post, encoding: URLEncoding.httpBody, headers: ["email": email, "userName": userName, "password": password, "birthDate": birthDate]).responseJSON{ response in
            print(response)
        }
    }
//    
//    // Updates a note to the server, passing the arguments as headers
//    func updateNote(date: String, title: String,note: String, id: String){
//        AF.request("http://192.168.1.166:8081/update", method: .post, encoding: URLEncoding.httpBody, headers: ["title": title, "date": date, "note": note, "id" : id]).responseJSON{ response in
//            print(response)
//        }
//    }
//    
//    // Deletes a note to the server, passing the notes id as a header
//    
//    func deleteNote(id: String){
//        AF.request("http://192.168.1.166:8081/delete", method: .post, encoding: URLEncoding.httpBody, headers: ["id" : id]).responseJSON{ response in
//            print(response)
//        }
//    }
    
}
