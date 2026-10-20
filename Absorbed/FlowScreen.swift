//
//  FlowScreen.swift
//  Absorbed
//
//  Created by forest on 2024/04/02.
//

import SwiftUI
import SwiftData

struct FlowScreen: View {
    
    @AppStorage(KeyString.age.rawValue) var age = 30
    @AppStorage(KeyString.dreamLimitStr.rawValue) var dreamLimitStr = dateToString(date: Calendar.current.date(byAdding: .year, value: 30, to: stringToDate(dateValue: "2000/01/01", format: dateFormatStr))!)
    @AppStorage(KeyString.nowAge.rawValue) var nowAge = 24
    

    
    var body: some View {
        

        VStack(spacing: 0) {

            
            VStack(spacing: 5) {

                Capsule()
                    .frame(width: 200, height: 40)
                    .foregroundColor(.cyan)
                    .padding(.horizontal)
                    .overlay {
                        Text("ゴール")
                            .font(.system(size: 24).bold())
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                Text("\(dreamLimitStr)（\(age)歳）")
                    .foregroundStyle(.cyan)
                    .bold()
                
            }
            .padding(.bottom, 10)
            
            FLowView(spanString: spanString(toDateString: dreamLimitStr))
//                .background(.red)
            
       
            
            VStack(spacing: 5) {
                
                Text("\(dateToString(date: Date(), format: dateFormatStr))（\(nowAge)歳）")
                    .foregroundStyle(.black)
                    .bold()

                Capsule()
                    .frame(width: 200, height: 40)
                    .foregroundColor(.white)
                    .padding(.horizontal)
//                    .stroke(color: .black)
                    .stroke(color: .black, width: 1.5)
                    .overlay {
                        Text("今")
                            .font(.system(size: 24).bold())
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
            }
            .padding(.top, 10)

        }
        .padding(.vertical, 20)

        
    }
}



struct FLowView: View  {
    
    var spanString : String
    
    @Environment(\.modelContext) var modelContext

    @Query private var dislikes: [Dislike]
    
    // item
    @Query private var items: [Item]
    
    let grids = [GridItem(.fixed(50), spacing: 10, alignment: .center)]
    @State var continuingItems : [Item] = []
    @State var flowItems : [Item] = []
    
    func getContinuingItems() -> [Item] {
        return items.compactMap { item in
            return item.continuing == true ? item : nil
        }
    }
    
//    func getFlowItems() -> [Item] {
//        return items.compactMap { item in
//            return item.stepNumber == 1 ? item : nil
//        }
//    }
//    
  
    
    func getFlowItems() -> [Item] {
        return items.compactMap { item in
            return (item.stepNumber == 1 && !item.continuing) ? item : nil
        }
    }

    
    let hRatio = 0.8
    let rectSize : CGFloat = 50
    let flowRectSize : CGFloat = 120
    

    
//    @State var letters: [String] = ["A", "B", "C", "D", "E","A", "B", "C", "D", "E","A", "B", "C", "D", "E"]
//    @State var letters: [String] = ["A", "B", "C"]
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                HStack(alignment: .center, spacing: 0) {
       
                    
                    Spacer()
                    
                    ScrollView {
                        ZStack {
                            LazyVGrid(columns:grids, spacing: 10) {
                                ForEach(dislikes) { item in
                                    Rectangle()
                                        .frame(width: rectSize, height: rectSize)
                                        .foregroundStyle(Color("dislike_rect"))
                                        .opacity(0.9)
                                        .overlay {
                                            Text(item.title)
                                                .foregroundStyle(.white)
                                            
                                                .font(Font.system(size: 14))
                                                .minimumScaleFactor(0.1)
                                                .padding(3)
                                                .bold()
                                        }
                                        .onTapGesture {
                                            
                                        }
                                }
                            }
                            .padding()
                        }
                        .frame(height: reader.size.height)
        
                    }
                    .frame(width: reader.size.width*0.18)
                    .frame(height: reader.size.height)
                    .background(
                        ZStack {
                            Text("やらないこと  やらないこと  やらないこと  やらないこと  やらないこと")
                                .frame(width: reader.size.height)
                                .rotationEffect(.degrees(-90))
                                .foregroundColor(Color("dislike_rect"))
                                .opacity(0.5)
                                .font(.system(size: 12))
                                .minimumScaleFactor(0.1)
                            
                            Color("dislike_rect").opacity(0.3)
                                .frame(width: reader.size.width*0.18)
                            
                            HStack {
                                Spacer()
                                Rectangle()
                                    .frame(width: 3, height: reader.size.height-6)
                                    .foregroundColor(.black)
                                    .padding(.trailing, 1)
                                
                            }
                            .frame(width: reader.size.width*0.18)
                        }
                    )
  
            
                    ScrollView {
                        
                        ZStack {
                            LazyVGrid(columns:grids, spacing: 10) {
                                ForEach(flowItems) { item in
                                    Rectangle()
                                        .fill(colors[item.catIndex])
                                        .frame(width: flowRectSize, height: flowRectSize)
                                        .opacity(0.9)
                                        .overlay {
                                            Text(item.title)
                                                .foregroundStyle(.white)
                                                .font(Font.system(size: 24).bold())
                                                .minimumScaleFactor(0.1)
                                                .multilineTextAlignment(.center)
                                                .padding(4)
                                        }
                                }
                            }
                            .padding()
                        }
                        .frame(height: reader.size.height)
//                        .background(.red)
                    }
                    .frame(width: reader.size.width*0.5)
                    .frame(height: reader.size.height)
                    .background(
                        ZStack {
                            Image("arrow")
                                .resizable()
                                .frame(width: 40)
                                .frame(height: reader.size.height)
                                .zIndex(10)
                            Color.pink.opacity(0.1)
                            HStack {
                                Text("残り")
                                    .padding(.horizontal, 11)
                                    .padding(.vertical, 2)
                                    .background(.pink)
                                    .font(.system(size: 14))
                                    .opacity(0.8)
                                    .foregroundColor(.white)
                                    .cornerRadius(14)
                             
                                    
                                Text(spanString)
                             
//                                    .foregroundColor(.pink)
                            }
                            .frame(height: reader.size.height)
                            .foregroundColor(.pink)
                            .rotationEffect(.degrees(-90))
                            .offset(x: reader.size.width*0.2)
                     
                        }
                    )
                    
                    
                    ScrollView {
                        Spacer()
                        ZStack {
                            LazyVGrid(columns:grids, spacing: 10) {
                                ForEach(continuingItems) { item in
                                    ZStack {
                                        VStack {
                                        }
                                        .frame(width: rectSize, height: rectSize)
                                        .background(
                                            Image("pat_5").resizable(
                                                resizingMode: .tile
                                            )
                                            .opacity(1)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: continuingCornerRadius, style: .continuous))
                                        .position(CGPoint(x: rectSize/2, y: rectSize/2))
                                        .zIndex(100)
                                        .overlay {
                                            Text(item.title)
                                                .foregroundStyle(colorForIndex(item.catIndex))
                                                .font(Font.system(size: 14))
                                                .minimumScaleFactor(0.1)
                                                .padding(3)
                                                .bold()
                                                .stroke(color: .white, width: 0.5)
                                            
                                        }
                                        
                                        RoundedRectangle(cornerRadius: continuingCornerRadius)
                                            .frame(width: rectSize)
                                            .foregroundStyle(colorForIndex(item.catIndex).opacity(0.6))
                                        
                                            .blendMode(.multiply)
                                            .onTapGesture {
                                                
                                            }
                                    }
                                }
                            }
                            .padding()
                        }
                        .frame(height: reader.size.height)
                    }
                    .frame(width: reader.size.width*0.18)
                    .frame(height: reader.size.height)
                    .background(
                        ZStack {
                            Text("継続して行うこと  継続して行うこと  継続して行うこと  継続して行うこと")
                                .frame(width: reader.size.height)
                                .rotationEffect(.degrees(-90))
                                .foregroundColor(Color("continuing_rect"))
                                .opacity(0.5)
                                .font(.system(size: 12))
                                .minimumScaleFactor(0.1)
                            
                            Color("continuing_rect").opacity(0.1)
                                .frame(width: reader.size.width*0.18)
                        }
                    )

                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                continuingItems = getContinuingItems()
                flowItems = getFlowItems()
            }

        }
 
    }
}







#Preview {
    FlowScreen()
}
