# Weather Forecast
Weather Forecast is a small iOS application that help users are easy to search and find the weather's forecast information in next 7 days. 

## Table of Contents  
1. [Features](#Features)  
2. [Architecture](#Architecture)  
3. [Design Technical Proposal](#FeatureDesign)  
4. [Demo](#Demo)  

<a name="Features"></a>
## Features
1. Retrive weather data from OpenWeatherMaps API.
2. Allow user search weather's forecast by City name.
3. Show weather's forecast for city in next 7 days.
4. Support caching mechanism
5. Show weather's icon status on the right side.
6. Handle failures status and show error message to user.
7. Scale text feature for more people who can not see the text clearly
8. VoiceOver feature when user tap to forecast item.


<a name="Architecture"></a>
## Architecture
This project is using VIPER design pattern and combine with Clean architecture. For detail of architecture, let see the diagram below:

![alt text](https://github.com/vudang/Weather/blob/main/READMEResources/Architecture.png "")

<a name="FeatureDesign"></a>
## Design Technical Proposal
This is technical design for searching feature in the Weather project.

![alt text](https://github.com/vudang/Weather/blob/main/READMEResources/Weather_Flow_Diagram.png "")

<a name="Demo"></a>
## Demo
Video demo Weather app.

[![Demo](https://i9.ytimg.com/vi/UwHVTaH6Hzk/mqdefault.jpg?v=62ec9eb7&sqp=CPS7spcG&rs=AOn4CLA8JhNrPZ4reT7kjnTz5WZ0b8Jn2w)](https://youtube.com/shorts/UwHVTaH6Hzk)
