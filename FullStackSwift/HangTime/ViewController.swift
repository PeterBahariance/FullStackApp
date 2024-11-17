//
//  ViewController.swift
//  HangTime
//
//  Created by Peter Bahariance on 9/24/24.
//

import UIKit

var userDataDictionaryEmail = [String: AccountInfo]()

var userDataDictionaryUser = [String: AccountInfo]()

class ViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var successfulSignIN: UILabel!

    
    // our original method using only the array:
    //var userData = [AccountInfo]()
    
    // same thing as above, but is a dictionary, where the email will be the key, and the rest of the AccountInfo will be the value
    
    
    var successfulLogin: Bool = false

    private let togglePasswordVisibilityButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        APIFunctions.functions.delegate = self
        APIFunctions.functions.fetchNotes()

    
        
        // Setup password field to be secure initially
        password.isSecureTextEntry = true
        
        // Configure the button for toggling password visibility
        setupPasswordToggleButton()
        

        
    }
    
    
    
    // Setup the button for toggling password visibility
    private func setupPasswordToggleButton() {
        togglePasswordVisibilityButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        togglePasswordVisibilityButton.setImage(UIImage(systemName: "eye"), for: .selected)
        togglePasswordVisibilityButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        togglePasswordVisibilityButton.tintColor = UIColor.blue
        // Add the button inside the password field
        password.rightView = togglePasswordVisibilityButton
        password.rightViewMode = .always
        
        
        // the rightView (used above) is a custom view, which needs specifications of a defined size. Or not, it may
        
        // or else the button may have an implicit size of 0x0
        togglePasswordVisibilityButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24) // Adjust size as needed

    }

    // Action to toggle password visibility
    @objc private func togglePasswordVisibility() {
        password.isSecureTextEntry.toggle()
        togglePasswordVisibilityButton.isSelected.toggle()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // Update the notesArray
        APIFunctions.functions.fetchNotes()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        // Update the notesArray
//        APIFunctions.functions.fetchNotes()
//        
//    }
    
    
    @IBAction func signInButton(_ sender: Any)
    {
        successfulSignIN.textColor = .red

        
        if let checkUserOrEmail = userName.text,
           let checkPassword = password.text
        
        
        {
            if checkUserOrEmail != "" && checkPassword != ""
            {
                
                print(checkUserOrEmail)
                print(checkPassword)
                
                if let foundEmail = userDataDictionaryEmail[checkUserOrEmail]{
                    print("This email exists!")
                    
                    if checkPassword == userDataDictionaryEmail[checkUserOrEmail]?.password{
                        successfulSignIN.isHidden = true
                        successfulLogin = true
                    }
                    else{
                        successfulSignIN.text = "Incorrect Password"
                    }
                    
                }
                else if let foundUsername = userDataDictionaryUser[checkUserOrEmail]{
                    print("This username exists!")
                    successfulSignIN.text = ""
                    
                    if checkPassword == userDataDictionaryUser[checkUserOrEmail]?.password{
                        successfulSignIN.isHidden = true
                        successfulLogin = true

                    }
                    else{
                        successfulSignIN.text = "Incorrect Password"
                    }

                    
                }
                else{
                    successfulSignIN.text = "Invalid username or email"
                }
            }
            else{
                successfulSignIN.text = "Please enter both email and password"
            }
        }
        
        if successfulLogin{
            print("redirecting to new page")
            performSegue(withIdentifier: "signInSeque", sender: Any?.self)
            // signInSeque
        }
       
        
        
    }
 
    
    
    
    
    
    
}

protocol DataDelegate{
    func updateArray(newArray: String)
}

// we could have written this function in the actuall view controller class, but this makes it more cleaner
extension ViewController: DataDelegate{
    func updateArray(newArray: String) {
        
        print("Update array was called!")
        do{
            
            // O(N), fills an array with all the accountInfo
            let accounts = try JSONDecoder().decode([AccountInfo].self, from: newArray.data(using: .utf8)!)

            
            // O(N), fills up both dictionaries, the one that correspond to the email being the key, and the one that corresponds to the username being the key
            accounts.forEach { account in
                userDataDictionaryEmail[account.email] = account         // For email
                    userDataDictionaryUser[account.userName] = account   // For username
            }
            
            
            
            // so we have O(n) + O(n) = O(2n), which is just O(n)
            
            
        }catch {
            print("Failed to decode!")
            
        }
        
        //self.notesTableView?.reloadData()
        
        
    }
    
    
}


