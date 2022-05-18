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
# give a path to the direct where all the images_train are in "dir_path_train"
dir_path_train = "datatest//projectB//data_2021//train"
dir_path_test = "datatest//projectB//data_2021//test"
## params to train
# to optimizer
learning_rate = 0.0001

num_epoch = 30  # number of trainings
batch_size = 1

"""##########################"""

""" function """


# TODO: add patches
def train(images, doTrain=True):
    global model_dias, optimizer, criterion, batch_size
    model_dias.train()
    # sum the loss and acuracy to return later
    total_loss = 0.0
    total_accuracy = 0.0
    total_dist = 0.0

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
        total_dist += abs(predicted - label.data).sum()

    # return loss and accuracy
    mean_loss = (total_loss.item() / len(images))
    accuracy = (total_accuracy.item() / len(images) * 100)
    mean_dist = (total_dist.item() / len(images))
    return mean_loss, accuracy, mean_dist


""" this part of the code will take all the images_train in a dir and save it in a dir """
paths_train = []
for (dirpath, dirnames, filenames) in walk(dir_path_train):
    for file in filenames:
        paths_train.append(dirpath + '//' + file)
print("images_train in train: ", len(paths_train))

paths_test = []
for (dirpath, dirnames, filenames) in walk(dir_path_test):
    for file in filenames:
        paths_test.append(dirpath + '//' + file)
print("images_train in train: ", len(paths_test))

mean = np.array([60.67936310044272, 178.48912203419349, 176.8054562010452])
std = np.array([66.21474767078614, 21.58253886942113, 61.06868912089884])

images_train = {}
index = 0
for data_path in paths_train:
    if data_path.split('.')[1] != "png":
        continue
    image = cv2.imread(data_path)  # load
    image = (image - mean) / std  # normalized

    # take diastolic from path
    data_file = data_path.split("//")[-1]
    data_dist = data_file.split("_")[-2]
    name = str(index) + "_" + data_dist

    images_train[name] = torch.tensor(image.T).view(1, 3, 110, 110)  # to torch

    index += 1

images_test = {}
index = 0
for data_path in paths_test:
    if data_path.split('.')[1] != "png":
        continue
    image = cv2.imread(data_path)  # load
    image = (image - mean) / std  # normalized

    # take diastolic from path
    data_file = data_path.split("//")[-1]
    data_dist = data_file.split("_")[-2]
    name = str(index) + "_" + data_dist

    images_test[name] = torch.tensor(image.T).view(1, 3, 110, 110)  # to torch

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
sd = torch.load("model_dias.pth").state_dict()
# build a second model with drop out close to 0
model_dias = AlexNetReg_Drop0()
# load params
model_dias.load_state_dict(sd)
""" the transferLearning part """
# len of the NN, we want to grad=False only on the first layers (if 26 then 23)
i = 1
for param in model_dias.parameters():
    if i >= 23:
        param.requires_grad = False
    i += 1

""" switch the end  of the model (classifier) with diffrent one """
model_dias.classifier = nn.Linear(1024,1)

# after we set what we want to learn, send the model to device
model_dias.to(device)

""" val will stop the dropout layer from droping """
# model_dias.eval()

print(model_dias)


## set optimizer and traning
optimizer = torch.optim.Adam(model_dias.parameters(), lr=learning_rate)
criterion = nn.L1Loss()

## training
train_losses = []
train_accuracy = []
train_dist = []
test_losses_test = []
test_accuracy = []
test_dist = []
for epoch in range(num_epoch):  # loop over the dataset multiple times
    mean_loss, accuracy, mean_dist = train(images_train)
    train_losses.append(mean_loss)
    train_accuracy.append(accuracy)
    train_dist.append(mean_dist)

    ## TODO: test
    mean_loss_test, accuracy_test, mean_dist_test = train(images_test, False)
    test_losses_test.append(mean_loss_test)
    test_accuracy.append(accuracy_test)
    test_dist.append(mean_dist_test)

    ## TODO: print with test
    print("epoch: " + str(epoch))
    print("train: " + " loss: " + str(mean_loss) + ", accuracy: " + str(accuracy) + ", dist: " + str(mean_dist))
    print("test: " + " loss: " + str(mean_loss_test) + ", accuracy: " + str(accuracy_test) + ", dist: " + str(
        mean_dist_test))

# save model
torch.save(model_dias ,"model_save/model_dias_tranfer_sort.pth")

## plot data
t = range(epoch + 1)

plt.subplot(211)
plt.title("lr = 0.001, dropout = 0.0")
plt.plot(t, train_losses)
plt.plot(t, test_losses_test)
plt.xlabel('epoch')
plt.ylabel('loss')

plt.subplot(212)
plt.plot(t, train_accuracy)
plt.plot(t, test_accuracy)
plt.xlabel('epoch')
plt.ylabel('accuracy')

plt.show()

