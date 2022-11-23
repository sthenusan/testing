import ballerina/http;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error
    resource function get greeting(string name, http:Request request) returns string {
        return getPatientDetails(request);
    }
}

public type jwtInfo record {
    string[] scopes;
    string patientID;
    map<string> claims;
};

public function getPatientDetails(http:Request httpRequest) returns string {
    string[] jwt= check httpRequest.getHeaderNames();
    return jwt.toString();

}