public with sharing class justsalesforcejobscomJobDigger {

    public static void makeGetRequest() {
        // Define the endpoint URL—replace this with your actual Salesforce API endpoint
        String endpointUrl = 'https://justsalesforcejobs.com/jobs?q=&category=&job_type=&location=&location_id=&remote=1';

        // Create an instance of the HTTPRequest class
        HttpRequest httpRequest = new HttpRequest();

        // Set the endpoint URL
        httpRequest.setEndpoint(endpointUrl);

        // Set the HTTP method (GET, POST, etc.)
        httpRequest.setMethod('GET');

        // Set the header keys and values if needed
        httpRequest.setHeader('Content-Type', 'application/json');

        // Set the request body if needed (for POST or PUT requests)
        //httpRequest.setBody('{"example":"content"}');

        // Create an instance of the HTTP class to send the request and receive the response
        Http http = new Http();

        // Send the request and receive the response
        HttpResponse httpResponse = http.send(httpRequest);

        // System.debug(LoggingLevel.ERROR, '\n\n --- justsalesforcejobscomJobDigger - makeGetRequest - 1 ---'
        // +'\n - httpResponse: ' + httpResponse
        // +'\n');
        // Check the response status code
        if (httpResponse.getStatusCode() == 200) {
            // If the request goes through successfully, return the response body
            //return httpResponse.getBody();
            System.debug(LoggingLevel.ERROR, '\n\n --- justsalesforcejobscomJobDigger - makeGetRequest - 2 ---'
            +'\n - httpResponse: ' + httpResponse
            // +'\n - httpResponse.getBody(): ' + httpResponse.getBody()
            +'\n');
            
            String responseBody = httpResponse.getBody();
            if (String.isNotBlank(responseBody)) {
                //Integer firstJobStartLink = responseBody.indexOf(JOB_DETAIL_LINK_BEGINNING) + JOB_DETAIL_LINK_BEGINNING.length();
                // Integer firstJobEndLink = responseBody.indexOf('"', firstJobStartLink+1);
                
                String jobEndpointPart = getJobEndpointPart(responseBody, 0);
                String jobEndpoint = 'https://justsalesforcejobs.com' + jobEndpointPart;
                Integer jobEndpointPartIndexEnd = responseBody.indexOf(jobEndpointPart) + jobEndpointPart.length();
                String jobTitle = getJobTitle(responseBody.substring(jobEndpointPartIndexEnd), 0);
                System.debug(LoggingLevel.ERROR, '\n\n --- justsalesforcejobscomJobDigger - makeGetRequest - 3 ---'
                +'\n - jobEndpointPart: ' + jobEndpointPart
                +'\n - jobEndpointPartIndexEnd: ' + jobEndpointPartIndexEnd
                +'\n - jobTitle: ' + jobTitle
                +'\n');
            }
        } else {
            // If the request fails, throw an exception
            throw new CalloutException(httpResponse.getBody());
        }
        
    }


    private static final String JOB_DETAIL_LINK_BEGINNING = '<a class="job-details-link" href="';
    private static final Integer JOB_DETAIL_LINK_BEGINNING_LENGTH;
    static {
        JOB_DETAIL_LINK_BEGINNING_LENGTH = JOB_DETAIL_LINK_BEGINNING.length();
    }
    private static String getJobEndpointPart(
        String htmlBody,
        Integer startIndex
    ) {
        Integer firstJobStartLink = htmlBody.indexOf(JOB_DETAIL_LINK_BEGINNING, startIndex) + JOB_DETAIL_LINK_BEGINNING_LENGTH;
        Integer firstJobEndLink = htmlBody.indexOf('"', firstJobStartLink+1);
        String jobEndpoint = htmlBody.substring(firstJobStartLink, firstJobEndLink);
        System.debug(LoggingLevel.ERROR, '\n\n --- justsalesforcejobscomJobDigger - getJobEndpointPart ---'
        +'\n - firstJobStartLink: ' + firstJobStartLink
        +'\n - firstJobEndLink: ' + firstJobEndLink
        +'\n - jobEndpoint: ' + jobEndpoint
        +'\n');
        return jobEndpoint;
    }

    private static final String JOB_TITLE_BEGINNING = '<h3>';
    private static final Integer JOB_TITLE_BEGINNING_LENGTH;
    static {
        JOB_TITLE_BEGINNING_LENGTH = JOB_TITLE_BEGINNING.length();
    }
    private static String getJobTitle(
        String htmlBody,
        Integer startIndex
    ) {
        Integer firstJobTitleStart = htmlBody.indexOf(JOB_TITLE_BEGINNING, startIndex) + JOB_TITLE_BEGINNING_LENGTH;
        Integer firstJobTitleEnd = htmlBody.indexOf('</h3>', firstJobTitleStart+1);
        String jobTitle = htmlBody.substring(firstJobTitleStart, firstJobTitleEnd);
        System.debug(LoggingLevel.ERROR, '\n\n --- justsalesforcejobscomJobDigger - getJobTitle ---'
        +'\n - htmlBody: ' + htmlBody.substring(22)
        +'\n - jobTitle: ' + jobTitle
        +'\n');
        jobTitle = jobTitle.trim();
        return jobTitle;
    }
}