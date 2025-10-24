//
//  CareRecipient+Contact.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 07/10/25.
//

protocol ContactProtocol {
    func addContact(name: String, contactDescription: String?, contactMethod: String?, in personalData: PersonalData)
    func deleteContact(contactRecord: Contact, from personalData: PersonalData)
}

extension CareRecipientFacade: ContactProtocol {
    
    func addContact(name: String, contactDescription: String?, contactMethod: String?, in personalData: PersonalData) {
        guard let context = personalData.managedObjectContext else { return }
        
        let newContact = Contact(context: context)
        newContact.name = name
        newContact.contactDescription = contactDescription
        newContact.contactMethod = contactMethod
        
        let contactsSet = personalData.mutableSetValue(forKey: "contacts")
        contactsSet.add(newContact)
        
        persistenceService.save()
    }
    
    func deleteContact(contactRecord: Contact, from personalData: PersonalData) {
        let contactsSet = personalData.mutableSetValue(forKey: "contacts")
        contactsSet.remove(contactRecord)
        
        persistenceService.save()
    }

}
