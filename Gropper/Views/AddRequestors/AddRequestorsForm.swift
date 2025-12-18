//
//  AddRequestorsForm.swift
//  Gropper
//
//  Created by Bryce King on 12/16/25.
//

import SwiftUI

struct AddRequestorsForm: View {
    let tripId: String
    var onFormSubmit: () -> Void
    
    @State private var displayContactPicker = false
    @StateObject var viewModel = AddRequestorsViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form{
            Section(header: Text("Add New Requestors to Your Trip")) {
                if (viewModel.selectedContacts.count > 0) {
                    Section{
                        List(viewModel.selectedContacts, id: \.phoneNumber) { contact in
                            Text("\(contact.contactName ?? "")")
                        }
                    }
                } else{
                    Text("No Contacts Selected")
                }
                Button("Select Contacts"){
                    displayContactPicker.toggle()
                }
                .sheet(isPresented: $displayContactPicker){
                    MultipleContactsPickerView(onSelectContacts: {
                        selectedContacts in viewModel.selectedContacts = selectedContacts
                        self.displayContactPicker = false},
                                               onCancel: { self.displayContactPicker = false })
                }
                .toolbar{
                    ToolbarItem(placement: .confirmationAction){
                        Button("Submit"){
                            Task{
                                await viewModel.addRequestors(trip: tripId)
                            }
                        }
                        .disabled(!canSubmit)
                        .onChange(of: viewModel.successfullyAdded) {
                            if viewModel.successfullyAdded{
                                onFormSubmit()
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
    
    var canSubmit: Bool {
        !viewModel.selectedContacts.isEmpty
    }
}
