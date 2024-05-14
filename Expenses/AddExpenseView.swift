//
//  AddExpenseView.swift
//  Expenses
//
//  Created by mahesh lad on 08/05/2024.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Binding var isPresented: Bool
    var expense: Expense?
    
    @State private var name: String
    @State private var amount: String
    @State private var date: Date
    @State private var image: UIImage?
    @State private var showingImagePicker = false
    @State private var isShowingCamera = false
    @State private var showAlert = false
    
    init(isPresented: Binding<Bool>, expense: Expense? = nil) {
        self._isPresented = isPresented
        self._name = State(initialValue: "")
        self._amount = State(initialValue: "")
        self._date = State(initialValue: Date())
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                    .lineLimit(10)
                    .textFieldStyle(.roundedBorder)
                if #available(iOS 17.0, *) {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .onChange(of: amount, {
                            let amountString = String(amount)
                            let start = amountString.startIndex
                            let findDot = amountString.firstIndex(of: ".")
                            if let dotIndex = findDot {
                                let leftSide = String(amountString[start..<dotIndex])
                                // by prefixing string you do not allow it to be more than 2 decimal places
                                // .prefix(3) because decimal point is also counted
                                let rightSide = String(amountString[dotIndex...]).prefix(3)
                                // update the amount visible on the text field
                                amount = leftSide + rightSide
                            }
                        })
                } else {
                    
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    // Fallback on earlier versions
                }
                
                DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                
                Button(action: {
                    showingImagePicker.toggle()
                }) {
                    HStack {
                        Image(systemName: "photo")
                        Text("Add Image")
                    }
                }
                
                Button(action: {
                    self.isShowingCamera.toggle()
                }) {
                    HStack {
                        Image(systemName: "camera")
                        Text("Take photo")
                    }
                }
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                }
                
            }
            .navigationTitle( "Add Expense")
            .navigationBarItems(leading: Button("Dismiss") {
                self.presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                if name.isEmpty {
                    showAlert.toggle()
                } else {
                    saveExpense()
                    isPresented = false
                }
            })
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(sourceType: nil, image: $image)
            
        }
        .sheet(isPresented: $isShowingCamera) {
            ImagePicker(sourceType: .camera, image:$image)
        }
        .alert(isPresented: $showAlert) {
                    Alert(title: Text("Important message"), message: Text("Must Enter a Name"), dismissButton: .default(Text("Ok")))
                }
        
    }
    
    private func saveExpense() {
        let newExpense = Expense(context: viewContext)
        newExpense.id = UUID()
        newExpense.name = name
        newExpense.amount = Double(amount) ?? 0
        newExpense.date = date
        
        if let image = image {
            newExpense.image = image.jpegData(compressionQuality: 1.0)
        } else {
            // Handle case when no image is selected
        }
        
        do {
            try viewContext.save()
        } catch {
            // Handle error
            print(error.localizedDescription)
        }
    }
    
    private func loadImage() {
        // Handle loaded image
    }
    
}
