Timer unit: 1e-06 s

Total time: 209.934 s
File: ../ratslam/experience_map.py
Function: __call__ at line 147

Line #      Hits         Time  Per Hit   % Time  Line Contents
==============================================================
   147                                               @profile
   148                                               def __call__(self, view_cell, vtrans, vrot, x_pc, y_pc, th_pc):
   149                                                   '''Run an interaction of the experience map.
   150                                           
   151                                                   :param view_cell: the last most activated view cell.
   152                                                   :param x_pc: index x of the current pose cell.
   153                                                   :param y_pc: index y of the current pose cell.
   154                                                   :param th_pc: index th of the current pose cell.
   155                                                   :param vtrans: the translation of the robot given by odometry.
   156                                                   :param vrot: the rotation of the robot given by odometry.
   157                                                   '''
   158                                           
   159                                                   #% integrate the delta x, y, facing
   160      1006         4080      4.1      0.0          self.accum_delta_facing = clip_rad_180(self.accum_delta_facing + vrot)
   161      1006         4689      4.7      0.0          self.accum_delta_x += vtrans*np.cos(self.accum_delta_facing)
   162      1006         2090      2.1      0.0          self.accum_delta_y += vtrans*np.sin(self.accum_delta_facing)
   163                                           
   164      1006          696      0.7      0.0          if self.current_exp is None:
   165         1            0      0.0      0.0              delta_pc = 0
   166                                                   else:
   167      1005          653      0.6      0.0              delta_pc = np.sqrt(
   168                                                           min_delta(self.current_exp.x_pc, x_pc, PC_DIM_XY)**2 + \
   169      1005        33091     32.9      0.0                  min_delta(self.current_exp.y_pc, y_pc, PC_DIM_XY)**2 + \
   170      1005        11250     11.2      0.0                  min_delta(self.current_exp.th_pc, th_pc, PC_DIM_TH)**2
   171                                                       )
   172                                           
   173                                                   # if the vt is new or the pc x,y,th has changed enough create a new
   174                                                   # experience
   175      1006          696      0.7      0.0          adjust_map = False
   176      1006         1688      1.7      0.0          if len(view_cell.exps) == 0 or delta_pc > EXP_DELTA_PC_THRESHOLD:
   177       633        19626     31.0      0.0              exp = self._create_exp(x_pc, y_pc, th_pc, view_cell)
   178                                           
   179       633          427      0.7      0.0              self.current_exp = exp
   180       633          486      0.8      0.0              self.accum_delta_x = 0
   181       633          368      0.6      0.0              self.accum_delta_y = 0
   182       633          449      0.7      0.0              self.accum_delta_facing = self.current_exp.facing_rad
   183                                           
   184                                                   # if the vt has changed (but isn't new) search for the matching exp
   185       373          349      0.9      0.0          elif view_cell != self.current_exp.view_cell:
   186                                           
   187                                                       # find the exp associated with the current vt and that is under the
   188                                                       # threshold distance to the centre of pose cell activity
   189                                                       # if multiple exps are under the threshold then don't match (to reduce
   190                                                       # hash collisions)
   191       291          168      0.6      0.0              adjust_map = True
   192       291          158      0.5      0.0              matched_exp = None
   193                                           
   194       291          160      0.5      0.0              delta_pcs = []
   195       291          162      0.6      0.0              n_candidate_matches = 0
   196     20542        13750      0.7      0.0              for (i, e) in enumerate(view_cell.exps):
   197     20251        11017      0.5      0.0                  delta_pc = np.sqrt(
   198                                                               min_delta(e.x_pc, x_pc, PC_DIM_XY)**2 + \
   199     20251       325696     16.1      0.2                      min_delta(e.y_pc, y_pc, PC_DIM_XY)**2 + \
   200     20251       189098      9.3      0.1                      min_delta(e.th_pc, th_pc, PC_DIM_TH)**2
   201                                                           )
   202     20251        17918      0.9      0.0                  delta_pcs.append(delta_pc)
   203                                           
   204     20251        12089      0.6      0.0                  if delta_pc < EXP_DELTA_PC_THRESHOLD:
   205       174          115      0.7      0.0                      n_candidate_matches += 1
   206                                           
   207       291          167      0.6      0.0              if n_candidate_matches > 1:
   208                                                           pass
   209                                           
   210                                                       else:
   211       291         4770     16.4      0.0                  min_delta_id = np.argmin(delta_pcs)
   212       291          254      0.9      0.0                  min_delta_val = delta_pcs[min_delta_id]
   213                                           
   214       291          169      0.6      0.0                  if min_delta_val < EXP_DELTA_PC_THRESHOLD:
   215       174          121      0.7      0.0                      matched_exp = view_cell.exps[min_delta_id]
   216                                           
   217                                                               # see if the prev exp already has a link to the current exp
   218       174          106      0.6      0.0                      link_exists = False
   219       174          188      1.1      0.0                      for linked_exp in [l.target for l in self.current_exp.links]:
   220                                                                   if linked_exp == matched_exp:
   221                                                                       link_exists = True
   222                                           
   223       174           96      0.6      0.0                      if not link_exists:
   224       174         3903     22.4      0.0                          self.current_exp.link_to(matched_exp, self.accum_delta_x, self.accum_delta_y, self.accum_delta_facing)
   225                                           
   226       291          180      0.6      0.0                  if matched_exp is None:
   227       117         3637     31.1      0.0                      matched_exp = self._create_exp(x_pc, y_pc, th_pc, view_cell)
   228                                           
   229       291          197      0.7      0.0                  self.current_exp = matched_exp
   230       291          198      0.7      0.0                  self.accum_delta_x = 0
   231       291          185      0.6      0.0                  self.accum_delta_y = 0
   232       291          220      0.8      0.0                  self.accum_delta_facing = self.current_exp.facing_rad
   233                                           
   234      1006         1053      1.0      0.0          self.history.append(self.current_exp)
   235                                           
   236      1006          573      0.6      0.0          if not adjust_map:
   237       715          357      0.5      0.0              return
   238                                           
   239                                           
   240                                                   # Iteratively update the experience map with the new information     
   241     29391        16840      0.6      0.0          for i in range(0, EXP_LOOPS):
   242  11046200      5804422      0.5      2.8              for e0 in self.exps:
   243  24476000     14930496      0.6      7.1                  for l in e0.links:
   244                                                               # e0 is the experience under consideration
   245                                                               # e1 is an experience linked from e0
   246                                                               # l is the link object which contains additoinal heading
   247                                                               # info
   248                                           
   249  13458900      7538519      0.6      3.6                      e1 = l.target
   250                                                               
   251                                                               # correction factor
   252  13458900      7178719      0.5      3.4                      cf = EXP_CORRECTION
   253                                                               
   254                                                               # work out where exp0 thinks exp1 (x,y) should be based on 
   255                                                               # the stored link information
   256  13458900     20165417      1.5      9.6                      lx = e0.x_m + l.d * np.cos(e0.facing_rad + l.heading_rad)
   257  13458900     18266636      1.4      8.7                      ly = e0.y_m + l.d * np.sin(e0.facing_rad + l.heading_rad);
   258                                           
   259                                                               # correct e0 and e1 (x,y) by equal but opposite amounts
   260                                                               # a 0.5 correction parameter means that e0 and e1 will be 
   261                                                               # fully corrected based on e0's link information
   262  13458900     11144664      0.8      5.3                      e0.x_m = e0.x_m + (e1.x_m - lx) * cf
   263  13458900     10399205      0.8      5.0                      e0.y_m = e0.y_m + (e1.y_m - ly) * cf
   264  13458900     10295572      0.8      4.9                      e1.x_m = e1.x_m - (e1.x_m - lx) * cf
   265  13458900     10215274      0.8      4.9                      e1.y_m = e1.y_m - (e1.y_m - ly) * cf
   266                                           
   267                                                               # determine the angle between where e0 thinks e1's facing
   268                                                               # should be based on the link information
   269  13458900      8493127      0.6      4.0                      df = signed_delta_rad(e0.facing_rad + l.facing_rad, 
   270  13458900     50900606      3.8     24.2                                            e1.facing_rad)
   271                                           
   272                                                               # correct e0 and e1 facing by equal but opposite amounts
   273                                                               # a 0.5 correction parameter means that e0 and e1 will be 
   274                                                               # fully corrected based on e0's link information           
   275  13458900     17325635      1.3      8.3                      e0.facing_rad = clip_rad_180(e0.facing_rad + df * cf)
   276  13458900     16591668      1.2      7.9                      e1.facing_rad = clip_rad_180(e1.facing_rad - df * cf)
   277                                               
   278       291          149      0.5      0.0          return

