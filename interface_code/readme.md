# the interface of traffic simulation system

The interface is about to have 3 regions: ***the traffic flow visualizer*** ,  ***the manipulation buttons*** , ***the parameter setting*** . For now (2025.03.22), the interface is partially developed as the following image

<div align="center">
  <img src="images\figure 1.PNG" alt="project cover" width="1500">
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
  <img src="images\updata1.gif" alt="project cover" width="1500">
  the overall interface in the last update
</div>

🏆`2025.04.05` | `the 2nd update` | add the back play function to the pause / resume button; add the **clean_app.mlapp** app script which stand for cleaned application with novel function 

update details🚀: 

1. When `pause` button is pushed, the text of the button will be changed into `resume` and vise-versa. 
2. The `auto-saving` capability is added into our application with frequency of 10 steps per save.
3. The `back-play` function is added which is activated when the application is in `pause` mode and could display the history traffic condition from whenever the slide pointer designated.
4. The `back-play` process will use the history data rather than re-calculating them.

<div align="center">
  <img src="images\updata2.gif" alt="project cover" width="1500">
  the overall interface in the 2nd update
</div>
