Traffic Flow Project - Josh Swift - 2018

8 Function .m files and one .m file 'TrafficFlowAnalysis' used to analyse data

TrafficFlowAnalysis is made up of several sections that can perform different tasks, all of which are labelled

![Output sample](https://github.com/Swiftyfish/TrafficFlow/raw/ezgif-5-b13a73b15d82.gif)
In all of the below programs other than where a variable is being explicitly varied, the following
parameters can be modified:
	pslow, number between 0 and 1
	RoadLength, positive integer
	T, positive integer
	vmax, positive integer
	N (where applicable), negative powers of 2 multiplied by RoadLength
	NLanes (where applicable), positive integer
	pReturn, number between 0 and 1

Sections are as follows:
	1.Standard program, can run with multiple lanes, all main parameters are free
	2.Spacetime plot, requires position and velocity data from a 1 lane runthrough of 1.
	3.Animation, requires position, velocity and lane data from an N lane runthrough of 1.
	4.Density varying program, only uses 1 lane, use for longer simulations
	5.Density varying, one lane with a combination of high and low res plots
	6.Density varying, multiple lanes with a combination of high and low res plot
		(use a road length of 250 for a reasonable runtime)
	7.Smart cars, one lane simulation
	8.Smart cars, multiple lane simulation

Each of the functions should be commented so it can be seen what they do

