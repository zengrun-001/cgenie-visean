# cGENIE 维宪期（330 Ma）—— GitHub Actions 一键构建/运行

不需要 HPC、不需要 Colab、不需要本地装 Linux。只要有 GitHub 账号即可。

## 一、创建仓库（网页操作，2 分钟）

1. 打开 https://github.com/new ，仓库名填 `cgenie-visean`，选 **Public**（公开仓库 Actions 分钟数不限），
   勾选 “Add a README file”，点 **Create repository**。
2. 在本页点 **Add file → Upload files**，把本文件夹里的内容**整个拖进去**（保持目录结构）：
   ```
   .github/workflows/cgenie.yml
   scripts/make_config.sh
   inputs/seddem_330Ma_36x36.txt
   inputs/shelf_frac_330Ma_36x36.txt
   inputs/cgenie_forcing_visean.csv
   ```
   点 **Commit changes**。

> 提示：GitHub 网页上传支持拖拽整个文件夹；若 `.github` 目录拖不进去，
> 用 “Add file → Create new file”，文件名输入 `.github/workflows/cgenie.yml`，粘贴内容即可。

## 二、运行

- 上传后会自动触发一次（`on: push`）。
- 也可手动：**Actions → Build cGENIE (muffin) → Run workflow**。
- 想直接跑模型：在 **Run workflow** 的 `run_years` 里填 `1000`（先别贪多），点运行。

## 三、看结果

- 构建约 **10–15 分钟**（首次含 clone，约 20 分钟）。
- 跑完后在该次运行的页面底部 **Artifacts** 下载 `cgenie-build`，里面有：
  - `genie.exe`（编译好的模型）
  - `configs/`（含生成的 `p0320c` 配置）
  - `cgenie_output/`（若跑了模型，含 NetCDF 结果）
- 构建失败时也照样上传日志与中间产物，把 `Actions` 页面里红色步骤的日志贴给我即可。

## 四、这套流程做了什么

| 步骤 | 内容 |
|---|---|
| 1 | `apt-get install gfortran libnetcdff-dev make`（Ubuntu 的 netCDF-Fortran 是 gfortran 版，解决 Windows 上的 `.mod` 不兼容） |
| 2 | `git clone --depth 1 cgenie.muffin`，并用 cache 加速后续运行 |
| 3 | `sed` 修补 `finc.py`（Python2 → Python3，不修必失败） |
| 4 | `make NETCDF_DIR=/usr NETCDF_NAME=netcdff` |
| 5 | 确认自带 `genie-paleo/320ebP2_`（320 Ma 古地理，最接近 330 Ma） |
| 6 | 由 `p0251b` 模板生成 `p0320c`：替换古地理前缀、pCO2=560 ppmv、solconst=1338、O2=1.0 PAL |
| 7 | 可选：`runmuffin.sh p0320c BASES RUN330 <年数>` |
| 8 | 打包 `genie.exe`、配置、输出，上传 artifact |

## 五、下一步（我这边）

首次构建绿了之后，我需要你回传两样东西：
1. **构建日志**（尤其第 4 步 tail 的 30 行）；
2. 若跑了模型：**`Actions` 里 `runmuffin.sh` 那段输出**。

拿到日志我就能把 320 Ma 配置改成真正的维宪期设定（把我们的 `seddem_330Ma` 接进去、按 Ⅰ/Ⅱ/Ⅲ 三阶段扫强迫），出图也由我完成。

## 六、预算

GitHub Actions 公开仓库**免费不限分钟**；单次任务上限 6 小时，足够一次 3 000–5 000 年积分。
