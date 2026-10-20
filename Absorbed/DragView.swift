//
//  DragView.swift
//  Absorbed
//
//  Created by bird on 2024/03/14.
//

import SwiftUI

let cols = [Color("continuing_rect"), Color("color_2"), .orange, .yellow, .green]


class DragViewModel: ObservableObject {
    @Published var posX : Double = 0
    @Published var posY : Double = 0
}

struct DragView: View {
    
    @State var posDiff = CGPoint.zero
    @State var dragStart = false

    @ObservedObject var dragViewModel : DragViewModel
    var index : Int

    var drag: some Gesture {
        DragGesture()
        
            .onChanged { value in
                
                if !dragStart {
                    posDiff = CGPoint(x: value.startLocation.x - dragViewModel.posX , y: value.startLocation.y - dragViewModel.posY)
                    dragStart = true
                }
                
                dragViewModel.posX =
                value.startLocation.x
                + value.translation.width
                - posDiff.x
                
                dragViewModel.posY =
                value.startLocation.y
                + value.translation.height
                - posDiff.y
                
            }
            .onEnded { value in
                
                dragViewModel.posX =
                value.startLocation.x
                + value.translation.width
                - posDiff.x
                
                dragViewModel.posY =
                value.startLocation.y
                + value.translation.height
                - posDiff.y
                
                dragStart = false
            }
    }
    

    var body: some View {
        Text(String(format: "%.0f", dragViewModel.posX)+"\n"+String(format: "%.0f", dragViewModel.posY))
            .padding()
            .frame(width: 100, height: 100)
            .background(cols[index])
            .offset(x:dragViewModel.posX, y:dragViewModel.posY)
            .gesture(drag)
    }
}


struct DragScreen: View {
    
    var models: [DragViewModel] = []
//    let count = 3
    
    var body: some View {
        VStack {
            Button("リセット") {
                for m in models {
                    m.posX = 0
                    m.posY = 0
                }
            }
            
            Spacer()
            
            ZStack {
                ForEach(0..<models.count,  id: \.self) { index in
                    DragView(dragViewModel: models[index], index: index)
                }
            }
//            .frame(height: 500)
//            .background(.gray)
            
            Spacer()
          
       
        }
    
    }
}



#Preview {
    DragScreen(models: [DragViewModel(),
                        DragViewModel(),
                        DragViewModel(),
                        DragViewModel(),
                        DragViewModel(),
                       ]
    )
}
