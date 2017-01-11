

import Foundation
import Vapor
import HTTP

class AssignmentViewController {

    func addRoutes(drop:Droplet)  {
        let admin = drop.grouped("admin","assignments")
        admin.get(handler:indexView)
        admin.get(Assignment.self,"vocables",handler:showVocables)
        admin.post(Assignment.self,"vocables",handler:addVocable)
        admin.post(Assignment.self,"vocables",Vocable.self,handler:deleteVocable)
        admin.post(handler:addAssignment)
        admin.post(Assignment.self, handler:deleteAssignment)
    }
    
    func indexView(request:Request) throws -> ResponseRepresentable {
        let assignments = try Assignment.all()
        
        let parameters = try Node(node:[
            "assignments":assignments.makeNode(context: ["inWeb":true])
        ])
                
        return try drop.view.make("assignments",parameters)
    }
    
    func addAssignment(request:Request) throws -> ResponseRepresentable {
        guard let name = request.data["name"]?.string else {
            throw Abort.badRequest
        }
        var assignment = Assignment(name:name)
        if let dueDateString = request.data["dueDate"]?.string {
            assignment.dueDateAsString = dueDateString
        }
        
        try assignment.save()
        
        return Response(redirect: "/admin/assignments")
        
    }
    
    func deleteAssignment(request:Request, assignment:Assignment) throws -> ResponseRepresentable {
        try assignment.delete()
        return Response(redirect: "/admin/assignments")
    }    
    
    func showVocables(request:Request, assignment:Assignment) throws -> ResponseRepresentable {
        let assignmentVocables = try assignment.vocables()
        let parameters = try Node(node:[
            "assignment":assignment.makeNode(),
            "vocables":assignmentVocables.makeNode()
        ])
        return try drop.view.make("vocables",parameters)
    }
    
    func addVocable(request:Request, assignment:Assignment) throws -> ResponseRepresentable {
        guard let swedish = request.data["swedish"]?.string, let english = request.data["english"]?.string else {
            throw Abort.badRequest
        }
        var vocable = Vocable(assignmentId: assignment.id, swedish: swedish, english: english)
        try vocable.save()
        
        return try showVocables(request:request, assignment:assignment)
        
    }
    
    func deleteVocable(request:Request,assignment:Assignment, vocable:Vocable) throws -> ResponseRepresentable {
        try vocable.delete()
        return try showVocables(request:request, assignment:assignment)
    }
    
    
    
}
