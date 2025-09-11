//
//  TripCreationView.swift
//  Gropper
//
//  Created by Bryce King on 7/31/25.
//

import SwiftUI

struct TripCreationView: View {
    let formType: TripType
    @StateObject var viewModel = TripCreationViewModel()
    @State private var displayContactPicker = false
    @Environment(\.dismiss) var dismiss
    var onFormSubmit: () -> Void
    
    var body: some View {
        Form{
            Section{
                TextField("Location", text: $viewModel.tripData.location )
                TextField("Location Description", text: $viewModel.tripData.locationDescription)
            } header: {
                Text(locationHeader)
            }
        
            Section{
                if (formType == .host) {
                    HStack{
                        if (viewModel.selectedContacts.count > 0) {
                            List(viewModel.selectedContacts, id: \.phoneNumber) { contact in
                                Text("\(contact.contactName ?? "")")
                            }
                        } else{
                            Text("No Contacts Selected")
                        }
                    }
                }
                
                if (formType == .request) {
                    if(viewModel.hostContact.phoneNumber.isEmpty) {
                        Text("No Contact Selected")
                    } else{
                        Text("\(viewModel.hostContact.contactName ?? "")")
                    }
            }
                
            Button(action:{
                displayContactPicker.toggle()
            }){
                Text("Select \(contactPlural)")
            }
            } header: {
                Text(selectContactText)
            }

            if (formType == .request) {
                Section(header: Text("What Do You need?")){
                    if (viewModel.items.count > 0) {
                        ForEach($viewModel.items){$item in
                            VStack{
                                TextField("Item Name", text: $item.itemName)
                                Divider()
                                TextField("Item Description", text: $item.itemDescription)
                            }
                            .padding()
                        }
                        .onDelete{ indexSet in
                            viewModel.items.remove(atOffsets: indexSet)
                        }
                        
                    } else{
                        Section{
                            Text("No Items")
                        }
                    }
                    Button("Add Item"){
                        viewModel.items.append(ItemInfo())
                    }
                    
                }
            }
        }
        .sheet(isPresented: $displayContactPicker){
            if (formType == .host) {
                MultipleContactsPickerView(onSelectContacts: {
                        selectedContacts in viewModel.selectedContacts = selectedContacts
                        self.displayContactPicker = false},
                        onCancel: { self.displayContactPicker = false })
            }
            
            if (formType == .request) {
                ContactPickerView(onSelectContact: {
                    hostContact in viewModel.hostContact = hostContact
                    self.displayContactPicker = false},
                    onCancel: { self.displayContactPicker = false })
            }
        }
                    
        .toolbar{
            ToolbarItem(placement: .confirmationAction){
                Button("Create Trip"){
                    Task{
                        if(formType == .host){viewModel.createHostedTrip()}
                        if(formType == .request){viewModel.requestTrip()}
                    }
                }
                .disabled(!canSubmit)
                .onChange(of: viewModel.successfulTripCreation) {
                    if viewModel.successfulTripCreation{
                        onFormSubmit()
                        dismiss()
                    }
                }
            }
        }
    }
    
    var canSubmit: Bool {
        switch formType {
        case .host:
            return !viewModel.tripData.location.isEmpty && !viewModel.selectedContacts.isEmpty
        case .request:
            return !viewModel.tripData.location.isEmpty && !viewModel.hostContact.phoneNumber.isEmpty && viewModel.items.allSatisfy({!$0.itemName.trimmingCharacters(in: .whitespaces).isEmpty})
        }
    }
    
    var locationHeader: String {
        switch formType {
            case .host:
                return "Where Are You Going?"
            case .request:
                return "Where Do You need Items From?"
        }
    }
    
    var contactPlural: String {
        switch formType {
            case .host:
                return "Contacts"
            case .request:
                return "Contact"
        }
    }
    
    var selectContactText: String {
        switch formType {
            case .host:
                return "Who can request items?"
            case .request:
                return "Who's The Request For?"
        }
    }
}


#Preview {
    //TripCreation()
}
