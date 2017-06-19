import Vapor
import VaporMySQL
import HTTP

/*
 To revert database :  vapor run prepare --revert
 
 */


let drop = Droplet()
try drop.addProvider(VaporMySQL.Provider)
drop.preparations += Vocable.self
drop.preparations += Assignment.self


let vocableController = VocableController()
vocableController.addRoutes(drop:drop)
//drop.resource("vocables", vocableController)

let assignmentController = AssignmentController()
assignmentController.addRoutes(drop:drop)

let assignmentViewController = AssignmentViewController()
assignmentViewController.addRoutes(drop: drop)

/*drop.get("test") {request in
    let input:Valid<OnlyAlphanumeric> = try request.data["input"].validated()
    return "test \(input)"
}*/

drop.run()

