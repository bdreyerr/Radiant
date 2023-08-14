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
            Image("Radiant_Home_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            // Weekly Calendar
            VStack(alignment: .leading) {
                Text("August")
                    .font(.system(size: 20, design: .serif))
                    .foregroundColor(.black)
                    .padding(.leading, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(historyManager.days) { day in
                            DayBubble(dayOfMonth: day.dayOfMonth, isComplete: day.doesCheckInExist)
                        }
                    }
                }
                
                Spacer()
                
            }
            .padding(.top, 100)

            
        }
        .onAppear {
            if let user = Auth.auth().currentUser?.uid {
                historyManager.crossCheckDaysWithCheckInsFromFirstore(userId: user)
            } else {
                print("no user yet")
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
    let dayOfMonth: Int?
    let isComplete: Bool?
    
    var body: some View {
        
        Button(action: {
            print("d")
        }) {
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
        }
        
    }
}
