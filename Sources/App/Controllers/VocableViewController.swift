

import Foundation
import Vapor
import HTTP

class VocableViewController {

    func addRoutes(drop:Droplet)  {
        let admin = drop.grouped("admin")
//        admin.get("vocables",handler:indexView)
//        admin.post("vocables",handler:addVocable)
//        admin.post("vocables", Vocable.self, handler:deleteVocable)
    }
    
    func indexView(request:Request) throws -> ResponseRepresentable {
        let assignments = try Assignment.all()
        let vocables = try Vocable.all()
        var assignmentMap:[String:Node] = [:]
        for assignment in assignments {
//            let assignmentVocables = try vocables.filter({$0.assignmentId == assignment.id?.string}).makeNode() //map({$0.makeNode()})
            let assignmentVocables = try assignment.vocables()
            assignmentMap[assignment.id!.string!] = try assignmentVocables.makeNode()
        }
        
        
        let parameters = try Node(node:[
            "assignments":assignments.makeNode(),
            "assignmentMap":assignmentMap.makeNode()
        ])
        
        
        return try drop.view.make("index",parameters)
    }
    
   
}
