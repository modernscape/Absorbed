//
//  Migration_Step.swift
//  Absorbed
//
//  Created by forest on 2024/04/07.
//

import Foundation
import SwiftData



/* ----------------------------------------------------------------------------
 MARK: - Step
 ------------------------------------------------------------------------------*/
// 現在のバージョン
typealias Step = StepSchemaV2.Step

// スキーム
struct StepSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version = Schema.Version(1, 0, 0)
    static var models: [any PersistentModel.Type] {
        [Step.self]
    }
    
    @Model
    class Step : Identifiable, Equatable {
        
        var id = UUID()
        var index : Int
        var date : Date
        var span : Date
        
        init(id: UUID = UUID(), index: Int, date: Date, span: Date) {
            self.id = id
            self.index = index
            self.date = date
            self.span = span
        }
    }
}

struct StepSchemaV2: VersionedSchema {
    static var versionIdentifier: Schema.Version = Schema.Version(2, 0, 0)
    static var models: [any PersistentModel.Type] {
        [Step.self]
    }
    
    @Model
    class Step : Identifiable, Equatable {
        
        var id = UUID()
        var index : Int
        var date : Date
        var span : Date
        var spanStr : String?
        
        init(id: UUID = UUID(), index: Int, date: Date, span: Date, spanStr: String = "") {
            self.id = id
            self.index = index
            self.date = date
            self.span = span
            self.spanStr = spanStr
        }
    }
}

// マイグレーションプラン
enum StepMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        // バージョンの順番に配置することで、SwiftDataが順序正しくバージョン間を移行できるようにする
        [
            StepSchemaV1.self,
            StepSchemaV2.self,

        ]
    }
    
    static var stages: [MigrationStage] {
        [
            migrateV1toV2,
//            migrateV2toV3,
//            migrateV3toV4
        ]
    }
    
    // 簡易的なマイグレーション。V1toV2の時は、一意制約をつけただけなので、lightweightで十分。
    //    static let migrateV1toV2: MigrationStage = MigrationStage.lightweight(
    //        fromVersion: ItemSchemaV1.self,
    //        toVersion: ItemSchemaV2.self
    //    )
    
    
    static let migrateV1toV2 = MigrationStage.custom(
        fromVersion: StepSchemaV1.self,
        toVersion: StepSchemaV2.self,
        willMigrate: nil
    ) { context in
        let items = try? context.fetch(FetchDescriptor<StepSchemaV2.Step>())
        
        items?.forEach { item in
            item.spanStr = ""
//            item.benefitList = "それをやることの快楽"
//            item.benefitListPosX = 0
//            item.benefitListPosY = 0
//            item.index = 0
        }
        
        try? context.save()
    }
    
 
    
}
