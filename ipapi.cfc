/**
 * Name: ipapi.cfc
 * Author: Matt Gifford (matt@monkehworks.com)
 * Purpose: To interact with the IP API service and retrieve geo data for the given IP addresses
 * Documentation: https://ipapi.com/documentation
 */
component accessors="true" {

    property name="apiEndpoint" type="string";
    property name="accessKey" type="string";

    /**
     * Constructor
     * 
     * @apiEndpoint The api endpoint to call. Defaults to https. If your plan does not support this, please specify the non-SSL endpoint
     * @accessKey The API access key for your account / plan
     */
    public ipapi function init(
        required string apiEndpoint = "https://api.ipapi.com/api/",
        required string accessKey
    ){  
        setApiEndpoint( arguments.apiEndpoint );
        setAccessKey( arguments.accessKey );
        return this;
    }

    /**
     * Makes a request to the API to retrieve geo location data for the given ipaddress string
     *
     * @ipaddress Either a single ip address or a comma-separated list of max 50 ip addresses (if your API plan allows bulk processing)
     * @fields An optional comma-separated list of fields to return in the response
     * @language The language for response objects
     * @hostname If set to true, hostname data will be returned if available
     * @security If set to true, security data will be returned if available
     * @responseFormat The response format. Defaults to json
     */
    public function ipLookup(
        required string ipaddress,
        required string fields    = '',
        required string language  = '',
        required boolean hostname = false,
        required boolean security = false,
        required string responseFormat = 'json'
    ){
        var strURL = "#getApiEndpoint()##arguments.ipaddress#";
        return makeRequest(
            apiURL         = strURL,
            fields         = arguments.fields,
            language       = arguments.language,
            hostname       = arguments.hostname,
            security       = arguments.security,
            responseFormat = arguments.responseFormat
        );
    }

    /**
     * Makes a request to the API to look up the IP address the current API request is coming from
     * 
     * @fields An optional comma-separated list of fields to return in the response
     * @language The language for response objects
     * @hostname If set to true, hostname data will be returned if available
     * @security If set to true, security data will be returned if available
     * @responseFormat The response format. Defaults to json
     */
    public function originIPLookup(
        required string fields    = '',
        required string language  = '',
        required boolean hostname = false,
        required boolean security = false,
        required string responseFormat = 'json'
    ){
        var strURL = "#getApiEndpoint()#check";
        return makeRequest(
            apiURL         = strURL,
            fields         = arguments.fields,
            language       = arguments.language,
            hostname       = arguments.hostname,
            security       = arguments.security,
            responseFormat = arguments.responseFormat
        );
    }

    /**
     * Makes all requests to the API. Will return the content from the cfhttp request.
     *
     * @apiURL The API URl to call
     * @fields An optional comma-separated list of fields to return in the response
     * @language The language for response objects
     * @hostname If set to true, hostname data will be returned if available
     * @security If set to true, security data will be returned if available
     * @responseFormat The response format. Can be xml or json. Defaults to json.
     */
    private function makeRequest(
        required string apiURL,
        required string fields    = '',
        required string language  = '',
        required boolean hostname = false,
        required boolean security = false,
        required string responseFormat = 'json'
    ){
        var strEndpoint = "#arguments.apiURL#?access_key=#getAccessKey()#";
        if( len( arguments.fields ) ){
            strEndpoint &= '&fields=#arguments.fields#';
        }
        if( len( arguments.language ) ){
            strEndpoint &= '&language=#arguments.language#';
        }
        if( arguments.hostname ){
            strEndpoint &= '&hostname=1';
        }
        if( arguments.security ){
            strEndpoint &= '&security=1';
        }
        var httpService = new http( method = "GET", charset = "utf-8", url = "#strEndpoint#&output=#arguments.responseFormat#" );
        var result      = httpService.send().getPrefix();
        var apiResponse = ( arguments.responseFormat == 'xml' ) ? xmlParse( result.fileContent ) : deserializeJson( result.fileContent );
        return apiResponse;
    }

}