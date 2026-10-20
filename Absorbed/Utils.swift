//
//  Utils.swift
//  Immersion
//
//  Created by forest on 2024/02/05.
//

import SwiftUI
import SwiftData

struct Utils: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    Utils()
}

func aColor(category: Category) -> Color {
    return colors.count > category.index ? colors[category.index] : .gray
}

struct CaptionView: View {
    var str : String
    var body: some View {
        Text(str)
            .padding(.horizontal, 12)
            .padding(.vertical, 3)
            .font(.system(size: 12))
            .foregroundStyle(.gray)
//            .background(.gray.opacity(0.8))
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 7)
                    .stroke(.gray, lineWidth: 1)
              
                
            }
        
  
    }
}

//func fetchTodayItems() -> [String] { //-> [Item] {
//    
//    
//    @Environment(\.modelContext) var modelContext
// 
//    
//    var descriptor = FetchDescriptor<Item>()
//    var strs = [String]()
//    //        let tripName = trip.name
//    descriptor.predicate = #Predicate { item in
//        item.stepNumber == 1
//    }
//    if let filteredList = try? modelContext.fetch(descriptor) {
//        for i in filteredList {
//            //                str += " \(i.title)"
//            strs.append(i.title)
//        }
//    }
//    
//    print(strs)
//    
//    
//    return strs
//    //        return filteredList!
//}
