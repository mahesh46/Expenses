//
//  ExpenseRow.swift
//  Expenses
//
//  Created by mahesh lad on 08/05/2024.
//

import SwiftUI

struct ExpenseRow: View {
   @StateObject var expense: Expense
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.name ?? "Unknown")
                    .font(.headline)
               Text("Amount: \(expense.amount, specifier: "%.2f")")
                    .font(.subheadline)
                Text("Date: \(expense.date ?? Date(), formatter: dateFormatter)")
                    .font(.subheadline)
            }
            Spacer()
            if let imageData = expense.image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
}
