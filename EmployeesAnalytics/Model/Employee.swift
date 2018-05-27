//
//  Employee.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/21/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//
import Foundation

struct EmployeeResult: Codable {
    let data: Employee?
}

class Employee: NSObject, Codable, NSCoding {
    var firstName, lastName, dateStartJob, avatarURL: String?
    var skype, facebook, linkedin, usernameFromJira,  note: String?
    var croppedAvatarURL, email, phoneNumber: String?
    var id: String
    var roles: [String]?
    
    var isMyProfile: Bool {
        return id == UserDefaults.standard.string(forKey: StorageKey.UserId.rawValue)
    }
    
    var userName: String {
        get {
            if firstName != nil && lastName != nil {
                return firstName! + " " + lastName!
            }
            return ""
        }
    }
    
    var avatar: String {
        get {
            if let url = croppedAvatarURL, !url.isEmpty {
                return Constants.ImageStorageUrl + url;
            }
            return ""
        }
    }
    
    var avatarFull: String {
        get {
            if let url = avatarURL, !url.isEmpty {
                return Constants.ImageStorageUrl + url;
            }
            else if let url = croppedAvatarURL, !url.isEmpty {
                return Constants.ImageStorageUrl + url;
            }
            return ""
        }
    }
    
    var position: String? {
        get {
            return roles?.count == 0 ? nil : roles?.joined(separator: ", ")
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        dateStartJob = aDecoder.decodeObject(forKey: "dateStartJob") as? String
        avatarURL = aDecoder.decodeObject(forKey: "avatarURL") as? String
        skype = aDecoder.decodeObject(forKey: "skype") as? String
        facebook = aDecoder.decodeObject(forKey: "facebook") as? String
        linkedin = aDecoder.decodeObject(forKey: "linkedin") as? String
        note = aDecoder.decodeObject(forKey: "note") as? String
        croppedAvatarURL = aDecoder.decodeObject(forKey: "croppedAvatarURL") as? String
        id = aDecoder.decodeObject(forKey: "id") as! String
        email = aDecoder.decodeObject(forKey: "email") as? String
        phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as? String
        roles = aDecoder.decodeObject(forKey: "roles") as? [String]
        usernameFromJira = aDecoder.decodeObject(forKey: "usernameFromJira") as? String
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(dateStartJob, forKey: "dateStartJob")
        aCoder.encode(avatarURL, forKey: "avatarURL")
        aCoder.encode(skype, forKey: "skype")
        aCoder.encode(facebook, forKey: "facebook")
        aCoder.encode(linkedin, forKey: "linkedin")
        aCoder.encode(note, forKey: "note")
        aCoder.encode(croppedAvatarURL, forKey: "croppedAvatarURL")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(roles, forKey: "roles")
        aCoder.encode(usernameFromJira, forKey: "usernameFromJira")
    }
    
    enum CodingKeys: String, CodingKey {
        case firstName, lastName, dateStartJob, usernameFromJira
        case avatarURL = "avatarUrl"
        case skype, facebook, linkedin, note
        case croppedAvatarURL = "croppedAvatarUrl"
        case id, email, phoneNumber, roles
    }
}
