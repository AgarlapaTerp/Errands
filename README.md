# Errands 

## Overview
### Description
An interactive way for users to jot down notes about their daily tasks, displaying a map with pins representing frequented locations. Clicking into each pin reveals a notes screen with thoughts and reminders associated with that place, from grocery lists to workout routines.


## Demo
<div>
    <a href="https://www.loom.com/share/82b6f4234114454dbb897f1659913edb">
    </a>
    <a href="https://www.loom.com/share/82b6f4234114454dbb897f1659913edb">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/82b6f4234114454dbb897f1659913edb-with-play.gif">
    </a>
  </div>


## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)


### App Evaluation
- **Mobile**: This app is more than just a glorified website, it contains an interactive map and many different views to organize the content. The app will also use location to show pins that are closest to the user.
- **Story**: The value is inherit in an app like this. I think everyone would like to believe that a simple notes app is enough, but adding this extra layer of visualization will urge users to actually start taking notes on their daily activities. I believe my friends and family would respond very well to it, as long as I stick to simplicity. Complexity is a killer to the marketability of this app since its purpose its designed to be quick and easy.
- **Market**: People who move around a lot, and do a ton of chores/things in their lives.
- **Habit**: An average user of this app would open it multiple times a day to jot down something quick. The user doesn't just consume, but create which means that the only reason they would open my app is if they have something they need to remember. This happens often.
- **Scope**: The scope is just right since I am sticking to simplicity. A few screens, with a smooth map feature. The most challenging part of this app may be the MapKit usage.

## Product Spec

### Screen Archetypes

Map Screen
* User can look at pins in the surroundings
* User can make pins here as well

Detail Screen
* User can see any notes associated to the pin they select

Table Screen
* Users can see all of the pins they have made, and click into the detail view from there 

### Navigation

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


### Models

Pin model
- Latitude
- Longitude
- Name of pin
- Address
- Notes associated

