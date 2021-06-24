HSI terrain classes are listed as below.

|Index|Class name| Red|Green|Blue|Hex|Sample|Remarks|
|--|--|--|--|--|--|--|--|
|1|undefined| 0|0|0|#000000<td style="background-color:#000000"></td>|Any terrain class which isn't defined in this list or shadows|
|2|grass| 0|102|0|#006600<td style="background-color:#006600"></td>|Grass which is a drivable terrain.|
|3|concrete| 170|170|170|#aaaaaa<td style="background-color:#aaaaaa"></td>|Building construction, pavements, barriers.|
|4|asphalt| 64|64|64|#404040<td style="background-color:#404040"></td>|Paved roads|
|5|tree| 0|255|0|#00ff00<td style="background-color:#00ff00"></td>|All the trees, bushes etc. un-drivable terrain.|
|6|rocks| 110|22|138|#6e168a<td style="background-color:#6e168a"></td>|Rocks|
|7|water| 68|187|170|#44bbaa<td style="background-color:#44bbaa"></td>|Water / ice combined|
|8|sky| 0|0|255|#0000ff<td style="background-color:#0000ff"></td>||
|9|gravel| 187|136|51|#bb8833<td style="background-color:#bb8833"></td>|Stone roads|
|10|object| 192|6|64|#c00640<td style="background-color:#c00640"></td>|Any man made object|
|11|dirt| 230|230|30|#e6e61e<td style="background-color:#e6e61e"></td>|Dirt and any soil type which isn't mud(wet)|
|12|mud| 99|66|340|#634222<td style="background-color:#634222"></td>|Mud : wet terrain|

>Note:
><p>Whenever update the above classes, following scripts/functions should be updated accordingly. </p>

person class with RGB (204, 153, 255), #cc99ff removed

#### Functions

* function [classDataCube, classLabels] =  CollectObjectClassData(className, dataCube)
* function [label_color] = Get_Label_Color(class_id)
* function classId = GetPixelClassId(color)

#### Scripts
* TestPixelClassesTo1D.m
* TrainingPixelClassesTo1D.m

##### classifiers
* resnet18_seg.m