from PIL import Image
import os
import json
import numpy
import sys

j = open(sys.argv[1])
colors = json.load(j)
j.close()
contour = colors[3]
im = Image.fromarray(numpy.array(contour,numpy.uint8),'L')
im.save('result.jpg')
