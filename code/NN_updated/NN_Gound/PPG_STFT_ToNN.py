import numpy as np
import torch
import torch.nn as nn
from torch.autograd import Variable
import os
from models import *
from models import AlexNetReg
import cv2
from torch.utils.data.sampler import SubsetRandomSampler

""" the input image of the NN is an image of size (3,110,110)
    save the path to the image here:
"""
## params:
#paths_train = ["datatest//projectB//40//patientid_3603778__data_00004175__sys_44.8975__dias_44.0873__pulse_88.2353.png"]
paths = ["datatest//projectB//dans_30_12_20//Dan_1_113_63_color.png",
             "datatest//projectB//dans_30_12_20//Dan_2_124_66_color.png",
             "datatest//projectB//dans_30_12_20//Dan_3_138_71_color.png",
             "datatest//projectB//dans_30_12_20//Dan_4_140_71_color.png",
             "datatest//projectB//dans_30_12_20//Dan_5_153_77_color.png"]

from os import walk
# give a path to the direct where all the images_train are in "dir_path_train"
dir_path = "datatest//projectB//data_3_1_21"
paths = []
for (dirpath, dirnames, filenames) in walk(dir_path):
    for file in filenames:
        paths.append(dir_path + '//' + file)



mean = np.array([60.67936310044272, 178.48912203419349, 176.8054562010452])
std = np.array([66.21474767078614, 21.58253886942113, 61.06868912089884])

## code start here
# load torch
print("torch version:",torch.__version__)
if torch.cuda.is_available():
    print("cuda version:", torch.version.cuda)
    device = torch.device('cuda:0')
    print("run on GPU.")
else:
    device = torch.device('cpu')
    print("no cuda GPU available")
    print("run on CPU")

# get model Dias
model_dias = torch.load("model_dias.pth")
model_dias.to(device)
model_dias.cuda()
model_dias.train()

""" can print the model """
print(model_dias)

## forword
for data_path in paths:
    image = cv2.imread(data_path) #load
    image = (image-mean)/std # normalized

    data = torch.tensor(image.T).view(1,3,110,110)

    # print(data.size())
    data = data.to(device=device, dtype=torch.float)
    data = Variable(data.cuda(device))

    output = model_dias(data)
    print(data_path + " - diastolic:")
    print(output.item())
"""
# get model Sys
model_sys = torch.load("model_sys.pth")
model_sys.to(device)
model_sys.cuda()
model_sys.train()

# print(model_sys)

## forword
output = model_sys(data)
print("systolic:")
print(output.item())
"""