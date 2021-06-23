# Setting and running DL codes on ITSC


This file introduces how to set the environment for running this repo.
It also provides a reference for setting and running on your own workstations.

#### Step 1: Login in ITSC

Connect ITSC and login in with you account Install 

    ssh sID@chpc-login01.itsc.cuhk.edu.hk
    input password
    
#### Step 2: install packages and dependencies

Install python using miniconda 

    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    sh Miniconda3-latest-Linux-x86_64.sh -p $HOME/programs/miniconda3 -b

Also, set the PATH in .bashrc, for example:

    vim ~/.bashrc
    i #input mode
    PATH="${HOME}/programs/miniconda3/bin:$PATH"

Press Esc
   
    :wq   
    source ~/.bashrc    
    
    
Install tensorflow 1.14 (a relative old version) for running [DeepLabv3+](https://github.com/tensorflow/models/tree/master/research/deeplab)
    
    conda create -n tf1.14 python=3.7   # need python3.7 or 3.6 (python 3.8 cannot found 1.x version)
    conda (or source) activate tf1.14  # after this step, it will show "tf1.14" at the begin of the line
    # check where is pip by "which pip", making sure it is under the environment of tf1.14
    pip install tensorflow-gpu==1.14   # for GPU version  or 
    #pip install tensorflow==1.14       # for CPU version
    pip install tf_slim==1.0.0       # 1.0.0 is required by mobilenet_v3
    pip install numpy==1.16.4       # use a relative old version to avoid warning.
    pip install gast==0.2.2         # use a relative old version to avoid warning.
    pip install pillow
    pip install opencv-python==3.4.6.27 (choose a earlier verion to avoid error)
    pip install conda
    conda install gdal
    pip install rasterio
    
    which python  # output the path of python then set tf1x_python in network parameter (e.g., deeplabv3plus_xception65.ini):
    tf1x_python  = ~/programs/anaconda3/envs/tf1.14/bin/python 

Install other python packages under tf.14 (suggested) or default python. <!-- The installation will run inside 
the container, so we need to submit a job for running singularity. -->
    
    pip install pyshp==1.2.12
    pip install rasterstats
    pip install imgaug==0.4.0
    pip install geopandas
    pip install GPUtil
    pip install sklearn
    pip install tf_slim
    pip install shapely
    pip install openpyxl
    pip install xlsxwriter
    pip install psutil


If we run the GPU version of tensorflow 1.14, we need to install CUDA and cuDNN (on Ubuntu). 

Install CUDA 10.0 and cuDNN 7.4, these are required by tensorflow 1.14. \
Ubuntu 18 or 20 already may have CUDA 10.0 or 10.2 installed.
They should be downloaded via NVIDIA website, but for this tutorial, you can download them
from my Dropbox. 
    
    wget https://www.dropbox.com/s/7hovzayglxzjwhj/cuda-10.0.tar.gz?dl=0 --output-document=cuda-10.0.tar.gz
    wget https://www.dropbox.com/s/3tuetbaf29umonp/cuDNN_7.4_cuda10.tar.gz?dl=0  --output-document=cuDNN_7.4_cuda10.tar.gz
Then we unpack them to the folder "programs"
 
    mkdir -p programs
    tar xvf cuDNN_7.4_cuda10.tar.gz -C programs
    tar xvf cuda-10.0.tar.gz -C programs


    


#### Step 3: Clone codes from GitHub:

    git clone https://github.com/yghlc/Landuse_DL ./codes_demo/PycharmProjects/Landuse_DL
    git clone https://github.com/yghlc/DeeplabforRS ./codes_demo/PycharmProjects/DeeplabforRS
    git clone https://github.com/yghlc/models.git ./codes_demo/PycharmProjects/tensorflow/yghlc_tf_model
    
    # then set the tensorflow research in the network parameter (e.g.,, deeplabv3plus_xception65.ini):
    tf_research_dir = ~/codes/PycharmProjects/tensorflow/yghlc_tf_model/research
    

#### Step 4: Download pre-trained model

DeepLabv3+ provides some [pre-trained model](https://github.com/tensorflow/models/blob/master/research/deeplab/g3doc/model_zoo.md), 
in this tutorial, we use one of them and download it to *Data*

    mkdir -p ./Data/deeplab/v3+/pre-trained_model
    wget https://www.dropbox.com/s/0h7g5cjyvxywkt1/deeplabv3_xception_2018_01_04.tar.gz?dl=0 --output-document=./Data/deeplab/v3+/pre-trained_model/deeplabv3_xception_2018_01_04.tar.gz

## Run training, prediction, and post-processing

To start an experiment, each time you login in th ITSC

    source activate
    conda activate tf1.14 # after this step, it will show "tf1.14" at the begin of the line,making sure it is under the environment of tf1.14
    
Make a working folder under *project/LinLiu/*

    cd /project/LinLiu/
    mkdir yourownfolder
    cd yourownfolder
    mkdir test_deeplabV3+_1_GL
    cd test_deeplabV3+_1_GL
    
After the environment for running Landuse_DL is ready, you can start training your model as well as prediction. 
Suppose your working folder is *test_deeplabV3+_1*, in this folder, a list of files should be presented:
    
    exe.sh
    main_para.ini
    study_area_1.ini
    deeplabv3plus_xception65.ini
    singularity.sh
    run_INsingularity_miniconda.sh

*exe.sh* is a script for running the whole process, including preparing training images, 
training, prediction, and post-processing. You may want to comment out some of the lines in this file 
if you just want to run a few steps of them. This file can be copied from *Landuse_DL/working_dir/exe.sh*.
In this file, you may also need to modify some input files, such as change *para_qtp.ini* to *para.ini*, 
comment out lines related to *PATH* and *CUDA_VISIBLE_DEVICES*. <!--, and the value of *gpu_num*. -->


*main_para.ini* is the file where you define main parameters. Please edit it accordingly. 
An example of *main_para.ini* is available at *Landuse_DL/working_dir/main_para.ini*.

*study_area_1.ini* is a file to define a study region, including training polygons, images, 
and elevation files (if available). Please edit it accordingly. We can have multiple region-defined files. 

*deeplabv3plus_xception65.ini* is the file to define the deep learning network and some training parameters. 
Please edit it accordingly.

*singularity.sh* is the file of batch-job submission script.
Please edit the job name ( #SBATCH -J ) and notified mail address ( #SBATCH --mail-user=) accordingly

*run_INsingularity_miniconda.sh* is the file to set the running codes an SINGULARITYENV_PATH 

The above files can be copies from */project/LinLiu/demo_carol/test_deeplabV3+_1_example* 

    cp /project/LinLiu/demo_carol/test_deeplabV3+_1_example/exe.sh ./
    cp /project/LinLiu/demo_carol/test_deeplabV3+_1_example/main_para.ini ./
    cp /project/LinLiu/demo_carol/test_deeplabV3+_1_example/poiqu_rgb_2018.ini ./
    cp /project/LinLiu/demo_carol/test_deeplabV3+_1_example/poiqu_rgb_2019.ini ./
    cp /project/LinLiu/demo_carol/test_deeplabV3+_1_example/bhutan_rgb.ini ./
    cp /project/LinLiu/demo_carol/test_deeplabV3+_1_example/deeplabv3plus_xception65.ini ./
    cp /project/LinLiu/demo_carol/test_deeplabV3+_1_example/singularity.sh ./
    cp /project/LinLiu/demo_carol/test_deeplabV3+_1_example/run_INsingularity_miniconda.sh ./



To submit a job,

    sbatch singularity.sh

To view the job status,

    squeue
    
To view the job process,

    vim slurm-"jobID".txt


    
    





