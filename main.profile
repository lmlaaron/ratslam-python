Timer unit: 1e-06 s

Total time: 182.452 s
File: ../ratslam/__init__.py
Function: digest at line 75

Line #      Hits         Time  Per Hit   % Time  Line Contents
==============================================================
    75                                               @profile
    76                                               def digest(self, img):
    77                                                   '''Execute a step of ratslam algorithm for a given image.
    78                                           
    79                                                   :param img: an gray-scale image as a 2D numpy array.
    80                                                   '''
    81                                           
    82      1006          987      1.0      0.0          x_pc, y_pc, th_pc = self.pose_cells.active
    83      1006         1039      1.0      0.0          time_view_cells = time.time()
    84      1006     76209245  75754.7     41.8  	view_cell = self.view_cells(img, x_pc, y_pc, th_pc)
    85      1006         1470      1.5      0.0          time_visual_odometry = time.time()
    86      1006      3148844   3130.1      1.7  	vtrans, vrot = self.visual_odometry(img)
    87      1006         1187      1.2      0.0  	time_pose_cells = time.time()
    88      1006     65635053  65243.6     36.0          x_pc, y_pc, th_pc = self.pose_cells(view_cell, vtrans, vrot)
    89      1006         2054      2.0      0.0          time_experience_map = time.time()
    90      1006     37445968  37222.6     20.5  	self.experience_map(view_cell, vtrans, vrot, x_pc, y_pc, th_pc)
    91      1006         1195      1.2      0.0  	time_all_done = time.time()
    92                                           
    93                                           	#print "%f %f %f %f %f" % ( (time_all_done - time_view_cells), (time_visual_odometry - time_view_cells), (time_pose_cells - time_visual_odometry), (time_experience_map - time_pose_cells), (time_all_done - time_experience_map) )
    94                                           
    95                                           	#self.f.write(str(time_all_done - time_view_cells) + ' ' + str(time_visual_odometry - time_view_cells) + ' ' + str(time_pose_cells - time_visual_odometry) + ' ' + str(time_experience_map - time_pose_cells) + ' ' + str(time_all_done - time_experience_map) + '\n')
    96                                                  
    97                                           	# TRACKING -------------------------------
    98      1006          775      0.8      0.0          x, y, th = self.visual_odometry.odometry
    99      1006          960      1.0      0.0          self.odometry[0].append(x)
   100      1006          626      0.6      0.0          self.odometry[1].append(y)
   101      1006          528      0.5      0.0          self.odometry[2].append(th)
   102      1006          760      0.8      0.0          self.pc[0].append(x_pc)
   103      1006          630      0.6      0.0          self.pc[1].append(y_pc)
   104      1006          553      0.5      0.0          self.pc[2].append(th_pc)

