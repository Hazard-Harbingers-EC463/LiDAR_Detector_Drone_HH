import sys
import os
import matplotlib.pyplot as plt
import csv

# python visualize2D.py <.xyz/.csv file> <title> <outputFigFile>
MIN_ARGC = 4

def readXyzFile(name):
    if not os.path.exists(name):
        print("Cover file does not exist.")
        return []
    
    minX, maxX, minY, maxY = float('inf'), 0.0, float('inf'), 0.0
    x, y, z = [], [], []
    with open(name, 'r') as file:
        for line in file:
            x_str, y_str, z_str = line.split(' ')
            
            x.append(float(x_str))
            y.append(float(y_str))
            z.append(float(z_str))
            
            minX = min(minX, x[-1])
            maxX = max(maxX, x[-1])

            minY = min(minY, y[-1])
            maxY = max(maxY, y[-1])
    
    return [x, y, z, minX, maxX, minY, maxY]

def readCsvFile(name):
    x, y, cellCount, height = [], [], [], []
    with open(name, mode='r') as file:
        reader = csv.reader(file)
        for row in reader:
            try:
                _, x_str, y_str, cellCountStr, height_str, _, _ = row
                x.append(float(x_str))
                y.append(float(y_str))
                cellCount.append(int(cellCountStr))
                height.append(float(height_str))
            except:
                pass
    return [x, y, height, cellCount]

def plot2d(content, title, outputFile):
    x, y, z = content[0:3]

    plt.scatter(x, y, c=z, cmap='viridis')

    plt.colorbar(label='Intensity')
    plt.xlabel('X')
    plt.ylabel('Y')
    plt.title(title)

    plt.savefig(outputFile)



argc = len(sys.argv)
if argc < MIN_ARGC:
    print("Please provide at least " + str(MIN_ARGC-1) + " arguments")
    sys.exit()

type = sys.argv[1].split('.')[-1]
title = sys.argv[2]
outputFile = sys.argv[3]
if type == "xyz":
    xyzContent = readXyzFile(sys.argv[1])
    if len(xyzContent) == 0:
        sys.exit()
    plot2d(xyzContent, title, outputFile)
elif type == "csv":
    treeContent = readCsvFile(sys.argv[1])
    plot2d(treeContent, title, outputFile)

    




