import cv2
import numpy as np
from matplotlib import pyplot as plot
import mpl_toolkits.mplot3d.axes3d as p3
import time
import ratslam

data = r'/home/rose/stlucia_testloop.avi'
data = r'/home/rose/stlucia_0to21000.avi'
#data = r'/home/rose/uqaxon5_0to25000.avi'

f = open(data+'.profile','r')
x = np.genfromtxt(f) 
legend =['total', 'view_cell', 'visual_odometry', 'post_cells', 'experience_map']
for i in range(0,5):
	plot.plot(x[:,i],label=legend[i])

plot.title("computation time per frame")
plot.legend()
plot.show()
 
