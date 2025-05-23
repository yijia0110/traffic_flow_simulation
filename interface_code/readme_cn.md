# 交通仿真系统界面

界面即将分为三个区域： ***交通流可视化界面*** ， ***操控按钮*** ， ***参数设置*** 。目前（2025.03.22）界面部分开发如下图

<div align="center">
  <img src="images\figure 1.PNG" alt="project cover" width="1500">
  最新更新的整体界面效果
</div>

## 0 更新日志 ⚙

🏆`2025.03.22` | `首次更新` | 界面初始推送 `开始`按钮、`暂停/重启` 按钮、`可视化` 区域和 `框架滑块`

更新细节🚀: 

1. `start`按钮可以使用`Example_Data.mat`中的示例数据启动交通模拟。
2. 首次按下 `暂停/重启` 按钮时，可随时暂停整个模拟。当它处于 `暂停模式` 时，再次按下按钮，即可在暂停点准确重新启动它。
3. `可视化器` 区域能够利用提供的交通数据可视化模拟过程。
4. `帧滑块` 是目前更新的模拟帧的标记。它可以在模拟进行时动态更新其限制和粘性。

<div align="center">
  <img src="images\updata1.gif" alt="project cover" width="1500">
  当前更新的整体界面效果
</div>

🏆`2025.04.05` | `第二次更新` | 添加了 `暂停/恢复` 按钮的后退播放功能；添加**clean_app.mlapp**应用脚本，代表具备干净效果的应用，具有所有新功能的老功能

更新细节🚀: 

1. 当按下 `暂停` 按钮时，按钮的文本将更改为 `恢复` ，反之亦然。
2. 我们的应用程序添加了 `自动保存` 功能，每次保存的频率为 10 步。
3. 添加了 `回放` 功能，该功能在应用程序处于 `暂停` 模式时激活，并且可以显示从幻灯片指针指定时起的历史交通状况。
4. `回放` 过程将使用历史数据，而不是重新计算它们。

<div align="center">
  <img src="images\updata2.gif" alt="project cover" width="1500">
  第二次更新的整体界面效果
</div>

🏆`2025.05.12` | `第三次更新` | 增加了第一、二部分道路的‘道路坡度’变化调整器；增加了模拟数据的保存/加载‘保存’和‘加载’按钮；增加了整个软件的‘记录器’

update details🚀: 

1. 新增`道路1坡度`和`道路2坡度`两个微调器，用于自定义更改道路外观，并提供两种模式：1）通过在数值框中重新输入数字直接更改坡度数值；2）使用逐步增加或减少按钮，以每次按下1的步长微调坡度值。
2. `保存`和`加载`按钮的功能与上次更新中的`自动保存`功能不同，后者用于保存本次模拟的模拟信息。具体而言，`保存`按钮用于在用户想要查看历史数据时，让软件知道哪些`自动保存`的数据属于本次模拟。`加载`按钮用于通过用户界面加载历史数据。
3. `记录器`部分用于以 **时间 + 操作内容** 的格式保存每次按下按钮或完成的操作。

1. The 2 trimmers `Road1 slope` and `Road2 slope` are added for custom changing of road appearance with 2 modes: 1) directly change the slope number via re-typing the number in value box; 2) slightly change the slope value by using the step-by-step increase or decrease button in the step of 1 at a press time. 
2. The function of `Save` and `Load` button is different from the `auto-saving` function in the last update which is to save the simulation info of simulation in this time. To be specific, the `Save` button is to let the software aware which `auto-saving` data belongs to this simulation when the user would like to take a look at his historical data. The `Load` data is to load the historical data by user interface.
3. The `Logger` part is to save every button press or accomplished operations at the format of **time + operation content**.

<div align="center">
  <img src="images\update3.gif" alt="project cover" width="1500">
  第三次更新的整体界面效果
</div>
