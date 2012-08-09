# Problem Description

For this programming problem you are building a rails application to collect data from a mobile device and then providing an admin screen to visualize and interact with this data. 
Specs

The rails app has two main parts: a web service for collecting structured data and an admin screen to view and manipulate this data.

# Web Service

The web service has two end points. The first end point initiates a “session” between the mobile client and the server. This end point returns an id for the newly created session. The second end point handles state changes for a particular session, meaning it requires a valid session id. Both end points collect the following information:

* Latitude, double
* Longitude, double
* Timestamp, double
* Event type, string

Event type is a string value. It is one of the following values, with an explanation if necessary:

* Start - This event is recorded when a new session is started.
* Check1
* Check2
* Finish - This event is recorded when a session is completed
* Cancel - This event is recorded when a session is canceled.

The Finish and Cancel events both effectively end the current session. Check1 and Check2 are only ever sent one time and in that order. Finish can only be sent after Check2. Cancel can be sent at any time. Example valid sessions:

*Start
*Check1
*Check2
*Finish

*Start
*Cancel

*Start
*Check1
*Cancel
*Analytics

The analytics section is a single page that displays data collected from the web service and provides some basic analysis functionality. Implement at least two of the following:

A google maps mash up. The user can select a session from a drop down and session’s data points are plotted on the map.
Show two stacked bar charts, one for the shortest finished session and one for the longest finished session. They should also be on the same graph. Bonus: Ability to select two arbitrary sessions for comparison in the bar chart.
Calculate the following, display in a table:

  Ratio of canceled sessions to finished sessions
  Mean and median finished session length
  Mean and Median cancelled session length
  Breakdown of canceled sessions after Start, Check1, Check2
  Ability to search sessions based on one or more of the following criteria:
  is Finished
  is Canceled
  Total time (> or < a timespan)
  Time between Start and Check1 (> or < a timespan)
  Time between Check1 and Check2 (> or < a a timespan)
  Ex:
  All sessions finished with a total time < 6000s and a time between check1 and check2 > 1000s
  Ability to search for any one event in a geographic area in a google map. The events in that area should also be plotted. Hint: Think of Yelp’s “redo search here” in their maps.
  Calculate the following, display in a table:
  Mean, median distance between start and finish of the sessions
  Mean, median distance between start and cancel of the sessions
  Mean, median distance between all events in a session
  Mean, median total distance between start and finish of a session. To be clear: this is the sum of the individual distances between each event.
  Allow the user to enter an arbitrary amount of time and give the percentile it’s in for:
  Times between Check1 and Check2
  Times between Start and Finish

Assumptions


The admin portion of the app is in a secure environment. i.e. don’t worry about wiring in any sort of authentication or user management
The requirements are intentionally vague - we are interested in the design decisions you make.
All calculated distances are in a straight line. Don’t worry about roads, lakes, etc.
Using an in-memory database is ok, don’t worry about setting up any sort of infrastructure. The default rails s environment is just fine.
Don’t worry about testing. While we value testing, the purpose of this problem is to ascertain your knowledge of the rails framework and to evaluate the design decisions you make.

Hints


http://www.highcharts.com is your friend.
Everyone forgets statistics, here is a helpful refresher:  http://greenteapress.com/thinkstats/html/index.html
Google Maps API: http://code.google.com/apis/maps/documentation/javascript/
The euclidean distance is not appropriate for determining distances between geographic coordinates (the earth is not a 2d flat surface).
While we value performance, this exercise is about getting the right answers and showing off your ability to write clean, maintainable code. In short: worry about performance last.
