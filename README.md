# meals_app

A full functional Flutter Favorite Places Application.

## Description

This project is a Flutter Favorite Places mobile application which gives the user the ability to :

1. View the available favorite places list that has been fetched from the database (loading spinner would be shown till that happen).
2. Navigate to the adding screen using the + button at the top right corner.
3. Fill the title and take an image to populate the image input section.
4. get the location either by getting the current location or selecting it on the map manually.
5. Push and save the data in the local database(the phone hardware).
6. Navigate to the details screen to view the details of the pre added place item by clicking on the wanted item.
7. Review the picked location on the map in the place detaills screen.

## Back-end

SQL database on the phone device hardware, using the sqflite package.

The database logic has been managed in the riverpod provider file.

## Location

The location informations are got using the location package.

Latitude and longitude are translated into user friendly map snapshot
using the Google static map api and google reverse geocoding.

Picking location on map and reviewing the picked location done
using google maps package.

## State Management

state management has been done using riverpod.

## Features of the app With Screenshots

| Task                               | Screenshot                                                                   | Task                                          | Screenshot                                                                           |
| ---------------------------------- | ---------------------------------------------------------------------------- | --------------------------------------------- | ------------------------------------------------------------------------------------ |
| New Places Adding Screen           | ![New Places Adding Screen](assets/screenshots/tabsScreen.png)               | Filled Place Input                            | ![ Filled Place Input  ](assets/screenshots/favoriteScreen.png)                      |
| Places Screen After Adding an Ietm | ![Places Screen After Adding an Ietm](assets/screenshots/categoryScreen.png) | Location Input Screen                         | ![Location Input Screen](assets/screenshots/categoryFiltered.png)                    |
| Place Details Screen               | ![ Place Details Screen  ](assets/screenshots/filters.png)                   | Reviewing Picked Location From Details Screen | ![Reviewing Picked Location From Details Screen](assets/screenshots/mealDetails.png) |
