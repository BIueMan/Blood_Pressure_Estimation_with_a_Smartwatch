"""NOTE:
warning from modle.load causes from higher version of torch and python, you can ignore them
"""

# TODO: need to find 'mean' and 'std' of the NN. that was use to normalize the data
#     normalize = transforms.Normalize(
#         mean=[R_chan_mean/num_train_files, G_chan_mean/num_train_files, B_chan_mean/num_train_files],
#         std=[R_chan_std/num_train_files, G_chan_std/num_train_files, B_chan_std/num_train_files],
#     )
import numpy as np
import torch
import torch.nn as nn
from torch.autograd import Variable
import os
from models import *
from models import AlexNetReg
import cv2
from torch.utils.data.sampler import SubsetRandomSampler

from models.AlexNetReg_Drop0 import AlexNetReg_Drop0

print("torch version:",torch.__version__)
if torch.cuda.is_available():
    print("cuda version:", torch.version.cuda)
    device = torch.device('cuda:0')
    print("run on GPU.")
else:
    device = torch.device('cpu')
    print("no cuda GPU available")
    print("run on CPU")

# ROOT_PATH = os.path.abspath(os.path.curdir)
# MIMIC_NN_PATH = 'MimicParam\RegDias_128025_91_2020-02-01_12-46-40\model_dias.pth'
# PATH = os.path.join(ROOT_PATH, MIMIC_NN_PATH)


model = torch.load("model_dias.pth")
sd = model.state_dict()
model.to(device)
model.eval()

# load params to diffrent model
model_0 = AlexNetReg_Drop0()
print(model_0)
model_0.load_state_dict(sd)

print(model_0)

data_path = "datatest//projectB//40//patientid_3603778__data_00004175__sys_44.8975__dias_44.0873__pulse_88.2353.png"
image = cv2.imread(data_path)
# image = np.ones((96,3,11,11))
data = torch.tensor(image.T).view(1,3,110,110)
print(data.size())
data = data.to(device=device, dtype=torch.float)
data = Variable(data.cuda(device))

output = model.forward(data)
a = model.features.in_features
########################################################################################################################

data_dir = "datatest\\projectB"

import torchvision
import torchvision.transforms as transforms

normalize = transforms.Normalize(
    mean=[0, 0, 0],
    std=[1, 1, 1],
)

transform = transforms.Compose([
    transforms.ToTensor(),
    normalize,
])

dataset = torchvision.datasets.ImageFolder(
    root=data_dir, transform=transform
)

dias_dict = {}

dias_cnt = 0
for i in range(40,86,1):
    dias_cnt = dias_cnt + 1
    dias_dict.update({i: dias_cnt})

# TODO: make image into input for NN
samples = dataset.samples
cnt = -1
for sample in samples:
    cnt += 1
    filename = sample[0]
    temp = filename.split('_')
    diasBP = round(float((temp[10])))

    sample = list(sample)
    sample[0] = sample[0]
    sample[1] = dias_dict[diasBP]
    dataset.targets[cnt] = dias_dict[diasBP]
    dataset.samples[cnt] = sample

dataset.class_to_idx.clear()

for key, value in dias_dict.items():
    dataset.class_to_idx.update({key: value})

dataset.classes.clear()

for diasBP in range(40, 86, 1):
    dataset.classes.append(diasBP)

test_sampler = SubsetRandomSampler(1)
test_loader = torch.utils.data.DataLoader(
    dataset, batch_size=1, sampler=test_sampler,
    num_workers=0, pin_memory=False,
)
print("the end")


# for data in test_loader:
#images_train, labels = dataset
labels = dataset.samples
images = dataset.imgs[0][0]
labels = dataset.imgs[0][1]
if torch.cuda.is_available():
    images, labels = Variable(images.cuda()), Variable(labels.cuda())
else:
    images, labels = Variable(images), Variable(labels)
outputs = torch.squeeze(model(images))