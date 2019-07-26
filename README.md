# IP API CFML Wrapper

ipapi provides an easy-to-use API interface allowing customers to look various pieces of information IPv4 and IPv6 addresses are associated with. For each IP address processed, the API returns more than 45 unique data points, such as location data, connection data, ISP information, time zone, currency and security assessment data.

Full documenation from the API provider is available here: https://ipapi.com/documentation.

## Instantiate

By default the component assumes the api endpoint to call is over HTTPS

```
objIPAPI = new ipapi(
    accessKey = '<your access key >'
);
```

If your subscription plan does not include HTTPS you can specify the non-SSL endpoint when constructing the component:

```
objIPAPI = new ipapi(
    apiEndpoint = 'http: //api.ipapi.com/api/',
    accessKey   = '<your access key >'
);
```

## Available Methods

The following methods are available:

* ipLookup
* originIPLookup

### ipLookup

This method will return information on the given IP address.

```
var response = objIPAPI.ipLookup(
    ipaddress = '8.8.8.8'
);
```

If your subscription plan includes bulk IP lookups, you can optionally send in a comma-separated list of IP addresses.


### originIPLookup

This method will return information on the IP address the current API request is coming from.

No IP address parameter is needed as it will use the IP of the calling machine.


## Available Parameters

Both methods above have the following optional parameters:

* fields - Specify a comma-separated list of specific fields to return from the API request
* language - Defaults to `en`. Specify a 2-letter language code that can be used to translate some of the API content
* hostname - Defaults to `false`. If set to `true` it will return hostname data for the IP address
* security - Defaults to `false`. If set to `true` it will return security data for the IP address
* responseFormat Defaults to `json`. Can be either `json` or `xml`