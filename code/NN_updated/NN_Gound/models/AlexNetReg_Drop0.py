import torch.nn as nn

'''
modified to fit dataset size
'''
NUM_CLASSES = 10
NUM_CLASSES = 9
NUM_CLASSES = 19
NUM_CLASSES = 91
#NUM_CLASSES = 15
#NUM_CLASSES = 29
#NUM_CLASSES = 19

class AlexNetReg_Drop0(nn.Module):
    def __init__(self, num_classes=NUM_CLASSES):
        super(AlexNetReg_Drop0, self).__init__()
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
            nn.Dropout(p=0.2),
            # nn.Linear(256 * 41 * 54, 4096),
            #nn.Linear(9216, 4096),
            nn.Linear(1024, 4096),
            nn.ReLU(inplace=True),
            nn.Dropout(p=0.2),
            nn.Linear(4096, 4096),
            nn.ReLU(inplace=True),
            nn.Linear(4096, 1),
            #nn.ReLU(inplace=True),
            #nn.Linear(num_classes, 1),
        )

    def forward(self, x):
        x = self.features(x)
        # x = x.view(x.size(0), 256 * 41 * 54)
        #x = x.view(x.size(0), 9216)
        x = x.view(x.size(0), 1024)
        x = self.classifier(x)
        return x

