//
//  CreateAccount.swift
//  HangTime
//
//  Created by Peter Bahariance on 9/29/24.
//

import UIKit

class CreateAccountViewController: UIViewController
{
    
    
    @IBOutlet weak var emailButton: UITextField!
    @IBOutlet weak var requiredEmailField: UILabel!
    
    
    @IBOutlet weak var usernameButton: UITextField!
    @IBOutlet weak var requiredUsernameButton: UILabel!
    
    @IBOutlet weak var enterDate: UITextField!
    @IBOutlet weak var requiredDateButton: UILabel!
    
    @IBOutlet weak var passwordButton: UITextField!
    @IBOutlet weak var requiredPasswordButton: UILabel!
    
    @IBOutlet weak var confirmPasswordButton: UITextField!
    @IBOutlet weak var requiredConfirmPasswordButton: UILabel!


    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let existingEmails = userDataDictionaryEmail
//        let existingUsernames = userDataDictionaryUser
        
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        
        // we can play around with this option
        datePicker.preferredDatePickerStyle = .wheels
        
        enterDate.inputView = datePicker
        //enterDate.text = formatDate(date: Date()) // initializes to the current date when first loading
        
        passwordButton.isSecureTextEntry = true
        confirmPasswordButton.isSecureTextEntry = true
        
        resetForm()
        
    }
    
    // this is an objective C function
    @objc func dateChange(datePicker: UIDatePicker)
    {
        enterDate.text = formatDate(date: datePicker.date)
    }
    
    func formatDate(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
    
    
    func resetForm(){
        submitButton.isEnabled = false
        
        requiredEmailField.isHidden = false
        requiredUsernameButton.isHidden = false
        requiredPasswordButton.isHidden = false
        
        requiredConfirmPasswordButton.text = "Required"
        requiredConfirmPasswordButton.isHidden = true

        
        requiredEmailField.text = "Required"
        requiredUsernameButton.text = "Required"
        requiredDateButton.text = "Required"
        requiredPasswordButton.text = "Required"

        emailButton.text = ""
        usernameButton.text = ""
        enterDate.text = ""
        passwordButton.text = ""
        confirmPasswordButton.text = ""
        
        confirmPasswordButton.isUserInteractionEnabled = false
        confirmPasswordButton.alpha = 0.25
        
        setupPasswordToggleButton()

    }
    
    // the follow functions are made to have an action happen the moment their buttons are modified (editing changed)
    
    // ********
    @IBAction func emailChanged(_ sender: Any) {
        
        if let email = emailButton.text{
            
            if let existingEmail = userDataDictionaryEmail[email]
            {
                requiredEmailField.text = "Existing email address"
                requiredEmailField.isHidden = false
            }
            
            else if let errorMessage = invalidEmail(email){
                
                requiredEmailField.text = errorMessage
                requiredEmailField.isHidden = false
                
            }
            else{
                requiredEmailField.isHidden = true
            }
            
        }
        
        checkForValidForm()
    }
    
    func invalidEmail(_ value: String) -> String?
    {
        let regularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        
        if !predicate.evaluate(with: value)
        {
            return "Invalid Email Address"
        }
        
        return nil
    }
    
    
    @IBAction func usernameChanged(_ sender: Any) {
        
        if let enteredUsername = usernameButton.text{
            
            
            if let existingUsername = userDataDictionaryUser[enteredUsername]
            {
                requiredUsernameButton.text = "Username is taken"
                requiredUsernameButton.isHidden = false
            }
            else{
                requiredUsernameButton.isHidden = true
            }
        }
        
        checkForValidForm()
    }
    
    
    @IBAction func birthdateChanged(_ sender: Any)
    {
        requiredDateButton.isHidden = true
        checkForValidForm()
        
    }
    
    @IBAction func passwordChanged(_ sender: Any)
    {
        if let password = passwordButton.text{
            
            if let errorMessage = invalidPassword(password){
                
                requiredPasswordButton.text = errorMessage
                requiredPasswordButton.isHidden = false
                
            }
            else{
                requiredPasswordButton.isHidden = true
                confirmPasswordButton.isUserInteractionEnabled = true
                confirmPasswordButton.alpha = 1
                requiredConfirmPasswordButton.isHidden = false

            }
            
        }
        
        if !requiredConfirmPasswordButton.isHidden,
           let checkConfirmBox = confirmPasswordButton.text,
           let checkPassword = passwordButton.text
        {
            if checkConfirmBox == ""{
                print("We do nothing")
            }
            
            
            else if checkPassword != checkConfirmBox
            {
                requiredConfirmPasswordButton.text = "Password must match"
            }
            
            else {
                requiredConfirmPasswordButton.isHidden = true
            }
        }
        
        checkForValidForm()

        
        
        
    }
    
   

    @IBAction func confirmPasswordChanged(_ sender: Any)
    {
  
  
        if let confirmPassword = confirmPasswordButton.text,
           let currentPassword = passwordButton.text
        {
            print("testing")
            
            print(confirmPassword)
            print(currentPassword)

              if confirmPassword != currentPassword
              {
                  print("This is true!")
                  requiredConfirmPasswordButton.text = "Passwords must match"
                  requiredConfirmPasswordButton.isHidden = false

              }
            else{
                requiredConfirmPasswordButton.isHidden = true
            }
        }
        
        
        checkForValidForm()

    
        
    }
    
    
    // ********
    
    //  first string is input parameter
    // the String? is the the return type
    func invalidPassword(_ value: String) -> String?
    {
        if value.count < 8
        {
            return "Password must be at least 8 characters"
        }
        
        
        if containsDigit(value)
        {
            return "Password must contain at least 1 number"
        }
        
        if containsLowerCase(value)
        {
            return "Password must contain at least 1 lower case letter"
        }
        
        if containsUpperCase(value)
        {
            return "Password must contain at least 1 upper case letter"
        }
        
        if containsSpecialCharacter(value)
        {
            return "Password must contain at least 1 special character"
        }
        
        return nil
            
    }
    
    func containsDigit(_ value: String) -> Bool
    {
        // checks if it contains at least one digit 0-9
        let regularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return !predicate.evaluate(with: value)
       
    }
    
    func containsLowerCase(_ value: String) -> Bool
    {
        let regularExpression = ".*[a-z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return !predicate.evaluate(with: value)
       
    }
    
    func containsUpperCase(_ value: String) -> Bool
    {
        let regularExpression = ".*[A-Z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return !predicate.evaluate(with: value)
       
    }

    func containsSpecialCharacter(_ value: String) -> Bool
    {
        let regularExpression = ".*[!@#$%^&*(),.?\":{}|<>]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return !predicate.evaluate(with: value)
       
    }

    
    
    // makes sure everything is valid before making the submit button to create the account available
    func checkForValidForm()
    {
        if requiredEmailField.isHidden && requiredUsernameButton.isHidden && requiredDateButton.isHidden && requiredPasswordButton.isHidden &&
            requiredConfirmPasswordButton.isHidden
        {
            submitButton.isEnabled = true
        }
        else{
            submitButton.isEnabled = false

        }
    }
    
    @IBAction func submitAction(_ sender: Any)
    {
        APIFunctions.functions.AddUserData(email: emailButton.text!, userName: usernameButton.text!, password: passwordButton.text!, birthDate: enterDate.text!)
        
        let newAccount = AccountInfo(email: emailButton.text!, userName: usernameButton.text!, password: passwordButton.text!, birthDate: enterDate.text!)
        
        userDataDictionaryEmail[emailButton.text!] = newAccount
        userDataDictionaryUser[usernameButton.text!] = newAccount
        
        
    }
    
    private let togglePasswordVisibilityButton1 = UIButton(type: .custom)
    private let togglePasswordVisibilityButton2 = UIButton(type: .custom)

    // Setup the button for toggling password visibility
    private func setupPasswordToggleButton() {
        // Configure the first button for the password field
        togglePasswordVisibilityButton1.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        togglePasswordVisibilityButton1.setImage(UIImage(systemName: "eye"), for: .selected)
        togglePasswordVisibilityButton1.addTarget(self, action: #selector(togglePasswordVisibility1), for: .touchUpInside)
        togglePasswordVisibilityButton1.tintColor = UIColor.blue
        togglePasswordVisibilityButton1.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        // Add the button inside the password field
        passwordButton.rightView = togglePasswordVisibilityButton1
        passwordButton.rightViewMode = .always
        
        // Configure the second button for the confirm password field
        togglePasswordVisibilityButton2.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        togglePasswordVisibilityButton2.setImage(UIImage(systemName: "eye"), for: .selected)
        togglePasswordVisibilityButton2.addTarget(self, action: #selector(togglePasswordVisibility2), for: .touchUpInside)
        togglePasswordVisibilityButton2.tintColor = UIColor.blue
        togglePasswordVisibilityButton2.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        // Add the button inside the confirm password field
        confirmPasswordButton.rightView = togglePasswordVisibilityButton2
        confirmPasswordButton.rightViewMode = .always
    }

    // Action to toggle password visibility for the password field
    @objc private func togglePasswordVisibility1() {
        passwordButton.isSecureTextEntry.toggle()
        togglePasswordVisibilityButton1.isSelected.toggle()
    }

    // Action to toggle password visibility for the confirm password field
    @objc private func togglePasswordVisibility2() {
        confirmPasswordButton.isSecureTextEntry.toggle()
        togglePasswordVisibilityButton2.isSelected.toggle()
    }
    
}
