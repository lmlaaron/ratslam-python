Timer unit: 1e-06 s

Total time: 86.5049 s
File: ../ratslam/_globals.py
Function: compare_segments at line 79

Line #      Hits         Time  Per Hit   % Time  Line Contents
==============================================================
    79                                           @profile
    80                                           def compare_segments(seg1, seg2, slen):
    81    302439       122065      0.4      0.1      cwl = seg1.size
    82                                           
    83    302439        77839      0.3      0.1      mindiff = 1e10
    84    302439        73842      0.2      0.1      minoffset = 0
    85                                           
    86    302439       465661      1.5      0.5      diffs = np.zeros(slen)
    87                                           
    88   6895098      1877790      0.3      2.2      for offset in xrange(slen+1):
    89   6592659      1802175      0.3      2.1          e = (cwl-offset)
    90                                           
    91   6592659     12172043      1.8     14.1          cdiff = np.abs(seg1[offset:cwl] - seg2[:e])
    92   6592659     25380935      3.8     29.3          cdiff = np.sum(cdiff)/e
    93                                           
    94   6592659      2164757      0.3      2.5          if cdiff < mindiff:
    95   2764366       734499      0.3      0.8              mindiff = cdiff
    96   2764366       688044      0.2      0.8              minoffset = offset
    97                                           
    98   6592659     12116161      1.8     14.0          cdiff = np.abs(seg1[:e] - seg2[offset:cwl])
    99   6592659     25101358      3.8     29.0          cdiff = np.sum(cdiff)/e
   100                                           
   101   6592659      2183302      0.3      2.5          if cdiff < mindiff:
   102   2561163       670558      0.3      0.8              mindiff = cdiff
   103   2561163       791349      0.3      0.9              minoffset = -offset
   104                                           
   105    302439        82542      0.3      0.1      return minoffset, mindiff

