//
//  DreamIView.swift
//  Absorbed
//
//  Created by forest on 2024/03/25.
//

import SwiftUI

let dateFormatStr = "yyyy/MM/dd"

struct DreamView: View {
    
    init() {
        nowAge = calcNowAge()
//        birthDay = stringToDate(dateValue: birthDayStr, format: dateFormatStr)
//        let date = Calendar.current.date(byAdding: .year, value: age, to: birthDay)!
//        dreamLimitStr = dateToString(date: date, format: dateFormatStr)
    }
    
    @AppStorage(KeyString.dreamStr.rawValue) var dreamStr = "お金持ちになって自由を手にいれる"
    @AppStorage(KeyString.birthDayStr.rawValue) var birthDayStr = "2000/01/01"
    @AppStorage(KeyString.age.rawValue) var age = 30
    @AppStorage(KeyString.nowAge.rawValue) var nowAge = 24
    @AppStorage(KeyString.dreamLimitStr.rawValue) var dreamLimitStr = dateToString(date: Calendar.current.date(byAdding: .year, value: 30, to: stringToDate(dateValue: "2000/01/01", format: dateFormatStr))!)
    
//    @State var birthDay : Date = stringToDate(dateValue: "2000/01/01", format: dateFormatStr)
//    @State var limitDate : Date = Date() //stringToDate(dateValue: dreamLimitStr, format: "yyyy/MM/dd")
//    @State var nowAge : Int = 0 // calcNowAge()
    
    let vSpace : CGFloat = 3
    
    func calcLimitDate() -> Date {
        let birth = stringToDate(dateValue: birthDayStr, format: dateFormatStr)
//        age = calcAge()
        let date = Calendar.current.date(byAdding: .year, value: age, to: birth)!
        return date
    }
 
    // 期限から年齢を計算
    func calcAge() -> Int {
        let birth = stringToDate(dateValue: birthDayStr, format: dateFormatStr)
        let limitDate = stringToDate(dateValue: dreamLimitStr, format: dateFormatStr)
        let span = limitDate.timeIntervalSince(birth) // 1209600秒差
        let daySpan = Int(span/60/60/24/365) // 14 (日)
        nowAge = calcNowAge()
        return daySpan
    }
    
    // 今の年齢
    func calcNowAge() -> Int {
        let birth = stringToDate(dateValue: birthDayStr, format: dateFormatStr)
        let span = Date().timeIntervalSince(birth)
        let daySpan = Int(span/60/60/24/365)
        return daySpan
    }
    
    var body: some View {
        
//        ZStack(alignment: .top) {
//            NavigationView {
//                Text("Dreamer")
//                    .navigationBarTitle("", displayMode: .inline)
//            }
////            Image("dreamer_icon")
////                .resizable()
////                .scaledToFit()
////                .frame(width: nil, height: 44, alignment: .center)
//        }
            
        NavigationView {
            
            
            VStack {
                
                
                Text("あなたの「夢」は何ですか？\n\nそれを「いつまで」に実現したいですか？\n\nそれらが明確でない限り\n夢が一生叶うことはありません！")
                    .padding(.bottom, 10)
                
                
                VStack(alignment: .leading) {
                    Text("①あなたの夢、実現したいこと")
                    Text("②期限（年齢）")
                }
                .bold()
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .background(.gray.opacity(0.2))
                .cornerRadius(3.0)
                
                Text("を下に書き込んでください。")
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                
                Text("① 私の夢、実現したいこと")
                    .foregroundStyle(Color("dream"))
                    .bold()
                
                TextField("私の夢、実現したいこと", text: $dreamStr)
                    .cornerRadius(3.0)
                    .foregroundColor(Color("continuing_rect"))
                    .bold()
                    .padding(10)
                    .background(Color("dream").opacity(0.2))
                    .padding(.horizontal, 20)
                    .padding(.top, 0)
                    .padding(.bottom, 15)
                    .font(.system(size: 18))
                
                //                .frame(height: 30)
                
                
                //                .font(.system(size: 16))
                
                
                
                Text("② 達成期限（年齢）")
                    .foregroundStyle(Color("dream"))
                    .bold()
                
                HStack(alignment: .top) {
                    
                    //                VStack(spacing: vSpace) {
                    VStack() {
                        Text("誕生日")
                            .offset(y: -2)
                        Spacer()
                        DatePicker("", selection: Binding(get: {
                            //                        birthDay
                            stringToDate(dateValue: birthDayStr, format: dateFormatStr)
                        }, set: { (newVal) in
                            let birthDay = newVal
                            birthDayStr = dateToString(date: birthDay, format: dateFormatStr)
                            let date = calcLimitDate()
                            dreamLimitStr = dateToString(date: date, format: dateFormatStr)
                            nowAge = calcNowAge()
                            //                        age = calcAge()
                            
                        }) ,displayedComponents: .date)
                        .bold()
                    }
                    //                .frame(height: 40)
                    //                .background(.red)
                    
                    //                VStack(spacing: vSpace) {
                    VStack() {
                        //                    Spacer()
                        Text("年齢")
                        //                        .padding(.bottom, 0)
                        Spacer()
                        Picker("", selection: Binding(get: {
                            age
                        }, set: { (newVal) in
                            age = newVal
                            nowAge = calcNowAge()
                            dreamLimitStr = dateToString(date: calcLimitDate(), format: dateFormatStr)
                        })) {
                            ForEach(nowAge ... 200, id: \.self) { num in
                                Text("\(num)歳")
                                
                            }
                            //                        .frame(width: 30)
                        }
                        //                    .padding(.top, 0)
                        
                    }
                    //                .frame(height: 40)
                    //                .background(.red)
                    
                    //                VStack(spacing: vSpace) {
                    VStack() {
                        Text("期日")
                        Spacer()
                        Text(dreamLimitStr)
                            .font(.system(size: 17))
                            .foregroundStyle(.black)
                            .offset(y: 8)
                            .bold()
                        
                        
                        //                    DatePicker("", selection: Binding(get: {
                        //                        limitDate
                        //                    }, set: { (newVal) in
                        //                        limitDate = newVal
                        //                        age = calcAge()
                        ////                        limitDate = calcLimitDate()
                        //                    }) ,displayedComponents: .date)
                    }
                    //                .frame(height: 40)
                    //                .frame(height: 40)
                    //                .background(.red)
                    
                    
                }
                .frame(height: 30)
                .font(.system(size: 12))
                .foregroundStyle(.gray)
                .labelsHidden()
                .padding()
                
                
//                Spacer()
                
                
                
                
            }
            
            
            .multilineTextAlignment(.center)
            .navigationBarTitleDisplayMode(.inline)
//            .navigationTitle("Dreamer")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image("dreamer_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(3)
//                            .padding(.vertical, 5)
                        
                        Text("Dreamer")
                            .font(.title)
                
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 15)
                    
                  
                }
            }
            
        }
            
            
            
//            .navigationBarItems(leading: HStack {
//                Spacer()
//                Image("dreamer_icon")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .padding(.vertical, 5)
//                Text("Dreamer")
//                Spacer()
//            })
//            .toolbar {
//                Image("dreamer_icon")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .padding(.vertical, 5)
//            }
//            .navigationTitle("Dreamer")
//            .navigationBarTitleDisplayMode(.inline)
            
            
        
 

      

    }
}

#Preview {
    DreamView()
}
