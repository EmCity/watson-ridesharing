## Inspiration

* You want to do a trip to another city
* Renting a car by yourself is expensive
* Share the rental in a seamless way

* Other ride sharing apps have unintuitive user interface
* We want to explore the possibilities Watson conversation offers for 
mobile development

## What it does

Chat with IBM-Watson and tell it your trip details (date, time, start 
and destination). The backend searches for matches and connects the 
different parties.

## How we built it

Client server architecture with IBM Watson (conversation), Python, 
Flask, MongoDB, Swift, Firebase. iOS app communicates with the Flask 
backend which forwards the messages to Watson and returns his results 
back to the client. After all needed details are passed the backend 
searches for possible matches in the database. It suggests to start a  
chat with the matched party to fix the details for the ride. The 
conversations between the parties are implemented with firebase.

## Challenges we ran into
IBM Watson conversation: graphical programming and functionality 
Connect the mobile frontend with the backend and the Watson API

## Accomplishments that we're proud of
Watson recognizes the needed infos (date, time, start, destination) and 
the trip matching

## What we learned
To define conversations in IBM Watson and how to integrate it in a 
server-client-architecture


## What's next for RideGo

* Increase the conversation flexibility 
* Find car sharing partner(s)
* Improve app and backend