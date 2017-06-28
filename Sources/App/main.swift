import Vapor
import MySQLProvider
import HTTP
import LeafProvider

/*
 To revert database :  vapor run --prepare --revert
 */

let config = try Config()
try config.addProvider(MySQLProvider.Provider.self)
config.preparations.append(Assignment.self)
config.preparations.append(Vocable.self)

try config.addProvider(LeafProvider.Provider.self)

let drop = try Droplet(config)

let vocableController = VocableController()
vocableController.addRoutes(drop:drop)

let assignmentController = AssignmentController()
assignmentController.addRoutes(drop:drop)

let assignmentViewController = AssignmentViewController()
assignmentViewController.addRoutes(drop: drop)

try drop.run()

