# the interface of traffic simulation system

The interface is about to have 3 regions: ***the traffic flow visualizer*** ,  ***the manipulation buttons*** , ***the parameter setting*** . For now (2025.03.22), the interface is partially developed as the following image

<div align="center">
  <img src="images\figure 1.PNG" alt="project cover" width="1500">
  the overall interface in the last update
</div>

## 0 update log ⚙

`2025.03.22` | `the first update` | interface initial push with `start` button, `pause / restart` button, `visualization` regeion and `frame slider`

update details: 

1. The `start` button can start the traffic simulation with the example data in `Example_Data.mat`. 
2. The `pause / restart` button can pause the whole simulation in any time when it is pushed for the first time. When it is staying at the `paused mode`, push it could be restarted by push it again exactly at its pause point.
3. The `visualizer` region is able to visualize the simulation process with the provided traffic data.
4. The `frame slider` is a marker of the simulation frames updated for now. It can dynamically update its limitations and sticks when the simulation goes on.

<div align="center">
  <img src="images\updata1.gif" alt="project cover" width="1500">
  the overall interface in the last update
</div>
