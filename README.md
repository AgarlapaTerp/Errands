Original App Design Project - README Template
===

# Errands 


## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)
5. [Sprint 1](#SPRINT-1)
6. [Sprint 2](#SPRINT-2)
7. [Sprint 3](#SPRINT-3)

## Overview
### Description
An interactive way for users to jot down notes about their daily tasks, displaying a map with pins representing frequented locations. Clicking into each pin reveals a notes screen with thoughts and reminders associated with that place, from grocery lists to workout routines.

### App Evaluation
- **Mobile**: This app is more than just a glorified website, it contains an interactive map and many different views to organize the content. The app will also use location to show pins that are closest to the user.
- **Story**: The value is inherit in an app like this. I think everyone would like to believe that a simple notes app is enough, but adding this extra layer of visualization will urge users to actually start taking notes on their daily activities. I believe my friends and family would respond very well to it, as long as I stick to simplicity. Complexity is a killer to the marketability of this app since its purpose its designed to be quick and easy.
- **Market**: People who move around a lot, and do a ton of chores/things in their lives.
- **Habit**: An average user of this app would open it multiple times a day to jot down something quick. The user doesn't just consume, but create which means that the only reason they would open my app is if they have something they need to remember. This happens often.
- **Scope**: The scope is just right since I am sticking to simplicity. A few screens, with a smooth map feature. The most challenging part of this app may be the MapKit usage.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [X]  User must be presented a map zoomed into their location, with nearby pins
- [X]  User must be able to scroll around the map
- [X]  User must be able to place a new pin if they need
- [X]  User must be able to press on a pin and navigate to a details screen
- [X]  User must be able to see a details screen with all of their notes
- [X]  User must be able to tab to a table view to see all of the pins they have made, with a navigation to the corresponding details screen

**Optional Nice-to-have Stories**

- [X]  Users can label pins to help organize their tasks
- [X]  Users can share notes to other people
- [ ]  Users can make multiple notes with folders, and more intricate management
- [X]  Users can press on a pin and start navigation towards that location

### 2. Screen Archetypes

Map Screen
* User can look at pins in the surroundings
* User can make pins here as well

Detail Screen
* User can see any notes associated to the pin they select

Table Screen
* Users can see all of the pins they have made, and click into the detail view from there 

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Map
* List of Pinned Locations
* Note Screen

**Flow Navigation** (Screen to Screen)

- Map Pins
    * => Notes
- List Screen
    * => Notes
- Notes Screen
    * => Back to map or list

## Wireframes

![schema](https://github.com/abgbro/Errands/assets/156050659/3a3ccfad-54a9-4c9a-a82a-98e26de1e89a)

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 

[This section will be completed in Unit 9]

### Models

Pin model
- Latitude
- Longitude
- Name of pin
- Address
- Notes associated

## SPRINT-1
## What I've Done
- Added a tab controller along with some navigation controllers
- Added a view for the mapkit
- Allowed users to place pins with a long press
## What I'm working on
- Ability to get user's real time location on the map
- A sheet that opens to make pins
## What's next
- Fixing navigation
- Making segues from pins to table views
- Making a notes section

## SPRINT-2
## What I've Done
- Getting real time location on map
- Sheet that opens to make pins
- Sheet that opens to view pins
   - Button that lets you delete the pin
   - Button that takes you to apple maps app to get directions to map
- Making notes section
   - Can upload pictures to the notes now
   - Can share the notes with others
   - Can edit the notes
- Fixed navigation
- Making segues to table views
- implemented a search bar on the map using tableview
   - can search for places in your maps region
        - clicking on a place will pin itself on the region
- Implemented a UIContentUnavailableView for table section of map

## What I'm working on
- Core data models and persistent state

## What needs to be done
- Complete table view with a button to get to notes on each row of the table
- Add address to pins, and fix distance of pins so that it shows distance in miles
- Sorting feature of pins to make it easier to find pins on the table view
- Making UI in the sheets copy and pasteable
- Checking that current location is actually being updated

## SPRINT-3
## What I've Done
- Core Data models and persistent state
- Completed table view with a button to get to notes on each row of the table
- Sorting features to make it easier to find pins on the table views
- Current location updating with user
- Adding swipe features to delete pins and copy coordinates of pins to search

## Demo
<div>
    <a href="https://www.loom.com/share/82b6f4234114454dbb897f1659913edb">
    </a>
    <a href="https://www.loom.com/share/82b6f4234114454dbb897f1659913edb">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/82b6f4234114454dbb897f1659913edb-with-play.gif">
    </a>
  </div>
