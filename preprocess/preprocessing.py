from PIL import Image
import os
import json
import numpy

def normal(mean, stddev):
    def result(x):
        if stddev == 0:
            z = 0
        else:
            z = (x - mean)/stddev
        if z > 4:
            z = 4
        if z < -4:
            z = -4
        z *= 32
        z += 127
        if z < 0:
            z = 0
        return z
    return result

numpy.set_printoptions(threshold=numpy.nan)
j = open('../settings/cnn_settings.json')
d = json.load(j)
j.close()
j = open('../settings/test_preprocess.json')
path = json.load(j)['pic_path']
j.close()
img = Image.open(path)
print(file)
newimg = img.resize((d[0],d[1]),Image.ANTIALIAS)
newimg2 = newimg.convert('L')
colors = [numpy.matrix([[b[0] for b in a] for a in numpy.array(newimg)]), numpy.matrix([[b[1] for b in a] for a in numpy.array(newimg)]), numpy.matrix([[b[2] for b in a] for a in numpy.array(newimg)]),numpy.matrix(numpy.array(newimg2))]
for i in range(0,3):
    normalize = normal(numpy.mean(colors[i]),numpy.std(colors[i]))
    normalize = numpy.vectorize(normalize)
    colors[i] = normalize(colors[i])
temp = []       
for x in range(0,d['size'][0]):
    for y in range(0,d['size'][1]):
        if x == 0 or x == d['size'][0]-1 or y == 0 or y == d['size'][1]-1:
            if y == 0:
                temp += [[255]]
            else:
                temp[x] += [255]
        else:
            lx = -0.5*colors[3].A[x-1][y]+0.5*colors[3].A[x+1][y]
            ly = -0.5*colors[3].A[x][y-1]+0.5*colors[3].A[x][y+1]
            magn_grad = (lx**2+ly**2)**0.5
            if magn_grad > 10:
                temp[x] += [0]
            else:
                temp[x] += [255]
        
colors[3] = numpy.matrix(temp)
json1 = open('../processed_test_pic/pic.json','w')
json1.write(str([b.A.tolist() for b in colors]))
json1.close()
os.system('th ../cnn/test.lua')
