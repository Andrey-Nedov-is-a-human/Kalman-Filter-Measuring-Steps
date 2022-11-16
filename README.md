# Measuring the distance traveled from gyroscope and accelerometer data using Kalman filter

<img src="/imgs/img1.jpg" width="700"/>


*Developer* 
1. [Andrey Nedov](https://github.com/Andrey-Nedov)

This project is the final one in the Estimation theory course at Ulsan University, which I completed during my internship in South Korea.
During the semester course, the Kalman filter was studied step by step. For practical work, we used data on human steps,
recorded from an accelerometer and gyroscope attached to a person's leg.

## Tasks of the final project

The main objective of the course is to develop an algorithm for accurately calculating the distance traveled based on data from an accelerometer and a gyroscope attached to the sole of a person's boot.

The objectives of the final project are to refine the algorithm written during the course and implemented using MathLab:

_While the leg is off the ground, the sensors accumulate an error. We assume that during each step there is a period when the foot is on the ground and its speed relative to the ground is zero. This way we can reset the accumulated error during each step. To implement such a mechanism, we need to add the z coordinate._

1. Add z coordinate to the set of measured Kalman filter parameters
2. Implement an algorithm for detecting the state when the foot is on the ground
3. Using the obtained algorithm, measure the distance traveled on three different data sets (longwalking1.mat, longwalking2.mat, running.mat)

## Progress

_z_ - vector of measured parameters

_H_ - measurement matrix

_x_ - parameter true state vector

_v_ - Gaussian noise

<img src="/imgs/img2.jpg" width="700"/>

After integrating the data from the accelerometer, we get the following results

<img src="/imgs/img3.jpg" width="700"/>

Data from the accelerometer and gyroscope

<img src="/imgs/img4.jpg" width="700"/>

Determine the area of zero speed on the accelerometer

<img src="/imgs/img5.jpg" width="700"/>

Determine the area of zero speed on the gyroscope

<img src="/imgs/img6.jpg" width="700"/>

We make the intersection of the obtained areas

<img src="/imgs/img7.jpg" width="700"/>
<img src="/imgs/img8.jpg" width="700"/>

Based on the data obtained from the Kalman filter, we determine the centers of the regions for calculating the leg movement vectors and add the resulting distances between steps.

<img src="/imgs/img9.jpg" width="700"/>

We got good results on three sets of data. Judging by the graphs of data from the sensors, the error from the data set with running is larger than the others, since the definition of zero speed on it works a little worse. However, the results are very close to reality. The final project was given an excellent mark and was the last work on a wonderful course.

[PDF report](https://github.com/Andrey-Nedov/Kalman-Filter-Measuring-Steps/tree/main/imgs/Report.pdf)

