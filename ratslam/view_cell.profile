Timer unit: 1e-06 s

Total time: 74.1233 s
File: ../ratslam/view_cells.py
Function: __call__ at line 109

Line #      Hits         Time  Per Hit   % Time  Line Contents
==============================================================
   109                                               @profile
   110                                               def __call__(self, img, x_pc, y_pc, th_pc):
   111                                                   '''Execute an interation of visual template.
   112                                           
   113                                                   :param img: the full gray-scaled image as a 2D numpy array.
   114                                                   :param x_pc: index x of the current pose cell.
   115                                                   :param y_pc: index y of the current pose cell.
   116                                                   :param th_pc: index th of the current pose cell.
   117                                                   :return: the active view cell.
   118                                                   '''
   119      1006       102118    101.5      0.1          template = self._create_template(img)
   120      1006     73748834  73309.0     99.5          scores = self._score(template)
   121                                           
   122                                                   # TO REMOVE
   123      1006          743      0.7      0.0          if scores:
   124      1005       222654    221.5      0.3              self.activated_cells = np.array(self.cells)[np.array(scores)*template.size<VT_MATCH_THRESHOLD]
   125                                                   # ----
   126                                           
   127      1006        29032     28.9      0.0          if not self.size or np.min(scores)*template.size > VT_MATCH_THRESHOLD:
   128       555         5024      9.1      0.0              cell = self.create_cell(template, x_pc, y_pc, th_pc)
   129       555          248      0.4      0.0              self.prev_cell = cell
   130       555          132      0.2      0.0              return cell
   131                                           
   132       451        13220     29.3      0.0          i = np.argmin(scores)
   133       451          331      0.7      0.0          cell = self.cells[i]
   134       451          326      0.7      0.0          cell.decay += VT_ACTIVE_DECAY
   135                                           
   136       451          328      0.7      0.0          if self.prev_cell != cell:
   137        70           34      0.5      0.0              cell.first = False
   138                                           
   139       451          154      0.3      0.0          self.prev_cell = cell
   140       451          131      0.3      0.0          return cell

