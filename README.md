# MeasureMash

The Empire State Building is about 1250 feet tall. An American football field is around 120 yards wide. But how tall is 1250 feet, *exactly*? How wide is 120 yards wide, *exactly*? Oftentimes we are made to know the dimensions of buildings and structures, but it's difficult to visualize them: that's where **MeasureMash** comes in.

## Overview

MeasureMash is an iOS mobile application that runs on Apple's very own *ARKit*, a powerful augmented reality platform. The app utilizes image anchors to track points in the real world and create a chain of fun objects such as houses, pool balls, and soccer goals from one endpoint to another. Users can tap the view, set the real-world distance that the resulting line segment represents, choose an everyday object, and let MeasureMash handle all the calculations and visualization.

## Innovation

Perhaps the most common method of combining tap gestures and augmented reality is through *raycasting*, which essentially projects the user's tapped location through the real world until a surface is hit. However, raycasting is extremely limited in its capabilities, as only flat planes can be anchored to. Additionally, the effective distance of raycasting is no more than a couple meters. Thus, MeasureMash utilizes **image anchoring** instead: as soon as the user taps the augmented reality view, the app takes a screen capture of the surrounding pixels, and then creates an anchor using the resulting image. This method enables the AR algorithm to search for 2D pixels rather than 3D planes, greatly improving the effective range as well as increasing the rate at which irregular surfaces are detected and anchored to.

## Challenges

One of the most challenging aspects of developing MeasureMash was maintaining a smooth user experience. The high resolution 3D models that we used often threatened to slow or even halt the app completely as it struggled to render many augmented reality objects at once. As a result, our team had to find a way to load the models asynchronously as well as limit the refresh rate of the AR view as a whole. By combining these two techniques, we were able to greatly improve the usability of MeasureMash, though there is still work to be done in this aspect.

## What Lies Ahead

While raycasting is limited in surface variety and range, it excels at calculating the distance between two anchored points. Unfortunately, due to the reliance on 2D images, MeasureMash's use of image anchoring means that the user must input the real-world distance. Our team hopes to find a way to implement accurate distance calculates using image anchoring in order to further streamline the user experience. Additionally, an idea we're considering is to allow users to create and/or import their own 3D models to be used for visualizing measurements.
