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
|				  |-evaluator.m
|				  |-config.csv
|				  |-setting.csv
|				  |-setting_time.csv
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

* Please note that the interactive tool would not start if auto report generator is enabled, vise versa. *
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

These two file are not compulsory, but we highly recomment to use them to store the system setting. setting_time.csv is a single column file, each line correspond to one setting change point. The time format is the same as yyyy-MMM-d HH:mm:ss.SSS.
setting.csv stores the description of the system at that time, the height of setting.csv and setting_time.csv should be the same.
