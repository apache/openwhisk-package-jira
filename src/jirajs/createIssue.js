/***********************************************************

Create Issue in Jira.  Issue is encoded as a JSON object
in the form:

{
    "fields": {
       "project":
       { 
          "key": "TEST"
       },
       "summary": "REST ye merry gentlemen.",
       "description": "Creating of an issue using project keys and issue type names using the REST API",
       "issuetype": {
          "name": "Bug"
       }
   }
}

For project, key is the key value assigned to a Jira project, e.g. "MyAwesomeScrumProject"
may have the key "MYAW"

@param issue the jsonObject representing the issue
@return response from Jira representing succes or failure

***********************************************************/
var request = require('request');

function main(params) {

  if (!(params.jiraUsername && params.jiraPassword)) {
    return whisk.error("Jira credentials not set")
  }

  if (!params.jiraHost) {
    return whisk.error("Location of Jira server not set")
  }

  if (!params.issue) {
    return whisk.error("No issue data to create")
  }
  
  var issue = params.issue
  var username = params.jiraUsername
  var password = params.jiraPassword
  var url = 'https://' + username+":" + password + '@'+params.jiraHost+"/rest/api/2/issue/"
  
  console.log("Got url " + url)

  var options = {
    headers: {
      'Content-Type': 'application/json'
    },
    method: "POST",
    json: issue
  }

  console.log("Making call with options "+ JSON.stringify(options))
  request(url, options, function (error, response, body) {
    console.log("In callback")
    if (!error && response.statusCode > 200 && response.statusCode < 300 ) {
      //var info = JSON.parse(body);
      console.log("Got body "+body)
      return whisk.done(body)
    } else {
      return whisk.error("Got error "+ error + " status code "+response.statusCode)
    }
  });

  console.log("Async")
  return whisk.async()
}




