import numpy as np
import torch
import torch.nn as nn
from torch.autograd import Variable
import os
from models import *
from models import AlexNetReg
import cv2
import torch.optim as optim
from torch.utils.data.sampler import SubsetRandomSampler
from os import walk
import matplotlib.pyplot as plt

from models.AlexNetReg_Drop0 import AlexNetReg_Drop0

""" to know 
*   all images_train need to be set to name "name_sys_dis_color.png"
    when name - is the name of the patient
         sys - systolic of the patient
         dis - diastolic of the patient
         color - is color, counst
    the program will take the dis from the name and use it

    """

model_dias = None
optimizer = None
criterion = None
epoch = None
batch_size = None
""" paraps """
# give a path to the direct where all the images_train are in "dir_path_valid"
dir_path_valid = "datatest//projectB//data_2021//valide"
## params to train
# to optimizer
learning_rate = 0.0001

""" function """


# TODO: add patches
def train(images, doTrain=True):
    global model_dias, optimizer, criterion, batch_size
    model_dias.train()
    # sum the loss and acuracy to return later
    total_loss = 0.0
    total_accuracy = 0.0

    dist = []
    i = 0  # running index
    for key, image in images.items():
        # get label from key
        label = key.split("_")[-1]
        label = torch.tensor(float(label))  # TODO: change float to tensor.float()

        # load data to GPU
        image, label = Variable(image.to(device=device, dtype=torch.float)), Variable(
            label.to(device=device, dtype=torch.float))

        ## start training
        # set optinizer
        if doTrain:
            optimizer.zero_grad()
        # forward
        outputs = torch.squeeze(model_dias(image))
        # loss
        loss = criterion(outputs, label)
        dist.append(loss)
        # backward
        if doTrain:
            loss.backward()
            # gardient
            optimizer.step()

        # sum of loss
        total_loss += loss.data

        ## calculate accuracy,
        AD = 6  # Acceptable_Deviation from the true label
        predicted = torch.squeeze(outputs.data)
        total_accuracy += (abs(predicted - label.data) <= AD).sum()

    # return loss and accuracy
    mean_loss = (total_loss.item() / len(images))
    accuracy = (total_accuracy.item() / len(images) * 100)
    return mean_loss, accuracy, dist


""" this part of the code will take all the images_train in a dir and save it in a dir """
paths_valid = []
for (dirpath, dirnames, filenames) in walk(dir_path_valid):
    for file in filenames:
        paths_valid.append(dirpath + '//' + file)
print("images_valid in valid: ", len(paths_valid))


mean = np.array([60.67936310044272, 178.48912203419349, 176.8054562010452])
std = np.array([66.21474767078614, 21.58253886942113, 61.06868912089884])

images_valid = {}
index = 0
for data_path in paths_valid:
    if data_path.split('.')[1] != "png":
        continue
    image = cv2.imread(data_path)  # load
    image = (image - mean) / std  # normalized

    # take diastolic from path
    data_file = data_path.split("//")[-1]
    data_dist = data_file.split("_")[-2]
    name = str(index) + "_" + data_dist

    images_valid[name] = torch.tensor(image.T).view(1, 3, 110, 110)  # to torch

    index += 1



""" load model """
## code start here
# load torch
print("torch version:", torch.__version__)
if torch.cuda.is_available():
    print("cuda version:", torch.version.cuda)
    device = torch.device('cuda:0')
    print("run on GPU.")
else:
    device = torch.device('cpu')
    print("no cuda GPU available")
    print("run on CPU")

## get model Dias
# get param from train model
model_dias = torch.load("model_save/model_dias_tranfer.pth")

# after we set what we want to learn, send the model to device
model_dias.to(device)

""" val will stop the dropout layer from droping """
model_dias.eval()

print(model_dias)

## set optimizer and traning
optimizer = torch.optim.Adam(model_dias.parameters(), lr=learning_rate)
criterion = nn.L1Loss()

## valid
mean_loss_test, accuracy_test, dist = train(images_valid, False)

""" mean of images """
"""sum_labels = 0
for key, image in images_valid.items():
    label = key.split("_")[-1]
    label = float(label)
    sum_labels += label
"""
mean_labels = 121.19130434782609

# loss for mean
loss_mean = []
labels = []
mean_line = []
for key, image in images_valid.items():
    label = key.split("_")[-1]
    label = float(label)

    labels.append(label)
    loss_mean.append(abs(label-mean_labels))
    mean_line.append(mean_labels)

""" plot """
plt.title("Transfer Learning valid, loss for evey image")
plt.stem(dist, use_line_collection = True)
plt.xlabel('image')
plt.ylabel('loss')
plt.axis([0,20,0,40])
plt.show()

plt.title("mean valid, loss for evey image")
plt.stem(loss_mean, use_line_collection = True)
plt.xlabel('image')
plt.ylabel('diastolic')
plt.axis([0,20,0,40])
plt.show()

print("accuracy: ", accuracy_test)
print("loss: ",mean_loss_test)
accuracy_mean = 0
for label in labels:
    if abs(label-mean_labels)<5:
        accuracy_mean += 1
accuracy_mean = accuracy_mean/len(labels) *100
print("accuracy_mean: ", accuracy_mean)
print("loss_mean: ", sum(loss_mean)/len(loss_mean))