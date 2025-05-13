# the interface of traffic simulation system

<div align="center">
    <a href="https://github.com/yijia0110/traffic_flow_simulation/blob/interface-branch/interface_code/readme_cn.md">中文版</a>
</div>

The interface is about to have 3 regions: ***the traffic flow visualizer*** ,  ***the manipulation buttons*** , ***the parameter setting*** . For now (2025.03.22), the interface is partially developed as the following image

<div align="center">
  <img src="interface_code\images\figure 1.PNG" alt="project cover" width="1500">
  the overall interface in the last update
</div>

## 0 update log ⚙

🏆`2025.03.22` | `the first update` | interface initial push with `start` button, `pause / restart` button, `visualization` regeion and `frame slider`

update details🚀: 

1. The `start` button can start the traffic simulation with the example data in `Example_Data.mat`. 
2. The `pause / restart` button can pause the whole simulation in any time when it is pushed for the first time. When it is staying at the `paused mode`, push it could be restarted by push it again exactly at its pause point.
3. The `visualizer` region is able to visualize the simulation process with the provided traffic data.
4. The `frame slider` is a marker of the simulation frames updated for now. It can dynamically update its limitations and sticks when the simulation goes on.

<div align="center">
  <img src="interface_code\images\updata1.gif" alt="project cover" width="1500">
  the overall interface in the last update
</div>

🏆`2025.04.05` | `the 2nd update` | add the back play function to the pause / resume button; add the **clean_app.mlapp** app script which stand for cleaned application with novel function 

update details🚀: 

1. When `pause` button is pushed, the text of the button will be changed into `resume` and vise-versa. 
2. The `auto-saving` capability is added into our application with frequency of 10 steps per save.
3. The `back-play` function is added which is activated when the application is in `pause` mode and could display the history traffic condition from whenever the slide pointer designated.
4. The `back-play` process will use the history data rather than re-calculating them.

<div align="center">
  <img src="interface_code\images\updata2.gif" alt="project cover" width="1500">
  the overall interface in the 2nd update
</div>

🏆`2025.05.12` | `the 3rd update` | add the `Road slope` change trimmer for the 1st and 2nd road part; add the `Save` and `Load` button for saving / load of simulation data; add the `Logger` of whole software

update details🚀: 

1. The 2 trimmers `Road1 slope` and `Road2 slope` are added for custom changing of road appearance with 2 modes: 1) directly change the slope number via re-typing the number in value box; 2) slightly change the slope value by using the step-by-step increase or decrease button in the step of 1 at a press time. 
2. The function of `Save` and `Load` button is different from the `auto-saving` function in the last update which is to save the simulation info of simulation in this time. To be specific, the `Save` button is to let the software aware which `auto-saving` data belongs to this simulation when the user would like to take a look at his historical data. The `Load` data is to load the historical data by user interface.
3. The `Logger` part is to save every button press or accomplished operations at the format of **time + operation content**.

<div align="center">
  <img src="interface_code\images\update3.gif" alt="project cover" width="1500">
  the overall interface in the 3rd update
</div>

## 1 repository structure
This repository has 2 branches: `Master` and `Interface_code`. The `master` branch is consisted of source code on traffic flow simulation. The `Interface_code` branch is the latest branch where source code has been assemble into an interactive user interface. 

***To be noted that*** the interface_code branch also contains all useful source code in `main` branch, therefore, directly download `interface_code` repository should come in handy. In addition, the `traffic_simulation2.m` is the runner file for the source code part.

**Last but not least** the files and their corresponding of interface part can be listed as:
> `Example_Data.mat` is the example traffic flow data used as data formulation examplary and demonstration;
> `app2.mlapp` is the matlab coded application with 'App Designer' module which constain all source code of the lastest release (Beta version, with newest functions but **unsatble**) of our software;
> `clean_app_*.mlapp` stand for the clean version of our software which will usually be realeased together with the 'app2.mlapp'. To be noted that the 'cn' means Chinese version interface and `en` stands for its English version conterpart.
> `cache_data`repository is to save the automatically cached data from software.
> `simulation_history` repository is to manually save the simulation history from software.
