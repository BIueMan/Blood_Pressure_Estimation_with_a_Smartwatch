import torch.nn as nn

'''
modified to fit dataset size
'''
NUM_CLASSES = 10
NUM_CLASSES = 9
#NUM_CLASSES = 15
#NUM_CLASSES = 29
NUM_CLASSES = 19

class AlexNet_Siamese_Reg(nn.Module):
    def __init__(self, num_classes=NUM_CLASSES):
        super(AlexNet_Siamese_Reg, self).__init__()
        self.features = nn.Sequential(
            nn.Conv2d(3, 96, kernel_size=11, stride=4, padding=0),

            nn.BatchNorm2d(96),
            nn.ReLU(inplace=True),

            nn.MaxPool2d(kernel_size=3, stride=2),
            nn.Conv2d(96, 256, kernel_size=5, stride=1, padding=2),

            nn.BatchNorm2d(256),
            nn.ReLU(inplace=True),

            nn.MaxPool2d(kernel_size=3, stride=2),
            nn.Conv2d(256, 384, kernel_size=3, stride=1, padding=1),

            nn.BatchNorm2d(384),
            nn.ReLU(inplace=True),

            nn.Conv2d(384, 384, kernel_size=3, stride=1, padding=1),

            nn.BatchNorm2d(384),
            nn.ReLU(inplace=True),

            nn.Conv2d(384, 256, kernel_size=3, stride=1, padding=1),

            nn.BatchNorm2d(256),
            nn.ReLU(inplace=True),

            nn.MaxPool2d(kernel_size=3, stride=2),
        )
        self.classifier = nn.Sequential(
            nn.Dropout(),
            # nn.Linear(256 * 41 * 54, 4096),
            #nn.Linear(9216, 4096),
            nn.Linear(1024, 4096),
            nn.ReLU(inplace=True),
            nn.Dropout(),



            #nn.Linear(4096, 4096),



            nn.Linear(4096, 64),
            #nn.ReLU(inplace=True),
            #nn.Linear(4096, num_classes),
            #nn.ReLU(inplace=True),
            #nn.Linear(num_classes, 1),
        )

        self.final_classifier = nn.Sequential(
            nn.ReLU(inplace=True),
            #nn.Linear(4096, 1),



            nn.Linear(64, 1),
        )

    def forward_once(self,  x):
        x = self.features(x)
        # x = x.view(x.size(0), 256 * 41 * 54)
        #x = x.view(x.size(0), 9216)
        x = x.view(x.size(0), 1024)
        x = self.classifier(x)
        return x

    def forward(self, input1, input2):
        output1 = self.forward_once(input1)
        output2 = self.forward_once(input2)
        x = output2-output1



        #x = x.view(x.size(0), 4096)



        x = x.view(x.size(0), 64)
        x = self.final_classifier(x)
        return x