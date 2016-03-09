   This is an assignment from the Udacity iOS swift course.  The app allows a Udacity user
to login, and then displays the most recent 100 Udacity users on a map and in a table.
From either the map or the table, the user can update his/her position.

   The app uses the udacity API for Udacity user information, the parse API for getting lists
of Udacity users, and the Facebook SDK as an alternate route for login and logout.
All network code is done using the model presented in class, using the classic approach with 
NSURLSession, NSURLSessionDataTask, NSJSONSerialization, etc.  The instructions for this 
project prevented us from using tools like AFNetworking.
