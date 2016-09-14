Timer unit: 1e-06 s

Total time: 72.0929 s
File: ../ratslam/view_cells.py
Function: _score at line 77

Line #      Hits         Time  Per Hit   % Time  Line Contents
==============================================================
    77                                               def _score(self, template):
    78                                                   '''Compute the similarity of a given template with all view cells.
    79                                           
    80                                                   :param template: 1D numpy array.
    81                                                   :return: 1D numpy array.
    82                                                   '''
    83                                                   scores = []
    84      1006         1142      1.1      0.0          for cell in self.cells:
    85    301433        78788      0.3      0.1  
    86                                                       cell.decay -= VT_GLOBAL_DECAY
    87    300427       172905      0.6      0.2              if cell.decay < 0:
    88    300427        96973      0.3      0.1                  cell.decay = 0
    89    290767        77539      0.3      0.1  
    90                                                       _, s = compare_segments(template, cell.template, VT_SHIFT_MATCH)
    91    300427     71476378    237.9     99.1              scores.append(s)
    92    300427       188900      0.6      0.3  
    93                                                   return scores

