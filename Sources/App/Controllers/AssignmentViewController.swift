import Foundation
import Vapor
import HTTP
import FluentProvider
import LeafProvider

class AssignmentViewController {

    func addRoutes(drop:Droplet)  {
        let admin = drop.grouped("admin","assignments")
        admin.get(handler:indexView)
        admin.get(Assignment.parameter,"vocables",handler:showVocables)
        admin.post(Assignment.parameter,"vocables",handler:addVocable)
        admin.post(Assignment.parameter,"vocables",Vocable.parameter,handler:deleteVocable)
        admin.post(handler:addAssignment)
        admin.post(Assignment.parameter, handler:deleteAssignment)
    }
    
    func indexView(request:Request) throws -> ResponseRepresentable {
        let assignments = try Assignment.all()
        
        let parameters = try Node(node:[
            "assignments":assignments.makeNode(in: ObjectContext(["inWeb":true]))
        ])
                
        return try drop.view.make("assignments",parameters)
    }
    
    func addAssignment(request:Request) throws -> ResponseRepresentable {
        guard let name = request.data["name"]?.string else {
            throw Abort.badRequest
        }
        var dueDate:Date? = nil
        if let dueDateString = request.data["dueDate"]?.string {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dueDate = dateFormatter.date(from: dueDateString)
        }
        
        let assignment = Assignment(name:name, dueDate:dueDate)
        try assignment.save()
        
        return Response(redirect: "/admin/assignments")        
    }
    
    func deleteAssignment(request:Request) throws -> ResponseRepresentable {
        let assignment = try request.parameters.next(Assignment.self)
        try assignment.delete()
        return Response(redirect: "/admin/assignments")
    }    
    
    func showVocables(request:Request) throws -> ResponseRepresentable {
        let assignment = try request.parameters.next(Assignment.self)
        let assignmentVocables = try assignment.vocables.all()
        let parameters = try Node(node:[
            "assignment":assignment.makeNode(in: nil),
            "vocables":assignmentVocables.makeNode(in: nil)
        ])
        return try drop.view.make("vocables",parameters)
    }
    
    func addVocable(request:Request) throws -> ResponseRepresentable {
        guard let swedish = request.data["swedish"]?.string, let english = request.data["english"]?.string else {
            throw Abort.badRequest
        }
        
        let assignment = try request.parameters.next(Assignment.self)
        let vocable = Vocable(assignmentId: assignment.id!, swedish: swedish, english: english)
        try vocable.save()
        return Response(redirect: "vocables")
    }
    
    func deleteVocable(request:Request) throws -> ResponseRepresentable {
        let vocable = try request.parameters.next(Vocable.self)
        try vocable.delete()
        return try showVocables(request:request)
    }
}
