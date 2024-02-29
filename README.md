# Individual_Project

## Electrical Variables Evaluator (EVE)

## MATLAB Scripts Discription

### Environment Preparation

We highly suggest using this tool under a Windows PC (tested with Windows 10) with MATLAB R2023b

| Compatibility             | Windows | macOS |
| ------------------------- | ------- | ----- |
| Distortion Detection      | V       | X     |
| Detection Result Analysis | V       | V     |

To use the script, please ensure the files are stored as shown below:

```
-------Matlab_File
|                 |-MainFunc.m
|                 |-evaluator.m
|                 |-config.csv
|                 |-setting.csv
|                 |-setting_time.csv
|                 |-Evaluation Report.dotx
|
|------Data
```

### How to use

#### Create config.csv

The config file is the most important file that required to run the tool, it set the fundamental variables that need to analysis the data.
Please edit the config file regarding to the following table. After edit, the csv file should be a 9*1 table.

| **INSERT YOUR SETTING IN THIS COLUMN**                       |
| ------------------------------------------------------------ |
| **The path of this tool**                                    |
| **The path of your data**                                    |
| **The nominal voltage of your data (unit in V)**             |
| **The time interval of calculating average and RMS values (unit in microseconds)** |
| **The time interval of calculating RDF (unit in microseconds, typically 200000)** |
| **The sampling frequency of the data (unit in Hz)**          |
| **The threshold of Dip you would like to use (unit in pu)**  |
| **The threshold of Swell you would like to use (unit in pu)**  |
| **The threshold of Interruption you would like to use (unit in pu)** |
| **The threshold of Hysteresis you would like to use (unit in pu)** |
| **Start time (format as: yyyy-MMM-d HH:mm:ss.SSS)**          |
| **Enable auto report generator (enter 1 for enable, 0 for disable)** |

** Please note that the interactive tool would not start if auto report generator is enabled, vise versa. **
For default setting, which was used during the develop of the tool, please refer to the following table. The last line, which is set as 0 for active the interactive tool.

| **INSERT YOUR SETTING IN THIS COLUMN**                       |
| ------------------------------------------------------------ |
| **The path of this tool**                                    |
| **The path of your data**                                    |
| **700**             |
| **10000** |
| **200000** |
| **100000**          |
| **0.9**  |
| **1.1**  |
| **0.1** |
| **0.02** |
| **2023-09-26 13:47:47**          |
| **0** |

#### Create setting.csv and setting_time.csv

These two file stores the setting discription of the network, and the time when the setting starts. setting_time.csv is a single column file, each line correspond to one setting change point. The time format is the same as yyyy-MMM-d HH:mm:ss.SSS.
setting.csv stores the description of the system at that time, with the first line contains the discription of the settings, the height of setting.csv and setting_time.csv should have a difference of one, where the height of setting.csv is larger.

### Variables Description

The following table shows the description of the major variables in the scripts.

| Variable                          | Type   | Description                                                  |
| --------------------------------- | ------ | ------------------------------------------------------------ |
| config                            | Global | The config file                                              |
| MLPath                            | Global | The path of the script files                                 |
| DTPath                            | Global | The path of the data                                         |
| U_nominal                         | Global | The nominal voltage                                          |
| group_size                        | Global | The time interval used to calculate rms voltage for non-stationary disturbances |
| sample_window_length              | Global | The time interval used for stationary disturbance            |
| Fs                                | Global | Sampling frequency                                           |
| Threshold_Dip                     | Global | pu value of the threshold of dip                             |
| Threshold_Swell                   | Global | pu value of the threshold of swell                           |
| Threshold_Interruption            | Global | pu value of the threshold of interruption                    |
| Threshold_Hysteresis              | Global | pu value of the hysteresis                                   |
| start_time                        | Global | Start time of the data                                       |
| GENRPT                            | Global | To tell wether to use the report generator or not            |
| Ts                                | Global | Sampling period                                              |
| listing                           | Global | The file list of the data folder                             |
| len                               | Global | The length of *listing*                                      |
| U_avg                             | Global | Average voltage (using the time interval for stationary disturbance ) |
| U_rms                             | Global | RMS voltage (using the time interval for stationary disturbance ) |
| I_avg_L1/2/3                      | Global | Average current (using the time interval for stationary disturbance ) |
| I_rms_L1/2/3                      | Global | Average current (using the time interval for stationary disturbance ) |
| U_rms_10ms                        | Global | RMS voltage (using the time interval for non-stationary disturbances ) |
| I_rms_L1/2/3_10ms                 | Global | RMS current (using the time interval for non-stationary disturbances ) |
| leftover                          | Global | The previous file left data                                  |
| Setting_Times                     | Global | The time stamp of the system setting changed                 |
| Setting                           | Global | The detail of the system setting changed                     |
| isNonStatDistOccur                | Global | To record whether there is non-stationary occur at this moment |
| hysteresis                        | Global | Hysteresis                                                   |
| Swell_tr                          | Global | Threshold used for detect swell                              |
| Dip_tr                            | Global | Threshold used for detect dip                                |
| Interruption_tr                   | Global | Threshold used for detect interruption                       |
| timecount                         | Global | Used to record each non-stationary disturbance event         |
| isSwell                           | Global | To tell whether currently is under the event of swell        |
| isDip                             | Global | To tell whether currently is under the event of dip          |
| isInterruption                    | Global | To tell whether currently is under the event of interruption |
| DipCount                          | Global | Count the number of dip events                               |
| SwellCount                        | Global | Count the number of swell events                             |
| InterruptionCount                 | Global | Count the number of interruption events                      |
| DipTime                           | Global | A vector contains only 1 or 0 to tell the length of each dip |
| SwellTime                         | Global | A vector contains only 1 or 0 to tell the length of each swell |
| InterruptionTime                  | Global | A vector contains only 1 or 0 to tell the length of each interruption |
| DipSpec                           | Global | A vector contains the voltage during each dip, one colum for one event |
| SwellSpec                         | Global | A vector contains the voltage during each swell, one colum for one event |
| InterruptionSpec                  | Global | A vector contains the voltage during each interruption, one colum for one event |
| Dip                               | Global | A vector used to mark each event happening time, use the length of *U_rms* and current number of loops and number of the data |
| Swell                             | Global | A vector used to mark each event happening time, use the length of *U_rms* and current number of loops and number of the data |
| Interruption                      | Global | A vector used to mark each event happening time, use the length of *U_rms* and current number of loops and number of the data |
| U_ripple                          | Global | Ripple voltage                                               |
| RDF_Voltage                       | Global | Voltage RDF                                                  |
| RMS_Ripple_Factor_Voltage         | Global | Voltage RMS ripple factor                                    |
| Peak_Ripple_Factor_Voltage        | Global | Voltage peak ripple factor                                   |
| I_ripple_L1/2/3                   | Global | Ripple current                                               |
| RDF_L1/2/3                        | Global | Current RDF                                                  |
| RMS_Ripple_Factor_L1/2/3          | Global | Current RMS ripple factor                                    |
| Peak_Ripple_Factor_L1/2/3         | Global | Current peak ripple factor                                   |
| Swell_time                        | Global | A vector stores the duration of each swell                   |
| Swell_spec                        | Global | A vector stores the maximum voltage of each swell            |
| Dip_time                          | Global | A vector stores the duration of each dip                     |
| Dip_spec                          | Global | A vector stores the minimum voltage of each dip              |
| Interruption_time                 | Global | A vector stores the duration of each interruption            |
| Interruption_spec                 | Global | A vector stores the minimum voltage of each interruption     |
| Swell_timesum                     | Global | The total length of swell                                    |
| Dip_timesum                       | Global | The total length of dip                                      |
| Interruption_timesum              | Global | The total length of interruption                             |
| time_Short_SS                     | Global | Time stamp for the non-stationary disturbances, which is the shorter interval one. Unit in millisecond |
| time_Short_Cell                   | Global | Time stamp for the non-stationary disturbances, which is the shorter interval one. In *Cell* format |
| time_Short                        | Global | Time stamp for the non-stationary disturbances, which is the shorter interval one. |
| time_Long_SS                      | Global | Time stamp for the stationary disturbances, which is the longer interval one. Unit in millisecond |
| time_Long_Cell                    | Global | Time stamp for the stationary disturbances, which is the longer interval one. In *Cell* format |
| time_Long                         | Global | Time stamp for the stationary disturbances, which is the longer interval one. |
| U_rms_10ms                        | Global | RMS voltage (using the time interval for non-stationary disturbance ) |
| I_rms_L1/2/3_10ms                 | Global | RMS current (using the time interval for non-stationary disturbance ) |
| Status                            | Global | The status of the system, of each sample, NaN used here to represent normal. Used to plot the figure to tell when the non-stationary disturbance happened |
| rptname                           | Global | Report name                                                  |
| rpt                               | Global | The report                                                   |
| PubDate                           | Global | Report generate date, which is the computer local time       |
| OA_1/2/3/4/5                      | Global | Variables used to write sentences in report                  |
| Pie_Data                          | Global | Each event's percentile to the whole data                    |
| CH_1/2/3/4/5/6/7/8                | Global | Variables used to write sentences in report                  |
| disp_starttime                    | Global | The start time of the selkected event                        |
| disp_endtime                      | Global | The end time of the selkected event                          |
| Tolerance_Within1                 | Global | The length of time of the disturbance within the tolerance 1 |
| Tolerance_Within2                 | Global | The length of time of the disturbance within the tolerance 2 |
| Tolerance_Without                 | Global | The length of time of the disturbance without the tolerance  |
| Tolerance_Spec                    | Global | The voltage data of the selected event                       |
| dist_len                          | Global | The duration of the select event, used for identify transient event to mitigate causing issue when calculating distribution when the input data length is 1 |
| Table2Disp                        | Global | The system setting table that will be displayed in the report |
| TableTitle                        | Global | The heading line of the system setting table that will be displayed in the report |
| TableNum                          | Global | The number column of the system setting table that will be displayed in the report |
| table1                            | Global | The system setting table                                     |
| Small_interval                    | Global | A column vector with the length same as the shorter interval one, used for split the data regarding to the system setting time tp generate boxcplot |
| Large_interval                    | Global | A column vector with the length same as the longerer interval one, used for split the data regarding to the system setting time tp generate boxcplot |
| start_5MS                         | Global | The location number of when the the setting in the shorter time interval starts |
| start_200MS                       | Global | The location number of when the the setting in the longer time interval starts |
| termin_5MS                        | Global | The location number of when the the setting in the shorter time interval ends |
| termin_200MS                      | Global | The location number of when the the setting in the longer time interva ends |
| I_Atool_start                     | Global | Sentence display to ask the user                             |
| Usr_input                         | Global | User input                                                   |
| I_Atool_end                       | Global | Sentence display to ask the user                             |
| Usr_input_2                       | Global | User input                                                   |
| I_Atool                           | Global | Sentence display to ask the user                             |
| Usr_input_3                       | Global | User input                                                   |
| num                               | Global | To mark the number of current opening data file              |
| Name                              | Local  | The name of current opening data file                        |
| data                              | Local  | The raw data                                                 |
| L1_Voltage                        | Local  | Voltage data of the file                                     |
| L1_Current                        | Local  | Current data of the file                                     |
| L2_Current                        | Local  | Current data of the file                                     |
| L3_Current                        | Local  | Current data of the file                                     |
| num_groups                        | Local  | The number of the loops                                      |
| Data_Voltage                      | Local  | Voltage data by adding the *leftover* data                   |
| Data_L1_Current                   | Local  | Current data by adding the *leftover* data                   |
| Data_L2_Current                   | Local  | Current data by adding the *leftover* data                   |
| Data_L3_Current                   | Local  | Current data by adding the *leftover* data                   |
| num_Sample                        | Local  | Number of the Stationary disturbance block (i.e. number of loops) |
| docount                           | Local  | Current loop number                                          |
| voltage                           | Local  | Voltage data of the current loop                             |
| current_L1                        | Local  | Current data of the current loop                             |
| current_L2                        | Local  | Current data of the current loop                             |
| current_L3                        | Local  | Current data of the current loop                             |
| Urms_nonStat_sample               | Local  | RMS voltage (using the time interval for non-stationary disturbances ) of the current loop |
| Urms_sample                       | Local  | RMS voltage (using the time interval for stationary disturbances ) of the current loop |
| Uavg_sample                       | Local  | Average voltage (using the time interval for stationary disturbances ) of the current loop |
| current_mean_sample_L1/2/3        | Local  | Average current (using the time interval for stationary disturbances ) of the current loop |
| current_rms_sample_L1/2/3         | Local  | Average current (using the time interval for stationary disturbances ) of the current loop |
| RDF_Voltage_sample                | Local  | Voiltage RDF of the current loop                             |
| Peak_Ripple_Factor_Voltage_sample | Local  | Voltage RMS ripple factor of the current loop                |
| RMS_Ripple_Factor_Voltage_sample  | Local  | Voltage peak ripple factorr of the current loop              |
| RDF_L1/2/3_sample                 | Local  | Current RDF of the current loop                              |
| Peak_Ripple_Factor_L1/2/3_sample  | Local  | Current peak ripple factorr of the current loop              |
| RMS_Ripple_Factor_L1/2/3_sample   | Local  | Current RMS ripple factor of the current loop                |
| i/j/k/P/L/Y/temp/Temp             | Local  | Temporary data                                               |