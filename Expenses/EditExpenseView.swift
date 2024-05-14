//
//  EditExpenseView.swift
//  Expenses
//
//  Created by mahesh lad on 09/05/2024.
//

import SwiftUI
import CoreData

struct EditExpenseView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var expense: Expense
    @State private var nameFieldDetails: String
    @State private var amountFieldDetails: String
    @State private var dateFieldDetails: Date
    @State private var idFieldDetails: UUID
    @State private var image: UIImage?
    @State private var showingImagePicker = false
    @State private var isShowingCamera = false
    @State private var showAlert = false
    
    init(expense: Expense) {
        _expense = ObservedObject(wrappedValue: expense)
        _nameFieldDetails = State(initialValue: expense.name ?? "")
        _amountFieldDetails =  State(initialValue: "\(expense.amount)")
        _dateFieldDetails = State(initialValue: expense.date ?? Date())
        _idFieldDetails = State(initialValue: expense.id ?? UUID())
        if let imageData = expense.image {
            self._image = State(initialValue: UIImage(data: imageData))
        }
    }
    
    fileprivate func saveExpense() {
        self.expense.name = self.nameFieldDetails
        self.expense.amount = Double(self.amountFieldDetails) ?? 0
        self.expense.date = self.dateFieldDetails
        if let image = self.image {
            self.expense.image = image.jpegData(compressionQuality: 1.0)
        }
        
        do {
            try self.managedObjectContext.save()
            self.presentationMode.wrappedValue.dismiss()
        } catch {
            // handle the Core Data error
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Name", text: $nameFieldDetails, axis: .vertical)
                        .lineLimit(10)
                        .textFieldStyle(.roundedBorder)
                    
                    if #available(iOS 17.0, *) {
                        TextField("Amount", text: $amountFieldDetails)
                            .keyboardType(.decimalPad)
                        
                            .onChange(of: amountFieldDetails, {
                                let amountString = String(amountFieldDetails)
                                let start = amountString.startIndex
                                let findDot = amountString.firstIndex(of: ".")
                                if let dotIndex = findDot {
                                    let leftSide = String(amountString[start..<dotIndex])
                                    // by prefixing string you do not allow it to be more than 2 decimal places
                                    // .prefix(3) because decimal point is also counted
                                    let rightSide = String(amountString[dotIndex...]).prefix(3)
                                    // update the amount visible on the text field
                                    amountFieldDetails = leftSide + rightSide
                                }
                            })
                    } else {
                        // Fallback on earlier versions
                        TextField("Amount", text: $amountFieldDetails)
                            .keyboardType(.decimalPad)
                    }
                    
                    DatePicker("Date", selection: $dateFieldDetails, displayedComponents: [.date, .hourAndMinute])
                    
                    
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
                    
                    // share link to share image
                    if let image = image {
                        let example = Image(uiImage: image)
                        
                        ShareLink(item: example, preview: SharePreview("Expense: \(expense.name ?? ""),  Amount: \(expense.amount, specifier: "%.2f"), Date: \(expense.date ?? Date())", image: example)) {
                            Label("Click to share", systemImage: "square.and.arrow.up")
                        }
                    }
                    
                }
                .navigationTitle("Edit Expense")
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: $image)
                }
                .sheet(isPresented: $isShowingCamera) {
                    ImagePicker(sourceType: .camera, image:$image)
                }
                .alert(isPresented: $showAlert) {
                            Alert(title: Text("Important message"), message: Text("Must Enter a Name"), dismissButton: .default(Text("Ok")))
                        }
                
                Button("Delete") {
                    managedObjectContext.delete(expense)
                    do {
                        try self.managedObjectContext.save()
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        // handle the Core Data error
                    }
                } .tint(Color.red)
            }
            .navigationBarItems(leading: Button("Dismiss") {
                self.presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                if nameFieldDetails.isEmpty {
                    showAlert.toggle()
                } else {
                    saveExpense()
                }
            })
        }
    }
    
    private func loadImage() {
        // Handle loaded image
    }
}
