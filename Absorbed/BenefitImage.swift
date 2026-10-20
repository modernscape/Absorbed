//
//  BenefitImage.swift
//  Absorbed
//
//  Created by forest on 2024/03/30.
//

import Foundation
import SwiftData
import UIKit
import PhotosUI
import SwiftUI



/* ----------------------------------------------------------------------------
 MARK: - BenefitImage
 ------------------------------------------------------------------------------*/
// 現在のバージョン
typealias BenefitImage = BenefitImageSchemaV1.BenefitImage


struct BenefitImageSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version = Schema.Version(1, 0, 0)
    static var models: [any PersistentModel.Type] {
        [BenefitImage.self]
    }
    
    @Model
    final class BenefitImage : Identifiable {
        
        let id = UUID()
        var posX : CGFloat
        var posY : CGFloat
        var immgData : Data
        var new : Bool?
                
        init(posX: CGFloat = 100, posY: CGFloat = 100, immgData: Data = UIImage(named: "imgData_default")!.pngData()!, new: Bool = true) {
            self.posX = posX
            self.posY = posY
            self.immgData = immgData
            self.new = new
        }
    }
}


struct BenefitImageSchemaV2: VersionedSchema {
    static var versionIdentifier: Schema.Version = Schema.Version(1, 0, 0)
    static var models: [any PersistentModel.Type] {
        [BenefitImage.self]
    }
    
    @Model
    final class BenefitImage : Identifiable {
        
        let id = UUID()
        var title: String
        var posX : CGFloat
        var posY : CGFloat
        var immgData : Data
        
        init(title: String, posX: CGFloat, posY: CGFloat, immgData: Data = UIImage(named: "imgData_default")!.pngData()!) {
            
            self.title = title
            self.posX = posX
            self.posY = posY
            self.immgData = immgData
        }
    }
}


struct BenefitImageSchemaV3: VersionedSchema {
    static var versionIdentifier: Schema.Version = Schema.Version(1, 0, 0)
    static var models: [any PersistentModel.Type] {
        [BenefitImage.self]
    }
    
    @Model
    final class BenefitImage : Identifiable {
        
        let id = UUID()
        var title: String
        var posX : CGFloat
        var posY : CGFloat
        var immgData : Data
        
        init(title: String, posX: CGFloat, posY: CGFloat, immgData: Data = UIImage(named: "imgData_default")!.pngData()!) {
            
            self.title = title
            self.posX = posX
            self.posY = posY
            self.immgData = immgData
        }
    }
}


// マイグレーションプランを作成する。
// 一つの特定のバージョンから別のバージョンに移動する方法を定義する
enum BenefitImageMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        // バージョンの順番に配置することで、SwiftDataが順序正しくバージョン間を移行できるようにする
        [BenefitImageSchemaV1.self, BenefitImageSchemaV2.self]
    }
    
    static var stages: [MigrationStage] {
        [migrateV1toV2, migrateV2toV3]
    }
    
    // 簡易的なマイグレーション。V1toV2の時は、一意制約をつけただけなので、lightweightで十分。
    //    static let migrateV1toV2: MigrationStage = MigrationStage.lightweight(
    //        fromVersion: ItemSchemaV1.self,
    //        toVersion: ItemSchemaV2.self
    //    )
    
    
    static let migrateV1toV2 = MigrationStage.custom(
        fromVersion: BenefitImageSchemaV1.self,
        toVersion: BenefitImageSchemaV2.self,
        willMigrate: nil
    ) { context in
        let items = try? context.fetch(FetchDescriptor<BenefitImageSchemaV2.BenefitImage>())
        
        items?.forEach { item in
//            item.benefitList = "それをやることの快楽"
//            item.benefitListPosX = 0
//            item.benefitListPosY = 0
        }
        
        try? context.save()
    }
    
    // カスタムマイグレーション。V2toV3時は messageとitemが追加されているため、旧バージョンの際の扱いを定義する。
    static let migrateV2toV3 = MigrationStage.custom(
        fromVersion: BenefitImageSchemaV2.self,
        toVersion: BenefitImageSchemaV3.self,
        willMigrate: nil
    ) { context in
        let items = try? context.fetch(FetchDescriptor<BenefitImageSchemaV3.BenefitImage>())
        
        items?.forEach { item in
//            item.colorIndex = 0
        }
        
        try? context.save()
    }
}





struct BenefitImageView: View {
    
    
    @Environment(\.modelContext) private var modelContext
    
    var benefitImage : BenefitImage
    
    @State var posDiff = CGPoint.zero
    @State var dragStart = false
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showingPhotosPicker: Bool = false
    
    @Binding var showBenefitImage : Bool
    @Binding var selectedBenefitImage : UIImage
    
    @AppStorage(KeyString.imgSizeIndex.rawValue) var imgSizeIndex : Int = 0
    
//    let length : CGFloat = 60
    
    func loadImageFromSelectedPhoto(photo: PhotosPickerItem?) async {
        if let data = try? await photo?.loadTransferable(type: Data.self) {
            withAnimation{
                benefitImage.immgData = data
                selectedBenefitImage = UIImage(data: data)!
                try! modelContext.save()
            }

        }
    }
    
    var drag: some Gesture {
        DragGesture()
        
            .onChanged { value in
                
                if !dragStart {
                    posDiff = CGPoint(x: value.startLocation.x - benefitImage.posX , y: value.startLocation.y - benefitImage.posY)
                    dragStart = true
                }
                
                benefitImage.posX =
                value.startLocation.x
                + value.translation.width
                - posDiff.x
                
                benefitImage.posY =
                value.startLocation.y
                + value.translation.height
                - posDiff.y
                
            }
        
            .onEnded { value in
                
                benefitImage.posX =
                value.startLocation.x
                + value.translation.width
                - posDiff.x
                
                benefitImage.posY =
                value.startLocation.y
                + value.translation.height
                - posDiff.y
                
                dragStart = false
            }
    }
    
    
  
    var body: some View {
        
        Menu {
       
//
//            Image(uiImage: UIImage(data: benefitImage.immgData)!)
//                .resizable()
//                .frame(width: 100)
            
            Button {
                showingPhotosPicker.toggle()
            } label: {
                Label("選択", systemImage: "photo.on.rectangle")
                
            }
     
            
            // delete
            Button(action: {
                withAnimation {
                    modelContext.delete(benefitImage)
                    showBenefitImage = false
                    selectedBenefitImage = UIImage()
            
                }
            }) {
                HStack {
                    Text("削除")
                    Image(systemName: "trash")
                }
          
            }
    
            
        } label: {
            Image(uiImage: UIImage(data: benefitImage.immgData) ?? UIImage())
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: imgSizes[imgSizeIndex], height: imgSizes[imgSizeIndex])
                .shadow(color: .gray, radius: 1.5)
         
        }
        .position(CGPoint(x: benefitImage.posX, y: benefitImage.posY))
        .gesture(drag)
        .photosPicker(isPresented: $showingPhotosPicker, selection: Binding(get: {
                selectedPhoto
        }, set: { (newVal) in
            Task { await loadImageFromSelectedPhoto(photo: newVal) }
        }), matching: .any(of: [.images, .screenshots, .livePhotos]))
        .onTapGesture {
            //
   
            withAnimation {
              
                
                if showBenefitImage == false {
                    showBenefitImage = true
                    selectedBenefitImage = UIImage(data: benefitImage.immgData)!
                } else if selectedBenefitImage != UIImage(data: benefitImage.immgData)! {
                    selectedBenefitImage = UIImage(data: benefitImage.immgData)!
                }
                
              
            }
        }
        .onAppear() {
//            showBenefitImage = false
            showingPhotosPicker = benefitImage.new ?? true
            benefitImage.new = false
            try! modelContext.save()
        }
    }
}




