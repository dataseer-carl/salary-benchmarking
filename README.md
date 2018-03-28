# salary-benchmarking
Scenario for HR Employee Attrition by Power BI

> **Environment paths**
>
> | | |
> |--:|:--|
> | `repo://` | [GitHub](https://github.com/dataseer-carl/salary-benchmarking.git)
> | `data://` | [GDrive](https://drive.google.com/drive/folders/1PCSugzs0MUHa6sEpa8GM0UiPwTaImvUy?usp=sharing) |
> | Tracker | Trello |

## Data files

### Raw

| Data name | Description | Documentation | Data filepath | GDrive ID |
|:--|:--|:--|:--|:--|
| *Employee records* | Consolidated HR datasets | [datalake://HR Employee Attrition/Scenarios/Salary Benchmarking](https://github.com/dataseer-carl/dataseer-datalake/blob/master/IBM%20Watson/HR%20Employee%20Attrition/Scenarios/Salary%20Benchmarking/readme.md) | [`data:///raw/WA_Fn-UseC_-HR-Employee-Attrition.csv`](https://drive.google.com/file/d/1sxojpwo5KUzvF4JuR3fUUul27fsxWF1g/view) |`1sxojpwo5KUzvF4JuR3fUUul27fsxWF1g`|

### Ingested and parsed

| Data name | Description | Data filepath | GDrive ID | Input data | Processing script |
|:--|:--|:--|:--|:--|:--|
| *Parsed employee records* | Parsed ingest of *Employee records* | [`data:///data00_raw ingest.rds`](https://drive.google.com/open?id=1xwIsARVUV_vMBkP_L4uYSsKCOsQyMDeP) |`1xwIsARVUV_vMBkP_L4uYSsKCOsQyMDeP`| *Employee records* | `script00_data.R` |
| `current.df` | Train dataset | [`data:///data01_split data.RData`](https://drive.google.com/open?id=1Zs5YOEdOCemlcMMrwdDKl8qkHTfSZRL_) | `1Zs5YOEdOCemlcMMrwdDKl8qkHTfSZRL_` | *Parsed employee records* | `script01_EDA.R` |
| `new.ls$DoNotShow` | Test dataset with response | [`data:///data01_split data.RData`](https://drive.google.com/open?id=1Zs5YOEdOCemlcMMrwdDKl8qkHTfSZRL_) | `1Zs5YOEdOCemlcMMrwdDKl8qkHTfSZRL_` | *Parsed employee records* | `script01_EDA.R` |
| `new.CanShow` | Test dataset without response | [`data:///data01_split data.RData`](https://drive.google.com/open?id=1Zs5YOEdOCemlcMMrwdDKl8qkHTfSZRL_) | `1Zs5YOEdOCemlcMMrwdDKl8qkHTfSZRL_` | *Parsed employee records* | `script01_EDA.R` |


## Plots

| Plot description | Data filepath | Input data | Processing script |
|:--|:--|:--|:--|:--|:--|
| Bivariate matrix | `repo:///Plots/plot00_pairs.png` | *Parsed employee records* | `script01_EDA.R` |

## Models

| Response | Model | Filepath | Input data | Processing script | GDrive ID |
|:-:|:-:|:--|:--|:--|:-:|
| MonthlyIncome | OLS | [`data://model00_OLS-pilot.rds`](https://drive.google.com/open?id=1i5K67XPmtY1fYX2LG_gFjBU18VgELf2y) | `current.df`, `new.ls$DoNotShow` | `script02_OLS.R` | `1i5K67XPmtY1fYX2LG_gFjBU18VgELf2y` |