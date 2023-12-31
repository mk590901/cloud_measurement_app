# Measuring In Cloud

Flutter frontend for cloud located sensor.

## Introduction

>The goal of the project is to developing a universal widget for controlling and visualizing a certain virtual (for now) measuring instrument. In this case - this is a temperature sensor.

## Concept

>The widget is a tile consisting of several elements: an icon with animation elements, a measurement result field and a button that allows you to initiate or interrupt a measurement. The color of the widget changes depending on the received measuring value: out of range, critically low, low, normal, and then increasing according to the same principle. The main idea is to create a common measuring panel for a certain number of sensors in the form of a vertical list of items, each of which is a widget of a separate device or a property of a complex device.

## Implementation

>All application elements were created earlier and applied in the project https://github.com/mk590901/temperature_sensor_simulator. In the current project they are just a little more streamlined and refactored. The implementation still uses the **BLOC** model.

## Features of the application

>The application is represented by four pages: **login**, **logout**, **simulator panel** and **about** page. There are buttons on the toolbar of app to navigate.

>Elements of interaction with **toitware's account** in which **ESP32** controllers are registered have been added to the application. The **toit_api** library is used for this. It allows you to connect to an account, as well as send data to the controller and receive a response from it using the **publish-subscribe** pattern.

>The application works in two modes: **local**, using an internal temperature sensor simulator or **cloud**, using an external simulator running on an ESP32. In the second case, you must first deploy the CloudServer application, as shown in the figure below. If you run the application and ignore login and go straight to the sensor page, the internal simulator starts. If login is executed, then simulator will be launched on the ESP32 controller connected to the your toitware account on the cloud.

>This application can be considered as client, similar to the client application on toit in the https://github.com/mk590901/toit-temperature-sensor project, only writted on flutter. Can say this project includes server elements of the https://github.com/mk590901/toit-temperature-sensor project.

>Below are two movies: the first is ESP32 simulation on cloud, the second is the local internal simulator. Unfortunately, github doesn't allow to add movies larger than 10MB to README.md, so I had to create two videos.

### ESP32 simulation on cloud

https://github.com/mk590901/cloud_measurement_app/assets/125393245/90c94fce-704b-41ee-9f64-be44b4c460d8

### Local Simulation

https://github.com/mk590901/cloud_measurement_app/assets/125393245/d5f65dce-c616-4c45-b9b5-8960b74c8dc9

>It's easy to see that, all other things being equal, an application using ESP32 is much slower. Sending and receiving data via the cloud takes time.

## Additions

>Deployment of TOIT CloudServer app 

![echo](https://github.com/mk590901/cloud_measurement_app/assets/125393245/0f13bf06-09d9-4af7-9cf4-ea934f09f6d0)

>The next picture is provided to confirm that everything that is happening isn't vision aberration or a fake, and the application actually involves ESP32 and cloud. This is screenshot of toitware console of CloudServer app -  temperature sensor emulator server. 

![toit_console](https://github.com/mk590901/cloud_measurement_app/assets/125393245/fcc3bd81-5ee6-4537-8371-2e92af36a415)
