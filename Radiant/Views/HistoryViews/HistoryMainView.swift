//
//  HistoryMainView.swift
//  Radiant
//
//  Created by Ben Dreyer on 8/12/23.
//

import SwiftUI
import FirebaseAuth


struct HistoryMainView: View {
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    
    @StateObject var historyManager = HistoryManager()
    
    @State var days: [Day] = []
    
    var body: some View {
        ZStack {
            Image("History_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            // Weekly Calendar
            VStack(alignment: .leading) {
                
                if historyManager.focusedDay?.formattedDateForFirestore == Date().formatted(date: .abbreviated, time: .omitted) {
                    Text("Today")
                        .font(.system(size: 20, design: .serif))
                        .foregroundColor(.black)
                        .padding(.leading, 20)
                        .onAppear {
                            print(Date().formatted(date: .abbreviated, time: .omitted))
                        }
                } else {
                    Text(historyManager.focusedDay!.formattedDateForFirestore)
                        .font(.system(size: 20, design: .serif))
                        .foregroundColor(.black)
                        .padding(.leading, 20)
                        
                }
    
                
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(historyManager.days) { day in
                                DayBubble(day: day.self, dayOfMonth: day.dayOfMonth, isComplete: day.doesCheckInExist)
                            }
                        }
                    }
                    .onAppear {
                        proxy.scrollTo( historyManager.days[historyManager.days.count-1].id)
                    }
                }
                
                Spacer()
                
            }
            .padding(.top, 100)
            .onAppear {
                if let user = Auth.auth().currentUser?.uid {
                    historyManager.crossCheckDaysWithCheckInsFromFirstore(userId: user)
                } else {
                    print("no user yet")
                }
            }
            
        }
        .environmentObject(historyManager)
    }
}
    
struct HistoryMainView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryMainView()
            .environmentObject(HistoryManager())
    }
}
    
    
struct DayBubble: View {
    @EnvironmentObject var historyManager: HistoryManager
    
    let day: Day?
    let dayOfMonth: Int?
    let isComplete: Bool?
    let isFocused: Bool = false
    
    var body: some View {
        
        Button(action: {
            historyManager.focusedDay = self.day
        }) {
            
            if historyManager.focusedDay != self.day {
                VStack {
                    Text("\(dayOfMonth!)")
                        .font(.system(size: 14, design: .serif))
                        .foregroundColor(.black)
                    
                    if isComplete! {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.green)
                    } else {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                    }
                    
                }
                .padding(.trailing, 10)
            } else {
                VStack {
                    Text("\(dayOfMonth!)")
                        .font(.system(size: 16, design: .serif))
                        .foregroundColor(.black)
                    
                    if isComplete! {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.green)
                    } else {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                    }
                    
                }
                .padding(.trailing, 10)
            }
        }.animation(.easeInOut(duration: 0.2))
        
    }
}

