//
//  PeriodPicker.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI

/// Used to display and modify the period of an era or event .
struct PeriodPicker: View {
    @Binding var period: DateInterval
    @State private var selectedStart: Date = .now
    @State private var selectedUnit: DateInterval.Unit = .day
    @State private var periodDescription: String = ""
    @State private var showPicker: Bool = false

    var body: some View {
        Section  {
            Text(periodDescription)
            if showPicker {
                DatePicker(selection: $selectedStart, displayedComponents: [.date]) {
                    Text("Start")
                }
                VStack(alignment: .trailing) {
                    Stepper(
                        periodDescription,
                        onIncrement: {
                            period.increment(by: selectedUnit)
                            periodDescription = period.periodDescription
                        },
                        onDecrement: {
                            period.decrement(by: selectedUnit)
                            periodDescription = period.periodDescription
                        })
                    Picker("Unit", selection: $selectedUnit) {
                        ForEach(DateInterval.Unit.allCases) { unit in
                            Text(unit.rawValue.capitalized).tag(unit)
                        }
                    }
                }
            }
        } header: {
            HStack {
                Text("period")
                Spacer()
                Button(action: {
                    showPicker.toggle()
                }, label: {
                    Image(systemName: showPicker ? "chevron.up" : "chevron.down")
                })
            }
        }
        .onAppear() {
            selectedStart = period.start
            periodDescription = period.periodDescription
        }
        .onChange(of: selectedStart) { oldValue, newValue in
            period.start = selectedStart
            periodDescription = period.periodDescription
        }
    }
}

#Preview {
    @Previewable @State var period = DateInterval(start: .now, duration: 0)
    Form {
        PeriodPicker(period: $period)
    }
}
