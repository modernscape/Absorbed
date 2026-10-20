//
//  Migration.swift
//  Absorbed
//
//  Created by bird on 2024/03/06.
//

import Foundation
import SwiftData

/* ----------------------------------------------------------------------------
 MARK: - Item
 ------------------------------------------------------------------------------*/
// Itemが常に最新バージョンを指すように型エイリアスを追加する
typealias Item = ItemSchemaV5.Item

struct ItemSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version = Schema.Version(1, 0, 0)
    static var models: [any PersistentModel.Type] {
        [Item.self]
    }
    
    @Model
    final class Item : Identifiable {
        
        let id = UUID()
        var title: String
        var posX : CGFloat
        var posY : CGFloat
        var length: CGFloat
        var stepNumber: Int // 0:Stepに属さない
        var dislike : Bool
        var created : Bool
        var isDone : Bool
        var hasPhase : Bool
        var continuing : Bool
        var catIndex : Int
        var phases : [Phase]
        
        init(title: String = "", posX: CGFloat = 90, posY: CGFloat = 90, length: CGFloat = 50, stepNumber: Int = 0, dislike: Bool = false, created: Bool = false, isDone: Bool = false, hasPhase: Bool = false, continuing: Bool = false, catIndex: Int = 0, phases: [Phase] = []) {
            self.title = title
            self.posX = posX
            self.posY = posY
            self.length = length
            self.stepNumber = stepNumber
            self.dislike = dislike
            self.created = created
            self.isDone = isDone
            self.hasPhase = hasPhase
            self.continuing = continuing
            self.catIndex = catIndex
            self.phases = phases
        }
    }
}


struct ItemSchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)
    static var models: [any PersistentModel.Type] {
        [Item.self]
    }
    // クラスの変更の際に記述
    @Model
    final class Item : Identifiable {
        
        let id = UUID()
        var title: String
        var posX : CGFloat
        var posY : CGFloat
        var length: CGFloat
        var stepNumber: Int // 0:Stepに属さない
        var dislike : Bool
        var created : Bool
        var isDone : Bool
        var hasPhase : Bool
        var continuing : Bool
        var catIndex : Int
        var phases : [Phase]
        var benefitList : String?
        var benefitListPosX : CGFloat?
        var benefitListPosY : CGFloat?
        var index : Int?
        
        init(title: String = "", posX: CGFloat = 90, posY: CGFloat = 90, length: CGFloat = 50, stepNumber: Int = 0, dislike: Bool = false, created: Bool = false, isDone: Bool = false, hasPhase: Bool = false, continuing: Bool = false, catIndex: Int = 0, phases: [Phase] = [], benefitList: String? = "それをやることの快楽", benefitListPosX: CGFloat? = nil, benefitListPosY: CGFloat? = nil, index : Int = 0) {
            
            self.title = title
            self.posX = posX
            self.posY = posY
            self.length = length
            self.stepNumber = stepNumber
            self.dislike = dislike
            self.created = created
            self.isDone = isDone
            self.hasPhase = hasPhase
            self.continuing = continuing
            self.catIndex = catIndex
            self.phases = phases
            self.benefitList = benefitList
            self.benefitListPosX = benefitListPosX
            self.benefitListPosY = benefitListPosY
            self.index = index
        }
    }
}


struct ItemSchemaV3: VersionedSchema {
    static var versionIdentifier = Schema.Version(3, 0, 0)
    static var models: [any PersistentModel.Type] {
        [Item.self]
    }
    // クラスの変更の際に記述
    @Model
    final class Item : Identifiable {
        
        let id = UUID()
        var title: String
        var posX : CGFloat
        var posY : CGFloat
        var length: CGFloat
        var stepNumber: Int // 0:Stepに属さない
        var dislike : Bool
        var created : Bool
        var isDone : Bool
        var hasPhase : Bool
        var continuing : Bool
        var catIndex : Int
        var phases : [Phase]
        var benefitList : String?
        var benefitListPosX : CGFloat?
        var benefitListPosY : CGFloat?
        var index : Int?
        var count : Int?
        
        init(title: String = "", posX: CGFloat = 90, posY: CGFloat = 90, length: CGFloat = 50, stepNumber: Int = 0, dislike: Bool = false, created: Bool = false, isDone: Bool = false, hasPhase: Bool = false, continuing: Bool = false, catIndex: Int = 0, phases: [Phase] = [], benefitList: String? = "それをやることの快楽", benefitListPosX: CGFloat? = nil, benefitListPosY: CGFloat? = nil, index : Int? = 0, count: Int? = 0) {
            
            self.title = title
            self.posX = posX
            self.posY = posY
            self.length = length
            self.stepNumber = stepNumber
            self.dislike = dislike
            self.created = created
            self.isDone = isDone
            self.hasPhase = hasPhase
            self.continuing = continuing
            self.catIndex = catIndex
            self.phases = phases
            self.benefitList = benefitList
            self.benefitListPosX = benefitListPosX
            self.benefitListPosY = benefitListPosY
            self.index = index
            self.count = count
        }
    }
}


struct ItemSchemaV4: VersionedSchema {
    static var versionIdentifier = Schema.Version(4, 0, 0)
    static var models: [any PersistentModel.Type] {
        [Item.self]
    }
    // クラスの変更の際に記述
    @Model
    final class Item : Identifiable {
        
        let id = UUID()
        var title: String
        var posX : CGFloat
        var posY : CGFloat
        var length: CGFloat
        var stepNumber: Int // 0:Stepに属さない
        var dislike : Bool
        var created : Bool
        var isDone : Bool
        var hasPhase : Bool
        var continuing : Bool
        var catIndex : Int
        var phases : [Phase]
        var benefitList : String?
        var benefitListPosX : CGFloat?
        var benefitListPosY : CGFloat?
        var index : Int?
        var count : Int?
        var goalCount : Int? // 目標数
        var todayCount : Int? // 今日の成果
        
        init(title: String = "", posX: CGFloat = 90, posY: CGFloat = 90, length: CGFloat = 50, stepNumber: Int = 0, dislike: Bool = false, created: Bool = false, isDone: Bool = false, hasPhase: Bool = false, continuing: Bool = false, catIndex: Int = 0, phases: [Phase] = [], benefitList: String? = "それをやることの快楽", benefitListPosX: CGFloat? = nil, benefitListPosY: CGFloat? = nil, index : Int? = 0, count: Int? = 0, goalCount: Int? = 100, todayCount: Int? = 0) {
            
            self.title = title
            self.posX = posX
            self.posY = posY
            self.length = length
            self.stepNumber = stepNumber
            self.dislike = dislike
            self.created = created
            self.isDone = isDone
            self.hasPhase = hasPhase
            self.continuing = continuing
            self.catIndex = catIndex
            self.phases = phases
            self.benefitList = benefitList
            self.benefitListPosX = benefitListPosX
            self.benefitListPosY = benefitListPosY
            self.index = index
            self.count = count
            self.goalCount = goalCount
            self.todayCount = todayCount
        }
    }
}





struct ItemSchemaV5: VersionedSchema {
    static var versionIdentifier = Schema.Version(5, 0, 0)
    static var models: [any PersistentModel.Type] {
        [Item.self]
    }
    // クラスの変更の際に記述
    @Model
    final class Item : Identifiable {
        
        let id = UUID()
        var title: String
        var posX : CGFloat
        var posY : CGFloat
        var length: CGFloat
        var stepNumber: Int // 0:Stepに属さない
        var dislike : Bool
        var created : Bool
        var isDone : Bool
        var hasPhase : Bool
        var continuing : Bool
        var catIndex : Int
        var phases : [Phase]
        var benefitList : String?
        var benefitListPosX : CGFloat?
        var benefitListPosY : CGFloat?
        var index : Int?
        var count : Int?
        var goalCount : Int?
        var todayCount : Int?
        //var limitDate : Date? // new  Step画面はlimit順に表示  limitがnilのものは非表示
        var inImmersion : Bool? // new 没入どうか  true : 没入 （item3つまで）、false : 没入でない
        
        init(title: String = "", posX: CGFloat = 90, posY: CGFloat = 90, length: CGFloat = 50, stepNumber: Int = 0, dislike: Bool = false, created: Bool = false, isDone: Bool = false, hasPhase: Bool = false, continuing: Bool = false, catIndex: Int = 0, phases: [Phase] = [], benefitList: String? = "それをやることの快楽", benefitListPosX: CGFloat? = nil, benefitListPosY: CGFloat? = nil, index : Int? = 0, count: Int? = 0, goalCount: Int? = 100, todayCount: Int? = 0, inImmersion : Bool? = false) {
            
            self.title = title
            self.posX = posX
            self.posY = posY
            self.length = length
            self.stepNumber = stepNumber
            self.dislike = dislike
            self.created = created
            self.isDone = isDone
            self.hasPhase = hasPhase
            self.continuing = continuing
            self.catIndex = catIndex
            self.phases = phases
            self.benefitList = benefitList
            self.benefitListPosX = benefitListPosX
            self.benefitListPosY = benefitListPosY
            self.index = index
            self.count = count
            self.goalCount = goalCount
            self.todayCount = todayCount
            //self.limitDate = limitDate
            self.inImmersion = inImmersion
        }
    }
}







// クラスの変更の際に記述
//    @Model
//    final class Item {
//        @Attribute(.unique) var timestamp: Date
//        // メッセージ 写真カラムを追加。
//        var message: String = ""
//        var image: String = ""
//        init(timestamp: Date, message: String = "", image: String = "") {
//            self.timestamp = timestamp
//            self.message = message
//            self.image = image
//        }
//    }




// マイグレーションプランを作成する。
// 一つの特定のバージョンから別のバージョンに移動する方法を定義する
enum ItemMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        // バージョンの順番に配置することで、SwiftDataが順序正しくバージョン間を移行できるようにする
        [
            ItemSchemaV1.self,
            ItemSchemaV2.self,
            ItemSchemaV3.self,
            ItemSchemaV4.self,
            ItemSchemaV5.self,
        ]
    }
    
    static var stages: [MigrationStage] {
        [
            migrateV1toV2,
            migrateV2toV3,
            migrateV3toV4,
            migrateV4toV5,
        ]
    }
    
    // 簡易的なマイグレーション。V1toV2の時は、一意制約をつけただけなので、lightweightで十分。
//    static let migrateV1toV2: MigrationStage = MigrationStage.lightweight(
//        fromVersion: ItemSchemaV1.self,
//        toVersion: ItemSchemaV2.self
//    )
    
    
    static let migrateV1toV2 = MigrationStage.custom(
        fromVersion: ItemSchemaV1.self,
        toVersion: ItemSchemaV2.self,
        willMigrate: nil
    ) { context in
        let items = try? context.fetch(FetchDescriptor<ItemSchemaV2.Item>())
        
        items?.forEach { item in
            item.benefitList = "それをやることの快楽"
            item.benefitListPosX = 0
            item.benefitListPosY = 0
            item.index = 0
        }
        
        try? context.save()
    }
    
    // カスタムマイグレーション。V2toV3時は messageとitemが追加されているため、旧バージョンの際の扱いを定義する。
    static let migrateV2toV3 = MigrationStage.custom(
        fromVersion: ItemSchemaV2.self,
        toVersion: ItemSchemaV3.self,
        willMigrate: nil
    ) { context in
        let items = try? context.fetch(FetchDescriptor<ItemSchemaV3.Item>())
        
        items?.forEach { item in
            item.count = 0
        }
        
        try? context.save()
    }
    
    static let migrateV3toV4 = MigrationStage.custom(
        fromVersion: ItemSchemaV3.self,
        toVersion: ItemSchemaV4.self,
        willMigrate: nil
    ) { context in
        let items = try? context.fetch(FetchDescriptor<ItemSchemaV4.Item>())
        
        items?.forEach { item in
            item.goalCount = 0
        }
        
        try? context.save()
    }
    
    static let migrateV4toV5 = MigrationStage.custom(
        fromVersion: ItemSchemaV4.self,
        toVersion: ItemSchemaV5.self,
        willMigrate: nil
    ) { context in
        let items = try? context.fetch(FetchDescriptor<ItemSchemaV5.Item>())
        
        items?.forEach { item in
//            item.limitDate = nil
            item.inImmersion = false
        }
        
        try? context.save()
    }
    

}



/* ----------------------------------------------------------------------------
 MARK: - Phase
 ------------------------------------------------------------------------------*/
typealias Phase = PhaseSchemaV4.Phase

let defaultAchievements = [false, false, false, false, false, false, false]
let defaultAchievements_num = [0, 0, 0, 0, 0, 0, 0]

struct PhaseSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version = Schema.Version(1, 0, 0)
    static var models: [any PersistentModel.Type] {
        [Phase.self]
    }
    
    @Model
    final class Phase {
        var item : Item
        var index : Int
        var title : String
        var created : Bool
        
        init(item: Item, index: Int, title: String, created: Bool = false) {
            self.item = item
            self.index = index
            self.title = title
            self.created = created
        }
    }
}


struct PhaseSchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)
    static var models: [any PersistentModel.Type] {
        [Phase.self]
    }
    // クラスの変更の際に記述
    @Model
    final class Phase {
        var item : Item
        var index : Int
        var title : String
        var created : Bool
        var isDone : Bool? // 追加
        
        init(item: Item, index: Int, title: String, created: Bool = false, isDone : Bool = false) {
            self.item = item
            self.index = index
            self.title = title
            self.created = created
            self.isDone = isDone
        }
    }
}


struct PhaseSchemaV3: VersionedSchema {
    static var versionIdentifier = Schema.Version(3, 0, 0)
    static var models: [any PersistentModel.Type] {
        [Phase.self]
    }
    // クラスの変更の際に記述
    @Model
    final class Phase {
        var item : Item
        var index : Int
        var title : String
        var created : Bool
        var isDone : Bool?
        var achievements : [Bool]? // 追加
        
        init(item: Item, index: Int, title: String, created: Bool = false, isDone : Bool = false, achievements : [Bool]? = defaultAchievements) {
            self.item = item
            self.index = index
            self.title = title
            self.created = created
            self.isDone = isDone
            self.achievements = achievements
        }
    }
}

struct PhaseSchemaV4: VersionedSchema {
    static var versionIdentifier = Schema.Version(4, 0, 0)
    static var models: [any PersistentModel.Type] {
        [Phase.self]
    }
    // クラスの変更の際に記述
    @Model
    final class Phase {
        var item : Item
        var index : Int
        var title : String
        var created : Bool
        var isDone : Bool?
        var achievements : [Bool]? // 使用しない
        var achievements_num : [Int]? // 追加
        
        init(item: Item, index: Int, title: String, created: Bool = false, isDone : Bool = false, achievements_num : [Int]? = defaultAchievements_num) {
            self.item = item
            self.index = index
            self.title = title
            self.created = created
            self.isDone = isDone
            self.achievements_num = achievements_num
        }
    }
}



enum PhaseMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        // バージョンの順番に配置することで、SwiftDataが順序正しくバージョン間を移行できるようにする
        [
            PhaseSchemaV1.self,
            PhaseSchemaV2.self,
            PhaseSchemaV3.self,
            PhaseSchemaV4.self,
        ]
    }
    
    static var stages: [MigrationStage] {
        [
            migrateV1toV2,
            migrateV2toV3,
            migrateV3toV4,
        ]
    }
    // 簡易的なマイグレーション。V1toV2の時は、一意制約をつけただけなので、lightweightで十分。
//    static let migrateV1toV2: MigrationStage = MigrationStage.lightweight(
//        fromVersion: PhaseSchemaV1.self,
//        toVersion: PhaseSchemaV2.self
//    )
    // カスタムマイグレーション。V2toV3時は messageとitemが追加されているため、旧バージョンの際の扱いを定義する。
    static let migrateV1toV2 = MigrationStage.custom(
        fromVersion: PhaseSchemaV1.self,
        toVersion: PhaseSchemaV2.self,
        willMigrate: nil
    ) { context in
        let items = try? context.fetch(FetchDescriptor<PhaseSchemaV2.Phase>())
        
        items?.forEach { item in
            item.isDone = false
        }
        
        try? context.save()
    }
    
    
    static let migrateV2toV3 = MigrationStage.custom(
        fromVersion: PhaseSchemaV2.self,
        toVersion: PhaseSchemaV3.self,
        willMigrate: nil
    ) { context in
        let items = try? context.fetch(FetchDescriptor<PhaseSchemaV3.Phase>())
        
        items?.forEach { item in
            item.achievements = defaultAchievements
        }
        
        try? context.save()
    }
    
    
    static let migrateV3toV4 = MigrationStage.custom(
        fromVersion: PhaseSchemaV3.self,
        toVersion: PhaseSchemaV4.self,
        willMigrate: nil
    ) { context in
        let items = try? context.fetch(FetchDescriptor<PhaseSchemaV4.Phase>())
        
        items?.forEach { item in
            item.achievements_num = defaultAchievements_num
        }
        
        try? context.save()
    }
    
    
    
}
