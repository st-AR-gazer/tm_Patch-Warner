# Physics Update Checker (& warner)

This script is designed to check for a specific build update that brought with it some physics updates.

## Overview

The script serves as tool that helps by notifying players of physics changes based on the map's exeBuild. It operates by continuously checking for a new map load and warns the player based on what it finds in the maps XML.

## Features

- **Point 1:** Automated detection of map's exeBuild version.
- **Point 2:** Notifications for ice and wood physics changes based on exeBuild date.
- **Point 3:** File handling and XML parsing for game data extraction.

## ⚠️ Important Notes

1. **Limitations:** The script's functionality is contingent on the map's exeBuild date, if this strucutre changes in the future (or is tampred with), the plugin will default to no physics changes having occured.

## Prerequisites

- [Trackmania](http://trackmania.com/) game installed

## How It Works

- **Point 1:** On every game loop, the script checks if a map is loaded and fetches the map file details.
- **Point 2:** Extracts the exeBuild date from the map's XML data to determine the applicable physics.
- **Point 3:** Based on the exeBuild date, the script notifies the player about the relevant physics updates affecting the map, such as ice or wood physics.

## Credits

- **Authors:** ar..... / AR_-_
