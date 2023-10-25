import ballerina/graphql;
import ballerinax/mongodb;


mongodb:ClientConfiguration mongoConfig = {
    uri: "mongodb://localhost:27017",
    username: "",
    password: "",
    db: "KPI"
};

service class Employee {
        private int id;
        private string Fname;
        private string Lname;
        private string Role; 
        private string JobTitle;

        function init(int id, string Fname, string Lname, string JobTitle, string Role) {
            self.id = id;
            self.Fname = Fname;
            self.Lname = Lname;
            self.JobTitle = JobTitle;
            self.Role = Role;
        }
        
        resource function get id() returns int {
            return self.id;
        }
        resource function get Fname() returns string {
            return self.Fname;
        }
        resource function get Lname() returns string {
            return self.Lname;
        }
        resource function get JobTitle() returns string {
            return self.JobTitle;
        }
        resource function get Role() returns string {
            return self.Role;
        }
        //remote 
}

service class HOD {
    private int id;
    private string Fname;
    private string Lname;


    function init(int id, string Fname, string Lname) {
        self.id = id;
        self.Fname = Fname;
        self.Lname = Lname;
    }
    resource function get id() returns int {
        return self.id;
    }
    resource function get Fname() returns string {
        return self.Fname;
    }
    resource function get Lname() returns string {
        return self.Lname;
    }

    //resource function 
}
service class Supervisor {
    private int id;
    private string Fname;
    private string Lname;

    function init(int id, string Fname, string Lname) {
        self.id = id;
        self.Fname = Fname;
        self.Lname = Lname;
    }
    resource function get id() returns int {
        return self.id;

    }
    resource function get Fname() returns string {
        return self.Fname;
    }
    resource function get Lname() returns string {
        return self.Lname;
    }
}




//Generating GrapHQL schema
service /graphql on new graphql:Listener(9000) {
    //Initialize the MongoDB client 
    mongodb:Client mongoClient = new(mongoConfig);
    resource function get greeting(string? name = "Key Performance Indicators System") returns string {
        if name is string{
            return "Welcome to the, " + name;
        }
        return "-----WELCOME USER---!";
    }

    resource function get EmployeeProfile(int id) returns Employee {
        //Createa MongoDB query to find a employee by ID.
        mongodb:Find findOp = new;
        findOp.filter = {"id":id};
        var EmployeeDoc = mongoClient->findOne("Employee", findOp);

        // Map the MongoDB document to a GraphQl type.
        graphql:Type Employee = {
            "id": EmployeeDoc["id"].toString(),
            "Fname": EmployeeDoc["Fname"].toString(),
            "Lname": EmployeeDoc["Lname"].toString(),
            "JobTitle": EmployeeDoc["JobTitle"].toString(),
            "Role": EmployeeDoc["Role"].toString()
        };
        return Employee;
    }

    resource function get HodProfile(int id) returns HOD {
        //Createa MongoDB query to find a HOD by ID.
        mongodb:Find findOp = new;
        findOp.filter = {"id": id };
        var HoDc = mongoClient->findOne("HOD", findOp);

        // Map the MongoDB document to a GraphQL type.
        graphql:Type HOD = {
            "id": HoDc["id"].toString(),
            "Fname": HoDc["Fname"].toString(),
            "Lname": HoDc["Lname"].toString()

        };
        return HOD;

    }
    resource function get SupervisorProfile(int id) returns Supervisor {
        return new(1, "Dula", "Shongolo");
    }
}
