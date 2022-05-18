""" this code will calculate the normalizeshen params for the data set
    look for mean and std at the end"""
""" first run on 6739 images_train:
    mean = [60.56902843917026, 178.2096092581894, 176.60394177580835]
    std = [68.07073440346251, 25.5210643728452, 62.9439156974439]"""

import os
import numpy as np
from PIL import Image
from tqdm import tqdm

# full path to the directory with all the images_train
path = 'C:/Users/User/Technion/Yair Moshe - project - Blood Pressure Estimation with a Smartwatch/code/preProjectB/data/STFT_images_United'
path = 'C:/Users/User/Technion/Yair Moshe - project - Blood Pressure Estimation with a Smartwatch/code/preProjectB/code/PyTorch/STFT_images_United_ds'

# get path to all the images_train
image_path_list = []
for (dirpath, dirnames, filenames) in os.walk(path):
    for file in filenames:
        image_path_list.append(dirpath + '\\' + file)



# calculate mean and std
R_chan_mean = 0
G_chan_mean = 0
B_chan_mean = 0

R_chan_std = 0
G_chan_std = 0
B_chan_std = 0

for image_path in tqdm(image_path_list):
    #load image
    image = Image.open(image_path)
    image = np.asarray(image.convert("RGB"))
    # split RGB
    R_chan = image[:, :, 0]
    G_chan = image[:, :, 1]
    B_chan = image[:, :, 2]
    # count the mean,std
    R_chan_mean += R_chan.mean()
    G_chan_mean += G_chan.mean()
    B_chan_mean += B_chan.mean()

    R_chan_std += R_chan.std()
    G_chan_std += G_chan.std()
    B_chan_std += B_chan.std()

# finaly we will average ower chans
num_train_files = len(image_path_list)

mean=[R_chan_mean/num_train_files, G_chan_mean/num_train_files, B_chan_mean/num_train_files]
std=[R_chan_std/num_train_files, G_chan_std/num_train_files, B_chan_std/num_train_files]

print(mean, std)