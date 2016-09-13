# =============================================================================
# Federal University of Rio Grande do Sul (UFRGS)
# Connectionist Artificial Intelligence Laboratory (LIAC)
# Renato de Pontes Pereira - rppereira@inf.ufrgs.br
# =============================================================================
# Copyright (c) 2013 Renato de Pontes Pereira, renato.ppontes at gmail dot com
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy 
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights 
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
# copies of the Software, and to permit persons to whom the Software is 
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in 
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# =============================================================================

'''
This is a full Ratslam implementation in python. This implementation is based 
on Milford's original implementation [1]_ in matlab, and Christine Lee's python 
implementation [2]_. The original data movies can also be found in [1]_.

This file is the only dependent of OpenCV, which is used to open and convert 
the movie files. Thus, you can change only this file to use other media API.

.. [1] https://wiki.qut.edu.au/display/cyphy/RatSLAM+MATLAB
.. [2] https://github.com/coxlab/ratslam-python
'''

import cv2
import numpy as np
from matplotlib import pyplot as plot
import mpl_toolkits.mplot3d.axes3d as p3
import time
import ratslam

if __name__ == '__main__':
    # Change this line to open other movies
    data = r'/home/rose/stlucia_testloop.avi'
    data = r'/home/rose/stlucia_0to21000.avi'
    #data = r'/home/rose/uqaxon5_0to25000.avi'
    f = open(data+'.time','w')

    video = cv2.VideoCapture(data)
    slam = ratslam.Ratslam(data)
    
    loop = 0
    _, frame = video.read()
    time_start = time.time()
    while True:
        loop += 1

        # RUN A RATSLAM ITERATION ==================================
        _, frame = video.read()
        if frame is None: break

	time_start_digest = time.time()
        img = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
	#img=cv2.resize(img,None,fx=0.125, fy=0.125, interpolation = cv2.INTER_AREA)	
	slam.digest(img)
	time_end_digest = time.time()
	#print "%f" % (time_end_digest - time_start_digest)
        f.write(str(time_end_digest - time_start_digest)+'\n')
	# ==========================================================

        # Plot each 50 frames
        if loop%50 != 0:
            continue

        # PLOT THE CURRENT RESULTS =================================
        b, g, r = cv2.split(frame)
        rgb_frame = cv2.merge([r, g, b])

        plot.clf()

        # RAW IMAGE -------------------
        ax = plot.subplot(2, 2, 1)
        plot.title('RAW IMAGE')
        plot.imshow(rgb_frame)
        ax.get_xaxis().set_ticks([])
        ax.get_yaxis().set_ticks([])
        # -----------------------------

        # RAW ODOMETRY ----------------
        plot.subplot(2, 2, 2)
        plot.title('RAW ODOMETRY')
        plot.plot(slam.odometry[0], slam.odometry[1])
        plot.plot(slam.odometry[0][-1], slam.odometry[1][-1], 'ko')
        #------------------------------

        # POSE CELL ACTIVATION --------
        ax = plot.subplot(2, 2, 3, projection='3d')
        plot.title('POSE CELL ACTIVATION')
        x, y, th = slam.pc
        ax.plot(x, y, 'x')
        ax.plot3D([0, 60], [y[-1], y[-1]], [th[-1], th[-1]], 'K')
        ax.plot3D([x[-1], x[-1]], [0, 60], [th[-1], th[-1]], 'K')
        ax.plot3D([x[-1], x[-1]], [y[-1], y[-1]], [0, 36], 'K')
        ax.plot3D([x[-1]], [y[-1]], [th[-1]], 'mo')
        ax.grid()
        ax.axis([0, 60, 0, 60]);
        ax.set_zlim(0, 36)
        # -----------------------------

        # EXPERIENCE MAP --------------
        plot.subplot(2, 2, 4)
        plot.title('EXPERIENCE MAP')
        xs = []
        ys = []
        for exp in slam.experience_map.exps:
            xs.append(exp.x_m)
            ys.append(exp.y_m)

        plot.plot(xs, ys, 'bo')
        plot.plot(slam.experience_map.current_exp.x_m,
                  slam.experience_map.current_exp.y_m, 'ko')
        # -----------------------------

        plot.tight_layout()
        # plot.savefig('C:\\Users\\Renato\\Desktop\\results\\forgif\\' + '%04d.jpg'%loop)
        plot.pause(0.01)
        # ==========================================================

    f.close()
    print 'DONE!'
    print 'n_ templates:', len(slam.view_cells.cells)
    print 'n_ experiences:', len(slam.experience_map.exps)
    plot.show()
    f = open(data+'.time','r')
    x = np.genfromtxt(f) 
    plot.plot(x)
    plot.title("computation time per frame")
    plot.show()
