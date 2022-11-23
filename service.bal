import ballerina/http;
import ballerina/jwt;
import ballerina/regex;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error
    resource function get greeting(string name, http:Request request) returns jwtInfo|error {
        return getPatientDetails(request);
    }
}

public type jwtInfo record {
    string[] scopes;
    string patientID;
    map<string> claims;
};

public function getPatientDetails(http:Request httpRequest) returns jwtInfo|error {
    string jwt= check httpRequest.getHeader("x-jwt-assertion");
    [jwt:Header, jwt:Payload] [_, payload] = check jwt:decode(jwt);
    json idp_claims=<json>payload.get("idp_claims");
    string [] scopeslist=regex:split(<string>payload.get("scope"), " ");

    
    map<string> claimList = check idp_claims.fromJsonWithType();
    
    jwtInfo jwtInfomation={
        scopes: scopeslist,
        patientID:check idp_claims.username,
        claims: claimList
    };
    return jwtInfomation;
}