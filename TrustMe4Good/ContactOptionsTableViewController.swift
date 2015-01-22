import UIKit
import AddressBook
import AddressBookUI

class ContactOptionsTableViewController: DICTableViewController {
    var adbk:ABAddressBook?
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier? == "saveToContacts" {
            addToContacts(adbk, newFirstName: "a", newLastName: "AA", newPhone: "111 111 1111", newEmail: "aaa@bbb.dev")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthorization()
    }
    
    func checkAuthorization() {
        let stat = ABAddressBookGetAuthorizationStatus()
        switch stat {
        case .Denied, .Restricted:
            println("no access")
            return
        case .Authorized, .NotDetermined:
            var err : Unmanaged<CFError>? = nil
            var adbk : ABAddressBook? = ABAddressBookCreateWithOptions(nil, &err).takeRetainedValue()
            if adbk == nil {
                println(err)
                return            }
            self.adbk = adbk
            ABAddressBookRequestAccessWithCompletion(adbk) {
                (granted:Bool, err:CFError!) in
                if granted {
                } else {
                    println(err)
                }
            }
        }
    }
    
    func createMultiStringRef() -> ABMutableMultiValueRef {
        let propertyType: NSNumber = kABMultiStringPropertyType
        return Unmanaged.fromOpaque(ABMultiValueCreateMutable(propertyType.unsignedIntValue).toOpaque()).takeUnretainedValue() as NSObject as ABMultiValueRef
    }
    
    func addToContacts(adbk:ABAddressBook?, newFirstName:String, newLastName:String?, newPhone:String?, newEmail:String?) {
        if adbk != nil {
            var newContact:ABRecordRef! = ABPersonCreate().takeRetainedValue()
            var success:Bool = false

            var error: Unmanaged<CFErrorRef>? = nil
            success = ABRecordSetValue(newContact, kABPersonFirstNameProperty, newFirstName, &error)
            println("setting first name was successful? \(success)")
            
            if newLastName != nil {
                success = ABRecordSetValue(newContact, kABPersonLastNameProperty, newLastName!, &error)
            }
            
            if newPhone != nil {
                var multiPhone:ABMutableMultiValueRef  = createMultiStringRef()
            
                ABMultiValueAddValueAndLabel(multiPhone, newPhone!, kABPersonPhoneMobileLabel, nil);
                ABRecordSetValue(newContact, kABPersonPhoneProperty, multiPhone,nil);
            }
            
            if newEmail != nil {
                var multiEmail:ABMutableMultiValueRef = createMultiStringRef()
            
                ABMultiValueAddValueAndLabel(multiEmail, newEmail!, kABHomeLabel, nil);
                ABRecordSetValue(newContact, kABPersonEmailProperty, multiEmail, nil);
            }
            
            println("setting last name was successful? \(success)")
            success = ABAddressBookAddRecord(adbk, newContact, &error)
            println("Adbk addRecord successful? \(success)")
            success = ABAddressBookSave(adbk, &error)
            println("Adbk Save successful? \(success)")
            println("added to contacts")
        } else {
            println("not authorized")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        println("segue called")
    }
}
