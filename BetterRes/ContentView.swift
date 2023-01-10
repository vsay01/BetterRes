//
//  ContentView.swift
//  BetterRes
//
//  Created by vsay on 1/9/23.
//


import CoreML
import SwiftUI

struct ContentView: View {
    
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var bedTime = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("When do you want to wake up?") {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .onChange(of: wakeUp, perform: { value in
                            calculateBedtime()
                        });
                }
                
                Section("Desired amount of sleep") {                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                        .onChange(of: sleepAmount, perform: {
                            value in
                            calculateBedtime()
                        })
                }
                
                Section("Daily coffee intake") {
                    Picker("Number of cups", selection: $coffeeAmount) {
                        ForEach(1..<21) {
                            Text("\($0)")
                        }
                    }
                    .onChange(of: coffeeAmount, perform: {
                        value in
                        calculateBedtime()
                    })
                }
                
                Text("Your ideal bedtime is \(bedTime)")
                    .resultStyle()
            }
            .navigationTitle("Better Res")
            .navigationBarTitleDisplayMode(.inline)
        }.onAppear {
            calculateBedtime()
        }
    }
    
    func calculateBedtime() {
        // two possible ways cause errors: loading model and ask prediction
        do {
            // create instance of SleepCalculator class
            // read all provided data and output a prediction
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            // we want is to convert that into the time they should go to bed
            let sleepTime = wakeUp - prediction.actualSleep
            
            bedTime = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            // something went wrong!
            bedTime = "Sorry, there was a problem calculating your bedtime."
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
