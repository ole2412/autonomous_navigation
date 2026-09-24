## Robot in Simulation (ROS2, Gazebo)

Differential drive robot 

# Requirements
Install a ROS2 version matching your OS from the [official website](https://docs.ros.org/en/).
In my case this is ROS 2 Jazzy for Ubuntu Noble 24.04 and as a result, the following instructions will be for Ubunutu.

Install colcon: `sudo apt install python3-colcon-common-extensions`

# Build automatically (rerun required when adding a new file)
`colcon build --symlink-install`

from dev_ws/: `source install/setup.bash`
ros2 launch my_bot rsp.launch.py

## launch gazebo
ros2 launch ros_gz_sim gz_sim.launch.py gz_args:="-r empty.sdf"

## spawn robot in gz
ros2 run ros_gz_sim create -topic robot_description -name my_bot

## launch gazebo simulation with custom world
ros2 launch my_bot launch_sim.launch.py world:=src/my_bot/worlds/obstacles.world

### keyboard input
ros2 run teleop_twist_keyboard teleop_twist_keyboard

## loda and activate controller by name
ros2 run controller_manager spawner diff_cont

tf2 (transforms)
track robot coordinate frames over time

urdf
xml format for presenting a robot structure
represent joints and their relation